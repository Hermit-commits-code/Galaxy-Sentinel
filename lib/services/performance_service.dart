import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'system_data_channel.dart';

/// PerformanceService bridges Dart code to platform-specific system metrics.
///
/// This class keeps the API surface small: callers ask for individual metrics
/// (RAM, disk, CPU) and receive null when the platform cannot supply a value.
/// The implementations delegate to `SystemDataChannel`, which uses a
/// MethodChannel to call native code.
class PerformanceService {
  const PerformanceService();

  /// Returns free RAM bytes if available, otherwise null.
  ///
  /// Implementation note: on Android this uses `ActivityManager.MemoryInfo` on
  /// the native side; other platforms may return null.
  Future<int?> getFreeRamBytes() async {
    final info = await SystemDataChannel.fetchMemoryInfo();
    if (info == null) return null;
    final avail = info['availableBytes'];
    if (avail is int) return avail;
    if (avail is double) return avail.toInt();
    return null;
  }

  /// Returns free disk bytes if available, otherwise null.
  Future<int?> getFreeDiskBytes() async {
    final info = await SystemDataChannel.fetchDiskInfo();
    if (info == null) return null;
    final avail = info['availableBytes'];
    if (avail is int) return avail;
    if (avail is double) return avail.toInt();
    return null;
  }

  /// Returns CPU usage as a 0.0-1.0 value if available, otherwise null.
  Future<double?> getCpuUsage() async {
    return await SystemDataChannel.fetchCpuUsage();
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