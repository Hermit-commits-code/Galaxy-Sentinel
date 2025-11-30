import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_sentinel/services/performance_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.galaxysentinel.data');

  tearDown(() async {
    // Clear any mock handler between tests
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('fetchMemoryInfo and fetchDiskInfo and cpu usage', () async {
    // Provide a mock platform implementation for the three methods we use.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getMemoryInfo':
          return {'totalBytes': 8000000, 'availableBytes': 3000000};
        case 'getDiskInfo':
          return {'totalBytes': 16000000000, 'availableBytes': 4000000000};
        case 'getCpuUsage':
          return 0.12; // 12%
        default:
          return null;
      }
    });

    final svc = PerformanceService();
    final ram = await svc.getFreeRamBytes();
    final disk = await svc.getFreeDiskBytes();
    final cpu = await svc.getCpuUsage();

    expect(ram, equals(3000000));
    expect(disk, equals(4000000000));
    expect(cpu, closeTo(0.12, 1e-9));
  });
}
