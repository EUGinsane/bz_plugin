
import 'dart:async';

import 'package:flutter/services.dart';

class BzPlugin {
  static const MethodChannel _channel = MethodChannel('bz_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool?> isToday(DateTime dateTime) async {
    final date = dateTime.toUtc().toIso8601String();
    final bool? isSuccess = await _channel.invokeMethod(
      'isToday',
      {
        'dateTime': date,
      },
    );
    return isSuccess;
  }
}
