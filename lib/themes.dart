import 'package:flutter/material.dart';

/// The selectable application themes.
enum AppTheme {
  dark('Dark', Icons.dark_mode),
  light('Light', Icons.light_mode),
  highContrast('High contrast', Icons.high_quality);

  const AppTheme(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Semantic colors shared across the UI (KPI cards, status chips, accents).
/// Accessed through `Theme.of(context).extension<AppColors>()`.
class AppColors extends ThemeExtension<AppColors> {
  final Color info;
  final Color success;
  final Color warning;
  final Color danger;

  const AppColors({
    required this.info,
    required this.success,
    required this.warning,
    required this.danger,
  });

  static const dark = AppColors(
    info: Colors.lightBlueAccent,
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFB300),
    danger: Color(0xFFEF5350),
  );

  static const light = AppColors(
    info: Color(0xFF1976D2),
    success: Color(0xFF2E7D32),
    warning: Color(0xFFF9A825),
    danger: Color(0xFFD32F2F),
  );

  static const highContrast = AppColors(
    info: Colors.cyanAccent,
    success: Color(0xFF00E676),
    warning: Color(0xFFFFEA00),
    danger: Color(0xFFFF5252),
  );

  @override
  AppColors copyWith({
    Color? info,
    Color? success,
    Color? warning,
    Color? danger,
  }) =>
      AppColors(
        info: info ?? this.info,
        success: success ?? this.success,
        warning: warning ?? this.warning,
        danger: danger ?? this.danger,
      );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      info: Color.lerp(info, other.info, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}

/// Builds the full [ThemeData] for the requested [AppTheme].
///
/// Results are cached per [AppTheme] so that widget rebuilds triggered by
/// unrelated settings changes (locale, targets, map toggles...) don't create a
/// brand-new [ThemeData] every time, which would otherwise cascade a theme
/// change to the whole widget tree via `Theme.of(context)`.
ThemeData buildAppTheme(AppTheme theme) {
  return _themeCache.putIfAbsent(theme, () {
    switch (theme) {
      case AppTheme.dark:
        return _darkTheme();
      case AppTheme.light:
        return _lightTheme();
      case AppTheme.highContrast:
        return _highContrastTheme();
    }
  });
}

final Map<AppTheme, ThemeData> _themeCache = {};

ThemeData _darkTheme() {
  final scheme = ColorScheme.dark(
    primary: Colors.lightBlueAccent,
    secondary: Colors.blue,
    surface: Colors.grey[800]!,
  );
  return _base(
    brightness: Brightness.dark,
    scheme: scheme,
    scaffold: Colors.grey[900]!,
    card: Colors.grey[800]!,
    onBackground: Colors.white,
    onBackgroundMuted: Colors.white70,
    onBackgroundFaint: Colors.white60,
    tooltipBackground: Colors.grey[900]!,
    tooltipBorder: Colors.lightBlueAccent,
    appColors: AppColors.dark,
  );
}

ThemeData _lightTheme() {
  final scheme = ColorScheme.light(
    primary: const Color(0xFF1976D2),
    secondary: Colors.lightBlue,
    surface: Colors.white,
  );
  return _base(
    brightness: Brightness.light,
    scheme: scheme,
    scaffold: const Color(0xFFECEFF1),
    card: Colors.white,
    onBackground: Colors.black87,
    onBackgroundMuted: Colors.black54,
    onBackgroundFaint: Colors.black45,
    tooltipBackground: Colors.grey[800]!,
    tooltipBorder: const Color(0xFF1976D2),
    appColors: AppColors.light,
  );
}

ThemeData _highContrastTheme() {
  final scheme = ColorScheme.dark(
    primary: Colors.cyanAccent,
    secondary: Colors.yellowAccent,
    surface: const Color(0xFF101010),
    error: const Color(0xFFFF5252),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
  );
  return _base(
    brightness: Brightness.dark,
    scheme: scheme,
    scaffold: Colors.black,
    card: const Color(0xFF101010),
    onBackground: Colors.white,
    onBackgroundMuted: Colors.white,
    onBackgroundFaint: Colors.white70,
    tooltipBackground: Colors.black,
    tooltipBorder: Colors.cyanAccent,
    strongBorders: true,
    appColors: AppColors.highContrast,
  );
}

ThemeData _base({
  required Brightness brightness,
  required ColorScheme scheme,
  required Color scaffold,
  required Color card,
  required Color onBackground,
  required Color onBackgroundMuted,
  required Color onBackgroundFaint,
  required Color tooltipBackground,
  required Color tooltipBorder,
  bool strongBorders = false,
  AppColors appColors = AppColors.dark,
}) {
  final borderSide = strongBorders
      ? const BorderSide(color: Colors.white54, width: 1.5)
      : const BorderSide(color: Colors.white24, width: 1);

  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    // The default Material 3 "ink sparkle" splash renders a shader effect on
    // press; on Windows it crashes (access violation in the engine's GPU/texture
    // path). Use the classic ripple instead.
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: scaffold,
    cardColor: card,
    canvasColor: card,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: onBackground),
      bodyMedium: TextStyle(color: onBackgroundMuted),
      bodySmall: TextStyle(color: onBackgroundFaint),
      titleLarge: TextStyle(color: onBackground),
      titleMedium: TextStyle(color: onBackground),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderSide,
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scaffold,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    switchTheme: SwitchThemeData(
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.onPrimary;
        }
        return scheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return scheme.surfaceContainerHighest;
      }),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.6),
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: BoxDecoration(
        color: tooltipBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tooltipBorder, width: 1),
      ),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 5),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: strongBorders ? Colors.black : tooltipBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: strongBorders
            ? const BorderSide(color: Colors.white54)
            : BorderSide.none,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: strongBorders
            ? const BorderSide(color: Colors.white38)
            : BorderSide.none,
      ),
    ),
    extensions: [appColors],
  );
}
