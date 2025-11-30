import 'package:shared_preferences/shared_preferences.dart';

/// ConsentService stores and retrieves user consent for telemetry sampling.
///
/// It's intentionally small and testable: uses `SharedPreferences` under the
/// hood and exposes a simple boolean API.
class ConsentService {
  static const _kTelemetryKey = 'consent.telemetry.enabled';

  final SharedPreferences _prefs;

  ConsentService._(this._prefs);

  /// Create a ConsentService bound to the current SharedPreferences instance.
  static Future<ConsentService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ConsentService._(prefs);
  }

  /// Returns true when the user has explicitly enabled telemetry sampling.
  bool isTelemetryEnabled() {
    return _prefs.getBool(_kTelemetryKey) ?? false;
  }

  /// Update the stored telemetry consent flag.
  Future<void> setTelemetryEnabled(bool enabled) async {
    await _prefs.setBool(_kTelemetryKey, enabled);
  }
}
