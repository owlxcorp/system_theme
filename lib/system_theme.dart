import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Default system accent color.
const kDefaultSystemAccentColor = Color(0xff00b7c3);

const kGetDarkModeMethod = 'SystemTheme.darkMode';
const kGetSystemAccentColorMethod = 'SystemTheme.accentColor';

/// Platform channel handler for invoking native methods.
const MethodChannel _channel = MethodChannel('system_theme');

/// Class to return current system theme state on Windows.
///
/// [SystemTheme.isDarkMode] returns whether currently dark mode is enabled or
/// not.
///
/// [SystemTheme.accentColor] returns the current accent color as
/// [SystemAccentColor].
class SystemTheme {
  /// Get the system accent color.
  ///
  /// This is available for the following platforms:
  ///   - Windows
  ///   - Web
  ///   - Android
  ///
  /// It returns [kDefaultSystemAccentColor] for unsupported platforms
  static final SystemAccentColor accentColor =
      SystemAccentColor(kDefaultSystemAccentColor)..load();

  /// Wheter the dark mode is enabled or not. Defaults to `false`
  ///
  /// It returns `false` for unsupported platforms
  static bool get isDarkMode {
    return ui.window.platformBrightness == Brightness.dark;
  }
}

/// Defines accent colors & its variants.
/// Colors are cached by default, call [SystemAccentColor.load] to update the
/// colors.
///
/// It returns [SystemAccentColor.defaultAccentColor] if
/// [SystemAccentColor.load] fails
class SystemAccentColor {
  final Color defaultAccentColor;

  /// Base accent color.
  late Color accent;

  /// Light shade.
  late Color light;

  /// Lighter shade.
  late Color lighter;

  /// Lighest shade.
  late Color lightest;

  /// Darkest shade.
  late Color dark;

  /// Darker shade.
  late Color darker;

  /// Darkest shade.
  late Color darkest;

  SystemAccentColor(this.defaultAccentColor) {
    accent = defaultAccentColor;
    light = defaultAccentColor;
    lighter = defaultAccentColor;
    lightest = defaultAccentColor;
    dark = defaultAccentColor;
    darker = defaultAccentColor;
    darkest = defaultAccentColor;
  }

  /// Updates the fetched accent colors on Windows.
  Future<void> load() async {
    WidgetsFlutterBinding.ensureInitialized();

    final colors = await _channel.invokeMethod(kGetSystemAccentColorMethod);
    if (colors == null) return;

    accent = _retrieve(colors['accent'])!;
    light = _retrieve(colors['light']) ?? accent;
    lighter = _retrieve(colors['lighter']) ?? accent;
    lightest = _retrieve(colors['lightest']) ?? accent;
    dark = _retrieve(colors['dark']) ?? accent;
    darker = _retrieve(colors['darker']) ?? accent;
    darkest = _retrieve(colors['darkest']) ?? accent;
  }

  Color? _retrieve(dynamic map) {
    if (map == null) return null;
    return Color.fromRGBO(map['R'], map['G'], map['B'], 1.0);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SystemAccentColor &&
        other.defaultAccentColor == defaultAccentColor &&
        other.accent == accent &&
        other.light == light &&
        other.lighter == lighter &&
        other.lightest == lightest &&
        other.dark == dark &&
        other.darker == darker &&
        other.darkest == darkest;
  }

  @override
  int get hashCode {
    return defaultAccentColor.hashCode ^
        accent.hashCode ^
        light.hashCode ^
        lighter.hashCode ^
        lightest.hashCode ^
        dark.hashCode ^
        darker.hashCode ^
        darkest.hashCode;
  }

  @override
  String toString() {
    return 'SystemAccentColor(defaultAccentColor: $defaultAccentColor, accent: $accent, light: $light, lighter: $lighter, lightest: $lightest, dark: $dark, darker: $darker, darkest: $darkest)';
  }
}
