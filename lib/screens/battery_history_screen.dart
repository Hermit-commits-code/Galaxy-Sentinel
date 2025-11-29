import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:galaxy_sentinel/models/battery_reading.dart';
import 'package:galaxy_sentinel/services/storage_service.dart';

class BatteryHistoryScreen extends StatefulWidget {
  const BatteryHistoryScreen({super.key});

  @override
  State<BatteryHistoryScreen> createState() => _BatteryHistoryScreenState();
}

class _BatteryHistoryScreenState extends State<BatteryHistoryScreen> {
  final StorageService _storage = const StorageService();
  List<BatteryReading> _readings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final r = await _storage.loadHistory();
    if (!mounted) return;
    setState(() {
      _readings = r;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _readings.isEmpty
          ? const Center(child: Text('No history yet'))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _readings.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          e.value.level.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: FlDotData(show: false),
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
