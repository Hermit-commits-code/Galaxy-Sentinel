import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_sentinel/services/data_stream_manager.dart';
import 'package:galaxy_sentinel/models/system_snapshot.dart';

void main() {
  const channelName = 'com.galaxysentinel.data';
  final MethodChannel channel = const MethodChannel(channelName);

  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = binding.defaultBinaryMessenger;

  setUp(() {
    // Ensure native method returns null (safe for CI) for getCpuTemp
    messenger.setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'getCpuTemp') return null;
      return null;
    });
  });

  tearDown(() async {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('DataStreamManager emits snapshot on start', () async {
    final manager = DataStreamManager(interval: const Duration(milliseconds: 50));
    manager.start();
    final snapshot = await manager.stream.first.timeout(const Duration(seconds: 2));
    expect(snapshot, isA<SystemSnapshot>());
    await manager.dispose();
  });
}