import 'dart:core';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_sentinel/services/storage_service.dart';
import 'package:galaxy_sentinel/models/battery_reading.dart';

void main() {
  test('StorageService save/load/append/clear history', () async {
    // start with empty mock prefs
    SharedPreferences.setMockInitialValues(<String, Object>{});

    final svc = const StorageService();
    final now = DateTime.now();
    final r1 = BatteryReading(timestamp: now, level: 50);
    await svc.appendReading(r1);
    var list = await svc.loadHistory();
    expect(list.length, 1);
    expect(list.first.level, 50);

    final r2 = BatteryReading(
      timestamp: now.add(const Duration(minutes: 1)),
      level: 48,
    );
    await svc.appendReading(r2);
    list = await svc.loadHistory();
    expect(list.length, 2);
    expect(list[1].level, 48);

    await svc.clearHistory();
    list = await svc.loadHistory();
    expect(list, isEmpty);
  });
}
