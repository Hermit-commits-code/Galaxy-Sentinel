import 'package:flutter/services.dart';

class SystemDataChannel {
  static const MethodChannel _channel = MethodChannel('com.galaxysentinel.data');

  /// Returns CPU temperature in Celsius, or null if unavailable.
  static Future<double?> fetchCpuTemperature() async {
    try {
      final dynamic res = await _channel.invokeMethod('getCpuTemp');
      if (res == null) return null;
      if (res is double) return res;
      if (res is int) return res.toDouble();
      if (res is String) return double.tryParse(res);
      return null;
    } on PlatformException {
      return null;
    }
  }
}