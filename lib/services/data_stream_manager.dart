import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/system_snapshot.dart';
import 'performance_service.dart';
import 'system_data_channel.dart';

class DataStreamManager {
  final PerformanceService _perf;
  final Duration _interval;
  Timer? _timer;
  final StreamController<SystemSnapshot> _controller;

  DataStreamManager({
    PerformanceService? performanceService,
    Duration interval = const Duration(seconds: 3),
  })  : _perf = performanceService ?? const PerformanceService(),
        _interval = interval,
        _controller = StreamController<SystemSnapshot>.broadcast();

  Stream<SystemSnapshot> get stream => _controller.stream;

  /// Start periodic sampling.
  void start() {
    if (_timer != null) return;
    _emitSample(); // initial immediate sample
    _timer = Timer.periodic(_interval, (_) => _emitSample());
  }

  /// Stop sampling.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> dispose() async {
    stop();
    await _controller.close();
  }

  Future<void> _emitSample() async {
    try {
      final perfSample = await _perf.sample();
      final cpuTemp = await SystemDataChannel.fetchCpuTemperature();
      int? batteryLevel; // integrate BatteryService when available

      final snapshot = SystemSnapshot(
        timestamp: DateTime.now().toUtc(),
        cpuTempC: cpuTemp,
        batteryLevel: batteryLevel,
        ramFreeBytes: perfSample['ramFreeBytes'] as int?,
        cpuUsage: perfSample['cpuUsage'] as double?,
        diskFreeBytes: perfSample['diskFreeBytes'] as int?,
      );

      if (!_controller.isClosed) _controller.add(snapshot);
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('DataStreamManager sampling error: $e\n$st');
      }
    }
  }
}