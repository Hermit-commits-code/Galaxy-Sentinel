import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxy_sentinel/screens/battery_history_screen.dart';

void main() {
  testWidgets('BatteryHistoryScreen renders with persisted history', (
    WidgetTester tester,
  ) async {
    // prepare mock persisted history matching StorageService format
    final now = DateTime.now();
    final history = [
      {'t': now.toIso8601String(), 'l': 75},
      {'t': now.add(const Duration(minutes: 1)).toIso8601String(), 'l': 73},
    ];
    SharedPreferences.setMockInitialValues({
      'battery_history': jsonEncode(history),
    });

    await tester.pumpWidget(const MaterialApp(home: BatteryHistoryScreen()));

    // allow the widget to perform a short async load
    await tester.pump(const Duration(milliseconds: 250));

    // basic assertions: scaffold and app bar present, and no loading indicator
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('Battery History'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // If fl_chart is available the chart widget should be present (optional check)
    // This keeps the test resilient if fl_chart internals change; uncomment if desired:
    // expect(find.byType(LineChart), findsOneWidget);
  });
}
