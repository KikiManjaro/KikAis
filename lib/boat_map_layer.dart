import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import 'boat.dart';

const Duration _kAnimDuration = Duration(milliseconds: 600);

/// Per-boat animation state: interpolates position and heading between two
/// received updates so vessels glide instead of teleporting.
class _AnimatedBoat {
  final Boat boat;
  final LatLng from;
  final LatLng to;
  final double fromHeading;
  final double toHeading;
  final DateTime start;

  _AnimatedBoat({
    required this.boat,
    required this.from,
    required this.to,
    required this.fromHeading,
    required this.toHeading,
    required this.start,
  });

  bool get isMoving =>
      from.latitude != to.latitude || from.longitude != to.longitude;

  double fraction(DateTime now) {
    final d = now.difference(start).inMilliseconds /
        _kAnimDuration.inMilliseconds;
    return d.clamp(0.0, 1.0);
  }
}

class _Cluster {
  final Offset center;
  final List<_AnimatedBoat> members;

  _Cluster(this.center, this.members);
}

/// A full-map canvas layer that draws every vessel as a vector shape (rotated
/// by heading, colored by kind), with optional trails, labels and clustering.
///
/// Uses a single `CustomPainter`, so thousands of vessels render smoothly.
class BoatMapLayer extends StatefulWidget {
  final List<Boat> boats;
  final bool clusterEnabled;
  final bool showTrails;
  final bool showVectors;
  final ValueChanged<Boat>? onBoatTap;
  final ValueChanged<LatLng>? onClusterTap;
  final ValueChanged<Boat?>? onBoatHover;

  const BoatMapLayer({
    super.key,
    required this.boats,
    this.clusterEnabled = false,
    this.showTrails = true,
    this.showVectors = true,
    this.onBoatTap,
    this.onClusterTap,
    this.onBoatHover,
  });

  @override
  State<BoatMapLayer> createState() => _BoatMapLayerState();
}

