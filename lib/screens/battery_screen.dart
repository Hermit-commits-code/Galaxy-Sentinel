import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final Battery _battery = Battery();
  int? _level;
  BatteryState? _state;

  @override
  void initState() {
    super.initState();
    _loadBattery();
    _battery.onBatteryStateChanged.listen((s) {
      setState(() => _state = s);
      _loadBattery();
    });
  }

  Future<void> _loadBattery() async {
    try {
      final level = await _battery.batteryLevel;
      setState(() => _level = level);
    } catch (_) {
      setState(() => _level = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _level == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battery level: $_level%',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('State: ${_state?.name ?? 'unknown'}'),
                  const SizedBox(height: 16),
                  // Placeholder for chart / history
                  Card(
                    child: SizedBox(
                      height: 160,
                      child: Center(child: Text('Battery usage chart (WIP)')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBattery,
                    child: const Text('Refresh'),
                  ),
                ],
              ),
      ),
    );
  }
}
