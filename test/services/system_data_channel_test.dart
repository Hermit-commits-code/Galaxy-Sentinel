import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_sentinel/services/system_data_channel.dart';

void main() {
  const channelName = 'com.galaxysentinel.data';
  final MethodChannel channel = const MethodChannel(channelName);

  // initialize binding and get messenger
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = binding.defaultBinaryMessenger;

  tearDown(() async {
    // remove any mock handlers between tests (new API)
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('fetchCpuTemperature returns mocked double', () async {
    messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'getCpuTemp') return 42.5;
      return null;
    });

    final temp = await SystemDataChannel.fetchCpuTemperature();
    expect(temp, 42.5);
  });

  test('fetchCpuTemperature returns null when handler returns null', () async {
    messenger.setMockMethodCallHandler(channel, (MethodCall call) async => null);
    final temp = await SystemDataChannel.fetchCpuTemperature();
    expect(temp, isNull);
  });

  test('fetchCpuTemperature handles integer values', () async {
    messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'getCpuTemp') return 37000; // example int
      return null;
    });

    final temp = await SystemDataChannel.fetchCpuTemperature();
    expect(temp, isNotNull);
  });
}