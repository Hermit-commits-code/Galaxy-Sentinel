import 'package:flutter/material.dart';
import 'screens/battery_screen.dart';
import 'screens/device_info_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/app_services.dart';

Future<void> main() async {
  // Initialize services (consent, datastream manager) before running the app.
  await AppServices.init();
  runApp(const GalaxySentinelApp());
}

class GalaxySentinelApp extends StatelessWidget {
  const GalaxySentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaxy Sentinel',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
      routes: {
        '/battery': (ctx) => const BatteryScreen(),
        '/device': (ctx) => const DeviceInfoScreen(),
        '/settings': (ctx) => const SettingsScreen(),
        '/dashboard': (ctx) => const DashboardScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Galaxy Sentinel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () => Navigator.of(context).pushNamed('/dashboard'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times: $_counter'),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/dashboard'),
              child: const Text('Open Dashboard'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
