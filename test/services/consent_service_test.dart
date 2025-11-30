import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_sentinel/services/consent_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('consent toggles persist', () async {
    SharedPreferences.setMockInitialValues({});
    final service = await ConsentService.create();
    expect(service.isTelemetryEnabled(), isFalse);
    await service.setTelemetryEnabled(true);
    expect(service.isTelemetryEnabled(), isTrue);
    await service.setTelemetryEnabled(false);
    expect(service.isTelemetryEnabled(), isFalse);
  });
}
