import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_sentinel/screens/device_info_screen.dart';

void main() {
  testWidgets('DeviceInfoScreen builds and shows loader', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DeviceInfoScreen()));

    // Expect a progress indicator while info loads
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow a short amount of async work to run but avoid indefinite wait in CI
    await tester.pump(const Duration(milliseconds: 250));

    // basic scaffold presence check
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
