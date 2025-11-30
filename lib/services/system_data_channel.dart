import 'package:flutter/services.dart';
import 'dart:convert';

/// Lightweight wrapper around the platform MethodChannel for system-level
/// synchronous-ish data. Each method is documented and returns null when the
/// platform does not provide a value.
class SystemDataChannel {
  // Channel name must match the native implementation in MainActivity.kt
  static const MethodChannel _channel = MethodChannel(
    'com.galaxysentinel.data',
  );

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
      if (res is Map) {
        return Map<String, dynamic>.from(res.cast<String, dynamic>());
      }
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Returns disk info as a map: { 'totalBytes': int, 'availableBytes': int }
  static Future<Map<String, dynamic>?> fetchDiskInfo() async {
    try {
      final dynamic res = await _channel.invokeMethod('getDiskInfo');
      if (res is Map) {
        return Map<String, dynamic>.from(res.cast<String, dynamic>());
      }
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

  /// Ask native code for the latest persisted telemetry snapshot (written by
  /// native `TelemetryWorker` into SharedPreferences). Returns a decoded
  /// `Map<String, dynamic>` if available, or `null` when no snapshot exists.
  static Future<Map<String, dynamic>?> fetchLatestNativeSnapshot() async {
    try {
      final dynamic res = await _channel.invokeMethod('getLatestSnapshot');
      if (res == null) return null;
      if (res is String) {
        try {
          final decoded = json.decode(res);
          if (decoded is Map) {
            return Map<String, dynamic>.from(decoded.cast<String, dynamic>());
          }
        } catch (_) {
          return null;
        }
      }
      if (res is Map) {
        return Map<String, dynamic>.from(res.cast<String, dynamic>());
      }
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Fetch the persisted native telemetry history (JSON array of snapshot objects).
  /// Returns `null` when no history exists, otherwise a List of maps (newest first).
  static Future<List<Map<String, dynamic>>?> fetchNativeHistory() async {
    try {
      final dynamic res = await _channel.invokeMethod('getTelemetryHistory');
      if (res == null) return null;
      String jsonStr;
      if (res is String) {
        jsonStr = res;
      } else {
        // If platform returned a Map/other, try to convert
        jsonStr = json.encode(res);
      }
      final decoded = json.decode(jsonStr);
      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((e) {
          if (e is Map) {
            return Map<String, dynamic>.from(e.cast<String, dynamic>());
          }
          return <String, dynamic>{};
        }).toList();
      }
      return null;
    } on PlatformException {
      return null;
    }
  }

  /// Instruct native side to schedule periodic telemetry sampling.
  static Future<bool> scheduleTelemetry() async {
    try {
      final dynamic res = await _channel.invokeMethod('scheduleTelemetry');
      return res == true;
    } on PlatformException {
      return false;
    }
  }

  /// Instruct native side to cancel periodic telemetry sampling.
  static Future<bool> cancelTelemetry() async {
    try {
      final dynamic res = await _channel.invokeMethod('cancelTelemetry');
      return res == true;
    } on PlatformException {
      return false;
    }
  }

  static double? _coerceToDouble(dynamic res) {
    if (res == null) {
      return null;
    }
    if (res is double) {
      return res;
    }
    if (res is int) {
      return res.toDouble();
    }
    if (res is String) {
      return double.tryParse(res);
    }
    return null;
  }
}
