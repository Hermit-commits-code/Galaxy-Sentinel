import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
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
}
