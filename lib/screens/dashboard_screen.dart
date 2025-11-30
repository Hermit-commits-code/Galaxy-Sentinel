import 'package:flutter/material.dart';
import 'dart:async';
import '../services/app_services.dart';
import '../models/system_snapshot.dart';

/// DashboardScreen subscribes to the DataStreamManager stream and shows the
/// latest snapshot. It's a compact view useful for QA and local testing.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  StreamSubscription<SystemSnapshot>? _sub;
  SystemSnapshot? _latest;

  @override
  void initState() {
    super.initState();
    final manager = AppServices.dataStreamManager;
    if (manager != null) {
      _sub = manager.stream.listen((s) {
        setState(() => _latest = s);
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label), Text(value)],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final s = _latest;
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: s == null
            ? const Center(child: Text('No samples yet'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _row('Timestamp', s.timestamp.toIso8601String()),
                  _row(
                    'CPU Temp (°C)',
                    s.cpuTempC?.toStringAsFixed(2) ?? 'n/a',
                  ),
                  _row(
                    'CPU Usage',
                    s.cpuUsage != null
                        ? (s.cpuUsage! * 100).toStringAsFixed(1) + '%'
                        : 'n/a',
                  ),
                  _row('RAM free', s.ramFreeBytes?.toString() ?? 'n/a'),
                  _row('Disk free', s.diskFreeBytes?.toString() ?? 'n/a'),
                ],
              ),
      ),
    );
  }
}
