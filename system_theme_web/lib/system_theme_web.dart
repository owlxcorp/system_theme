import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as html;

import 'package:flutter/services.dart';

/// A web implementation of the SystemTheme plugin.
class SystemThemeWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'system_theme',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SystemThemeWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'SystemTheme.accentColor':
        final e = html.document.body;
        final currentBackgroundColor = e?.style.backgroundColor;
        e?.style.backgroundColor = "highlight";
        String? backgroundColor =
            e?.computedStyleMap().get('backgroundColor').toString();
        e?.style.backgroundColor =
            currentBackgroundColor ?? e.style.backgroundColor;
        if (backgroundColor != null) {
          backgroundColor = backgroundColor
              .replaceAll('rgb(', '')
              .replaceAll(')', '')
              .replaceAll(' ', '');
          final rgb = backgroundColor.split(',');
          return {
            'accent': {
              'R': int.parse(rgb[0]),
              'G': int.parse(rgb[1]),
              'B': int.parse(rgb[2]),
            }
          };
        }
        return null;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'system_theme for web doesn\'t implement \'${call.method}\'',
        );
    }
  }
}