class _BoatMapLayerState extends State<BoatMapLayer>
    with SingleTickerProviderStateMixin {
  final Map<String, _AnimatedBoat> _display = {};
  final Map<String, List<LatLng>> _trails = {};
  final ValueNotifier<int> _repaint = ValueNotifier(0);
  late final Ticker _ticker;

  Offset _down = Offset.zero;
  String? _lastHoveredMmsi;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _syncBoats(widget.boats);
    if (_anyMoving()) _ticker.start();
  }

  @override
  void didUpdateWidget(BoatMapLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.boats, widget.boats)) {
      _syncBoats(widget.boats);
      _repaint.value++;
      if (_anyMoving() && !_ticker.isActive) _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  bool _anyMoving() => _display.values.any((ab) => ab.isMoving);

  void _syncBoats(List<Boat> boats) {
    final now = DateTime.now();
    final next = <String, _AnimatedBoat>{};
    for (final b in boats) {
      if (b.lat == null || b.lon == null) continue;
      final cur = LatLng(b.lat!, b.lon!);
      final heading = b.heading ?? b.cog ?? 0.0;
      final prev = _display[b.mmsi];
      final moved = prev != null &&
          (prev.to.latitude != cur.latitude ||
              prev.to.longitude != cur.longitude);
      next[b.mmsi] = _AnimatedBoat(
        boat: b,
        from: moved ? prev.to : cur,
        to: cur,
        fromHeading: moved ? prev.toHeading : heading,
        toHeading: heading,
        start: now,
      );
      final trail = _trails.putIfAbsent(b.mmsi, () => []);
      if (trail.isEmpty ||
          (trail.last.latitude != cur.latitude ||
              trail.last.longitude != cur.longitude)) {
        trail.add(cur);
      }
      if (trail.length > 24) trail.removeAt(0);
    }
    _trails.removeWhere((k, _) => !next.containsKey(k));
    _display
      ..clear()
      ..addAll(next);
  }

  void _onTick(Duration _) {
    final now = DateTime.now();
    var busy = false;
    for (final ab in _display.values) {
      if (ab.fraction(now) < 1.0) {
        busy = true;
        break;
      }
    }
    _repaint.value++;
    if (!busy && _ticker.isActive) _ticker.stop();
  }

  LatLng _displayLatLng(_AnimatedBoat ab) {
    final f = _ease(ab.fraction(DateTime.now()));
    return LatLng(
      ab.from.latitude + (ab.to.latitude - ab.from.latitude) * f,
      ab.from.longitude + (ab.to.longitude - ab.from.longitude) * f,
    );
  }

  List<_Cluster> _clusters(MapCamera camera, {double cellSize = 44}) {
    final cells = <int, List<_AnimatedBoat>>{};
    for (final ab in _display.values) {
      final pos = camera.latLngToScreenOffset(_displayLatLng(ab));
      final key = (pos.dx ~/ cellSize) * 100000 + (pos.dy ~/ cellSize);
      cells.putIfAbsent(key, () => []).add(ab);
    }
    return cells.values.map((members) {
      var dx = 0.0;
      var dy = 0.0;
      for (final ab in members) {
        final pos = camera.latLngToScreenOffset(_displayLatLng(ab));
        dx += pos.dx;
        dy += pos.dy;
      }
      return _Cluster(Offset(dx / members.length, dy / members.length), members);
    }).toList();
  }

  void _hitTest(Offset pos, MapCamera camera) {
    if (widget.clusterEnabled) {
      for (final cluster in _clusters(camera)) {
        if (cluster.members.length > 1 &&
            (cluster.center - pos).distance <= 20) {
          final latLng = camera.screenOffsetToLatLng(cluster.center);
          widget.onClusterTap?.call(latLng);
          return;
        }
      }
    }

    _AnimatedBoat? best;
    var bestDist = double.infinity;
    for (final ab in _display.values) {
      final offset = camera.latLngToScreenOffset(_displayLatLng(ab));
      final d = (offset - pos).distance;
      if (d < bestDist) {
        bestDist = d;
        best = ab;
      }
    }
    if (best != null && bestDist <= 16) {
      widget.onBoatTap?.call(best.boat);
    }
  }

  void _hover(Offset pos, MapCamera camera) {
    _AnimatedBoat? best;
    var bestDist = double.infinity;
    for (final ab in _display.values) {
      final offset = camera.latLngToScreenOffset(_displayLatLng(ab));
      final d = (offset - pos).distance;
      if (d < bestDist) {
        bestDist = d;
        best = ab;
      }
    }
    final boat = best != null && bestDist <= 18 ? best.boat : null;
    final mmsi = boat?.mmsi;
    if (mmsi != _lastHoveredMmsi) {
      _lastHoveredMmsi = mmsi;
      widget.onBoatHover?.call(boat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final camera = MapCamera.of(context);
    final boats = List<_AnimatedBoat>.of(_display.values);
    final trails = Map<String, List<LatLng>>.of(_trails);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) => _down = e.localPosition,
      onPointerUp: (e) {
        if ((e.localPosition - _down).distance > 6) return;
        _hitTest(e.localPosition, camera);
      },
      onPointerMove: (e) => _hover(e.localPosition, camera),
      onPointerCancel: (_) {
        if (_lastHoveredMmsi != null) {
          _lastHoveredMmsi = null;
          widget.onBoatHover?.call(null);
        }
      },
      child: CustomPaint(
        size: Size.infinite,
        painter: _BoatPainter(
          boats: boats,
          trails: trails,
          camera: camera,
          clusterEnabled: widget.clusterEnabled,
          showTrails: widget.showTrails,
          showVectors: widget.showVectors,
          now: DateTime.now,
          repaint: _repaint,
        ),
      ),
    );
  }
}

double _ease(double t) => t >= 1.0 ? 1.0 : 1 - math.pow(1 - t, 3).toDouble();

double _lerpAngle(double a, double b, double f) {
  var d = (b - a) % 360;
  if (d > 180) d -= 360;
  if (d < -180) d += 360;
  return (a + d * f) % 360;
}

