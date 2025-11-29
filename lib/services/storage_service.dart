import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_sentinel/models/battery_reading.dart';

class StorageService {
  static const _keyHistory = 'battery_history';
  const StorageService();

  Future<void> saveBatteryReading(int level, DateTime at) async {
    final prefs = await SharedPreferences.getInstance();
    // simple example — expand to JSON list for real history
    await prefs.setInt('last_battery_level', level);
    await prefs.setString('last_battery_at', at.toIso8601String());
  }

  Future<Map<String, String>?> lastReading() async {
    final prefs = await SharedPreferences.getInstance();
    final level = prefs.getInt('last_battery_level');
    final at = prefs.getString('last_battery_at');
    if (level == null || at == null) return null;
    return {'level': '$level', 'at': at};
  }

  Future<void> saveHistory(List<BatteryReading> readings) async {
    final prefs = await SharedPreferences.getInstance();
    final enc = jsonEncode(readings.map((r) => r.toJson()).toList());
    await prefs.setString(_keyHistory, enc);
  }

  Future<List<BatteryReading>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_keyHistory);
    if (s == null || s.isEmpty) return <BatteryReading>[];
    final List<dynamic> list = jsonDecode(s);
    return list
        .map((e) => BatteryReading.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> appendReading(BatteryReading r, {int maxEntries = 1000}) async {
    final list = await loadHistory();
    list.add(r);
    if (list.length > maxEntries) {
      final keep = list.sublist(list.length - maxEntries);
      await saveHistory(keep);
    } else {
      await saveHistory(list);
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHistory);
  }
}
