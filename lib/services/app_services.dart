import 'package:flutter/widgets.dart';
import 'consent_service.dart';
import 'data_stream_manager.dart';

/// AppServices holds initialized singletons used across the app.
class AppServices {
  static ConsentService? consentService;
  static DataStreamManager? dataStreamManager;

  /// Initialize app-level services. Call this before `runApp`.
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    consentService = await ConsentService.create();
    dataStreamManager = DataStreamManager(consentService: consentService);
    // Start sampling only if consent was previously given.
    if (consentService!.isTelemetryEnabled()) {
      dataStreamManager!.start();
    }
  }
}