class _BoatPainter extends CustomPainter {
  final List<_AnimatedBoat> boats;
  final Map<String, List<LatLng>> trails;
  final MapCamera camera;
  final bool clusterEnabled;
  final bool showTrails;
  final bool showVectors;
  final DateTime Function() now;

  _BoatPainter({
    required this.boats,
    required this.trails,
    required this.camera,
    required this.clusterEnabled,
    required this.showTrails,
    required this.showVectors,
    required this.now,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (showTrails) {
      _paintTrails(canvas);
    }

    if (clusterEnabled) {
      final clusters = _computeClusters();
      for (final cluster in clusters) {
        if (cluster.members.length > 1) {
          _paintCluster(canvas, cluster);
        } else {
          _paintBoat(canvas, cluster.members.first);
        }
      }
      return;
    }

    for (final ab in boats) {
      _paintBoat(canvas, ab);
    }
  }

  void _paintTrails(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (final trail in trails.values) {
      if (trail.length < 2) continue;
      final path = Path();
      var started = false;
      for (final p in trail) {
        final o = camera.latLngToScreenOffset(p);
        if (!started) {
          path.moveTo(o.dx, o.dy);
          started = true;
        } else {
          path.lineTo(o.dx, o.dy);
        }
      }
      paint.color = const Color(0xFF4C9BFF).withValues(alpha: 0.35);
      canvas.drawPath(path, paint);
    }
  }

  List<_Cluster> _computeClusters({double cellSize = 44}) {
    final cells = <int, List<_AnimatedBoat>>{};
    for (final ab in boats) {
      final pos = camera.latLngToScreenOffset(_pos(ab));
      final key = (pos.dx ~/ cellSize) * 100000 + (pos.dy ~/ cellSize);
      cells.putIfAbsent(key, () => []).add(ab);
    }
    return cells.values.map((members) {
      var dx = 0.0;
      var dy = 0.0;
      for (final ab in members) {
        final pos = camera.latLngToScreenOffset(_pos(ab));
        dx += pos.dx;
        dy += pos.dy;
      }
      return _Cluster(Offset(dx / members.length, dy / members.length), members);
    }).toList();
  }

  void _paintCluster(Canvas canvas, _Cluster cluster) {
    final n = cluster.members.length;
    canvas.drawCircle(
      cluster.center,
      16,
      Paint()..color = const Color(0xFF3D7EFF).withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      cluster.center,
      16,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );
    _text(
      canvas,
      cluster.center.dx,
      cluster.center.dy,
      '$n',
      color: Colors.white,
      bold: true,
      fontSize: 12,
      anchorCenter: true,
    );
  }

  void _paintBoat(Canvas canvas, _AnimatedBoat ab) {
    final pos = _pos(ab);
    if (!camera.visibleBounds.contains(pos)) return;
    final o = camera.latLngToScreenOffset(pos);
    if (o.dx < -30 || o.dy < -30 || o.dx > camera.size.width + 30 ||
        o.dy > camera.size.height + 30) {
      return;
    }

    final color = _kindColor(ab.boat.kind);
    final heading = _displayHeading(ab);

    if (showVectors) {
      _paintVelocityVector(canvas, o, ab.boat, heading, color);
    }

    canvas.save();
    canvas.translate(o.dx, o.dy);
    canvas.drawCircle(
      Offset.zero,
      10,
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.rotate(heading * math.pi / 180);
    switch (ab.boat.kind) {
      case BoatKind.aircraft:
        _drawAircraft(canvas, color);
      case BoatKind.aton:
        _drawAton(canvas, color);
      case BoatKind.station:
        _drawStation(canvas, color);
      case BoatKind.vessel:
        _drawVessel(canvas, color);
    }
    canvas.restore();

    if (camera.zoom >= 9 && ab.boat.name?.trim().isNotEmpty == true) {
      _paintLabel(canvas, o, ab.boat.name!.trim());
    }
  }

  void _paintVelocityVector(
    Canvas canvas,
    Offset o,
    Boat boat,
    double heading,
    Color color,
  ) {
    if (boat.kind == BoatKind.aton || boat.kind == BoatKind.station) return;
    final sog = boat.sog ?? 0;
    if (sog < 0.3) return;
    final angle = heading * math.pi / 180;
    final length = (5 + sog * 2).clamp(10.0, 50.0);
    final dx = math.sin(angle) * length;
    final dy = -math.cos(angle) * length;
    final end = o + Offset(dx, dy);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..color = color.withValues(alpha: 0.8);
    canvas.drawLine(o, end, paint);
  }

  void _drawVessel(Canvas canvas, Color color) {
    final tip = Offset(0, -8);
    final left = Offset(-5, 6);
    final right = Offset(5, 6);
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(Offset.zero, 2.4, Paint()..color = Colors.white);
  }

  void _drawAircraft(Canvas canvas, Color color) {
    final nose = Offset(0, -9);
    final left = Offset(-5, 4);
    final right = Offset(5, 4);
    final tail = Offset(0, 8);
    final path = Path()
      ..moveTo(nose.dx, nose.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(tail.dx, tail.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    final wing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white;
    canvas.drawLine(const Offset(-7, -1), const Offset(7, -1), wing);
  }

  void _drawAton(Canvas canvas, Color color) {
    final path = Path()
      ..moveTo(0, -7)
      ..lineTo(6, 0)
      ..lineTo(0, 7)
      ..lineTo(-6, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(Offset.zero, 1.6, Paint()..color = Colors.white);
  }

  void _drawStation(Canvas canvas, Color color) {
    final rect = Rect.fromCenter(center: Offset.zero, width: 8, height: 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()..color = color,
    );
    canvas.drawLine(
      const Offset(0, -4),
      const Offset(0, -9),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = Colors.white,
    );
  }

  void _paintLabel(Canvas canvas, Offset o, String name) {
    final painter = _textPainter(name, fontSize: 11, bold: true);
    final w = painter.width + 10;
    final h = painter.height + 4;
    final top = o.dy - 20 - h;
    final rect = Rect.fromLTWH(o.dx - w / 2, top, w, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(5)),
      Paint()..color = const Color(0xCC000000),
    );
    painter.paint(canvas, Offset(rect.left + 5, rect.top + 2));
  }

  void _text(
    Canvas canvas,
    double x,
    double y,
    String text, {
    Color color = Colors.white,
    bool bold = false,
    double fontSize = 12,
    bool anchorCenter = false,
  }) {
    final painter = _textPainter(text, fontSize: fontSize, bold: bold, color: color);
    final dx = anchorCenter ? x - painter.width / 2 : x;
    final dy = anchorCenter ? y - painter.height / 2 : y;
    painter.paint(canvas, Offset(dx, dy));
  }

  TextPainter _textPainter(
    String text, {
    required double fontSize,
    bool bold = false,
    Color color = Colors.white,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter;
  }

  LatLng _pos(_AnimatedBoat ab) {
    final f = _ease(ab.fraction(now()));
    return LatLng(
      ab.from.latitude + (ab.to.latitude - ab.from.latitude) * f,
      ab.from.longitude + (ab.to.longitude - ab.from.longitude) * f,
    );
  }

  double _displayHeading(_AnimatedBoat ab) {
    final f = _ease(ab.fraction(now()));
    return _lerpAngle(ab.fromHeading, ab.toHeading, f);
  }

  Color _kindColor(BoatKind kind) => switch (kind) {
        BoatKind.vessel => const Color(0xFF4C9BFF),
        BoatKind.aircraft => const Color(0xFFFF8A3D),
        BoatKind.aton => const Color(0xFF2EC4B6),
        BoatKind.station => const Color(0xFFB65CE8),
      };

  @override
  bool shouldRepaint(_BoatPainter oldDelegate) =>
      !identical(oldDelegate.boats, boats) ||
      oldDelegate.camera != camera ||
      oldDelegate.clusterEnabled != clusterEnabled ||
      oldDelegate.showTrails != showTrails ||
      oldDelegate.showVectors != showVectors;
}
