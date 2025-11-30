import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_sentinel/services/system_data_channel.dart';

void main() {
  const channelName = 'com.galaxysentinel.data';
  final MethodChannel channel = const MethodChannel(channelName);

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = binding.defaultBinaryMessenger;

  tearDown(() async {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('fetchNativeHistory decodes JSON array', () async {
    final snapshot1 = {'cpuTempC': 35.5, 'timestamp': 1600000000001};
    final snapshot2 = {'cpuTempC': 36.0, 'timestamp': 1600000001000};
    final arr = [snapshot1, snapshot2];

    messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'getTelemetryHistory') return json.encode(arr);
      return null;
    });

    final list = await SystemDataChannel.fetchNativeHistory();
    expect(list, isNotNull);
    expect(list!.length, 2);
    expect(list[0]['cpuTempC'], 35.5);
  });

  test('fetchNativeHistory returns null when no history', () async {
    messenger.setMockMethodCallHandler(
      channel,
      (MethodCall call) async => null,
    );
    final list = await SystemDataChannel.fetchNativeHistory();
    expect(list, isNull);
  });
}
