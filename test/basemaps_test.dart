import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/basemaps.dart';
import 'package:kik_ais/themes.dart';

void main() {
  test('baseMapById resolves known ids and falls back to the first', () {
    expect(baseMapById('carto-dark').label, 'Dark Matter');
    expect(baseMapById('esri-satellite').label, 'Esri Satellite');
    expect(baseMapById('unknown-id').id, kBaseMaps.first.id);
  });

  test('default basemap follows the theme', () {
    expect(defaultBasemapIdFor(AppTheme.light), 'carto-voyager');
    expect(defaultBasemapIdFor(AppTheme.dark), 'carto-dark');
    expect(defaultBasemapIdFor(AppTheme.highContrast), 'carto-dark');
  });

  test('every basemap has a usable URL template', () {
    for (final b in kBaseMaps) {
      expect(b.urlTemplate, isNotEmpty);
      expect(b.attribution, isNotEmpty);
      expect(b.urlTemplate, contains('{z}'));
    }
  });
}
