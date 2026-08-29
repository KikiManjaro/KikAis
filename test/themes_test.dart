import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/themes.dart';

void main() {
  test('buildAppTheme applies the right brightness per theme', () {
    expect(buildAppTheme(AppTheme.dark).brightness, Brightness.dark);
    expect(buildAppTheme(AppTheme.light).brightness, Brightness.light);
    expect(buildAppTheme(AppTheme.highContrast).brightness, Brightness.dark);
  });

  test('high contrast theme uses strong card borders and pure white text', () {
    final theme = buildAppTheme(AppTheme.highContrast);
    expect(theme.scaffoldBackgroundColor, Colors.black);
    expect(theme.textTheme.bodyLarge?.color, Colors.white);

    final shape = theme.cardTheme.shape! as RoundedRectangleBorder;
    expect(shape.side.width, 1.5);
  });

  test('dark theme keeps the brand accent', () {
    final theme = buildAppTheme(AppTheme.dark);
    expect(theme.colorScheme.primary, Colors.lightBlueAccent);
    expect(theme.scaffoldBackgroundColor, Colors.grey[900]);
  });
}
