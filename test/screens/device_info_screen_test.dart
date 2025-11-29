import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_sentinel/screens/device_info_screen.dart';

void main() {
  testWidgets('DeviceInfoScreen builds and shows loader', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DeviceInfoScreen()));

    // Expect an initial loader immediately
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow a short time for async work; avoid indefinite pumpAndSettle
    await tester.pump(const Duration(milliseconds: 250));

    // Basic scaffold presence check
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
