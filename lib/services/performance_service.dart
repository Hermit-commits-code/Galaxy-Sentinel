import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';

class PerformanceService {
  const PerformanceService();

  /// Returns free RAM bytes if available, otherwise null.
  Future<int?> getFreeRamBytes() async {
    // Placeholder for platform-specific implementation.
    return null;
  }

  /// Returns free disk bytes if available, otherwise null.
  Future<int?> getFreeDiskBytes() async {
    // Placeholder for platform-specific implementation.
    return null;
  }

  /// Returns CPU usage as a 0.0-1.0 value if available, otherwise null.
  Future<double?> getCpuUsage() async {
    // Placeholder for platform-specific implementation.
    return null;
  }

  /// Basic device info for diagnostics.
  Future<Map<String, Object?>> deviceInfo() async {
    final info = <String, Object?>{};
    try {
      final di = DeviceInfoPlugin();
      final android = await di.androidInfo;
      info['model'] = android.model;
      info['sdkInt'] = android.version.sdkInt;
    } catch (_) {
      // ignore in test/CI environment
    }
    return info;
  }

  /// Sample map used by DataStreamManager
  Future<Map<String, Object?>> sample() async {
    final ram = await getFreeRamBytes();
    final disk = await getFreeDiskBytes();
    final cpu = await getCpuUsage();
    final info = await deviceInfo();
    return {
      'ramFreeBytes': ram,
      'diskFreeBytes': disk,
      'cpuUsage': cpu,
      'deviceInfo': info,
    };
  }
}