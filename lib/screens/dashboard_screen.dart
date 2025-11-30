import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import '../services/app_services.dart';
import '../models/system_snapshot.dart';
import '../services/system_data_channel.dart';
import 'package:flutter/services.dart';

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

  Widget _buildCpuTempChart(List<Map<String, dynamic>> history) {
    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final e = history.elementAt(i);
      final cpu = e['cpuTempC'];
      final y = (cpu is num) ? cpu.toDouble() : double.nan;
      if (!y.isNaN) spots.add(FlSpot(i.toDouble(), y));
    }
    if (spots.isEmpty) return const Center(child: Text('No chart data'));

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        minY: minY - 2,
        maxY: maxY + 2,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            dotData: FlDotData(show: false),
            color: Colors.red,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
  Future<void> _exportHistory() async {
    final hist = await SystemDataChannel.fetchNativeHistory();
    if (hist == null || hist.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No telemetry history to export')),
      );
      return;
    }
    try {
      final jsonStr = json.encode(hist);
      await Clipboard.setData(ClipboardData(text: jsonStr));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Copied ${hist.length} entries to clipboard')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export: ${e.toString()}')),
      );
    }
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportHistory,
        label: const Text('Export history'),
        icon: const Icon(Icons.upload_file),
      ),
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
                        ? '${(s.cpuUsage! * 100).toStringAsFixed(1)}%'
                        : 'n/a',
                  ),
                  _row('RAM free', s.ramFreeBytes?.toString() ?? 'n/a'),
                  _row('Disk free', s.diskFreeBytes?.toString() ?? 'n/a'),
                  const SizedBox(height: 12),
                  ExpansionTile(
                    title: const Text(
                      'Native telemetry history (latest first)',
                    ),
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>?>(
                        future: SystemDataChannel.fetchNativeHistory(),
                        builder: (context, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          }
                          final list = snap.data;
                          if (list == null || list.isEmpty) {
                            return const ListTile(
                              title: Text('No history available'),
                            );
                          }
                          // show up to 50 entries
                          final show = list.take(50).toList();
                          return Column(
                            children: [
                              SizedBox(
                                height: 160,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildCpuTempChart(show),
                                ),
                              ),
                              ...show.map((e) {
                                final ts = e['timestamp'];
                                final cpu = e['cpuTempC'];
                                final when = ts is int
                                    ? DateTime.fromMillisecondsSinceEpoch(ts).toIso8601String()
                                    : ts?.toString() ?? 'n/a';
                                return ListTile(
                                  dense: true,
                                  title: Text('ts: $when'),
                                  subtitle: Text('cpuTempC: ${cpu?.toString() ?? 'n/a'}'),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
