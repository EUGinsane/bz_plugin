import 'dart:async';

import 'package:flutter/services.dart';

class BzPlugin {
  static const MethodChannel _channel = MethodChannel('bz_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

    static Future<void> init(String clientId, String passkey) async {
    await _channel.invokeMethod(
      'init',
      {
        'clientId': clientId,
        'passkey': passkey
      },
    );
  }

  // ignore: non_constant_identifier_names
  static Future<void> BVPageViewEvent(
      String? productId, String? categoryId) async {
    await _channel.invokeMethod(
      'BVPageViewEvent',
      {
        'productId': productId,
        'category': categoryId
      },
    );
  }

  // ignore: non_constant_identifier_names
  static Future<void> BVConversionEvent(
      String? categoryId) async {
    await _channel.invokeMethod(
      'BVConversionEvent',
      {'category': categoryId},
    );
  }
}
