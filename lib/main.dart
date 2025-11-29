import 'package:flutter/material.dart';
import 'screens/battery_screen.dart';
import 'screens/device_info_screen.dart';

void main() => runApp(const GalaxySentinelApp());

class GalaxySentinelApp extends StatelessWidget {
  const GalaxySentinelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaxy Sentinel',
      theme: ThemeData(useMaterial3: true),
      // Show the real HomeScreen so other screens are used via navigation
      home: const HomeScreen(),
      routes: {
        '/battery': (ctx) => const BatteryScreen(),
        '/device': (ctx) => const DeviceInfoScreen(),
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
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have pushed the button this many times: $_counter'),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
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
