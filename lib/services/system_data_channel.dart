import 'package:flutter/services.dart';

/// Lightweight wrapper around the platform MethodChannel for system-level
/// synchronous-ish data. Each method is documented and returns null when the
/// platform does not provide a value.
class SystemDataChannel {
  // Channel name must match the native implementation in MainActivity.kt
  static const MethodChannel _channel = MethodChannel('com.galaxysentinel.data');

  /// Returns CPU temperature in Celsius, or null if unavailable.
  ///
  /// Native side may read sensor files and return either an int/double/string.
  static Future<double?> fetchCpuTemperature() async {
    try {
      final dynamic res = await _channel.invokeMethod('getCpuTemp');
      return _coerceToDouble(res);
    } on PlatformException {
      return null;
    }
  }

  /// Returns memory info as a map: { 'totalBytes': int, 'availableBytes': int }
  /// Values are platform integers or null if unavailable.
  static Future<Map<String, dynamic>?> fetchMemoryInfo() async {
    try {
      final dynamic res = await _channel.invokeMethod('getMemoryInfo');
      if (res is Map) return Map<String, dynamic>.from(res.cast<String, dynamic>());
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Returns disk info as a map: { 'totalBytes': int, 'availableBytes': int }
  static Future<Map<String, dynamic>?> fetchDiskInfo() async {
    try {
      final dynamic res = await _channel.invokeMethod('getDiskInfo');
      if (res is Map) return Map<String, dynamic>.from(res.cast<String, dynamic>());
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Returns a CPU usage fraction 0.0-1.0 or null if unavailable.
  static Future<double?> fetchCpuUsage() async {
    try {
      final dynamic res = await _channel.invokeMethod('getCpuUsage');
      return _coerceToDouble(res);
    } on PlatformException {
      return null;
    }
  }

  static double? _coerceToDouble(dynamic res) {
    if (res == null) return null;
    if (res is double) return res;
    if (res is int) return res.toDouble();
    if (res is String) return double.tryParse(res);
    return null;
  }
}