import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galaxy Sentinel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/device-info'),
              child: const Text('Device Info'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/battery'),
              child: const Text('Battery'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Replace the demo home with real screens. Add more navigation or a bottom bar as needed.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
