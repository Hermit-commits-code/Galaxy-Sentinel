import 'package:flutter/material.dart';

class BatteryHistoryScreen extends StatelessWidget {
  const BatteryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery History')),
      body: const Center(child: Text('Battery history & chart will be implemented here.')),
    );
  }
}