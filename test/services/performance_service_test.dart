import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_sentinel/services/performance_service.dart';

void main() {
  test('PerformanceService.sample returns a map', () async {
    final svc = const PerformanceService();
    final m = await svc.sample();
    expect(m, isA<Map<String, Object?>>());
    expect(m.containsKey('ramFreeBytes'), isTrue);
    expect(m.containsKey('diskFreeBytes'), isTrue);
    expect(m.containsKey('cpuUsage'), isTrue);
  });
}
