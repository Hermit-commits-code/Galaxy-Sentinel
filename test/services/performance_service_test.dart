import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:galaxy_sentinel/services/performance_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('PerformanceService.sample returns a map', () async {
    // Provide no-op method handler so native MethodChannel calls in the
    // implementation do not throw during tests. We return null for
    // platform-specific methods — the service should tolerate that.
    final channel = MethodChannel('com.galaxysentinel.data');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          switch (call.method) {
            case 'getMemoryInfo':
            case 'getDiskInfo':
            case 'getCpuUsage':
            case 'getCpuTemp':
              return null;
            default:
              return null;
          }
        });

    final svc = const PerformanceService();
    final m = await svc.sample();
    expect(m, isA<Map<String, Object?>>());
    expect(m.containsKey('ramFreeBytes'), isTrue);
    expect(m.containsKey('diskFreeBytes'), isTrue);
    expect(m.containsKey('cpuUsage'), isTrue);
  });
}
