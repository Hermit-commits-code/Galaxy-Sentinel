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

  test(
    'fetchLatestNativeSnapshot returns decoded map when JSON string provided',
    () async {
      final snapshot = {
        'cpuTempC': 35.5,
        'ramFreeBytes': 123456789,
        'diskFreeBytes': 987654321,
        'cpuUsage': 0.12,
        'timestamp': 1600000000000,
      };

      messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
        if (call.method == 'getLatestSnapshot') return json.encode(snapshot);
        return null;
      });

      final map = await SystemDataChannel.fetchLatestNativeSnapshot();
      expect(map, isNotNull);
      expect(map!['cpuTempC'], 35.5);
      expect(map['ramFreeBytes'], 123456789);
    },
  );

  test(
    'fetchLatestNativeSnapshot returns null when handler returns null',
    () async {
      messenger.setMockMethodCallHandler(
        channel,
        (MethodCall call) async => null,
      );
      final map = await SystemDataChannel.fetchLatestNativeSnapshot();
      expect(map, isNull);
    },
  );
}
