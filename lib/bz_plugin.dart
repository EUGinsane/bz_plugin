
import 'dart:async';

import 'package:flutter/services.dart';

class BzPlugin {
  static const MethodChannel _channel = MethodChannel('bz_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // ignore: non_constant_identifier_names
  static Future<void> BVPageViewEvent(String clientId, String passkey, String? productId, String? categoryId) async {
    await _channel.invokeMethod(
      'BVPageViewEvent',
      {
        'productId': productId,
        'categoryId': categoryId,
        'clientId': clientId,
        'passkey': passkey
      },
    );
  }
  // ignore: non_constant_identifier_names
  static Future<void> BVConversionEvent(String clientId, String passkey, String? categoryId) async {
    await _channel.invokeMethod(
      'BVConversionEvent',
      {
        'categoryId': categoryId,
        'clientId': clientId,
        'passkey': passkey
      },
    );
  }
}
