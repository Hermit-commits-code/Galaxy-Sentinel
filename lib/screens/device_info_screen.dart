import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _info = {};

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final info = <String, dynamic>{};
      final android = await _deviceInfo.androidInfo;
      info['platform'] = 'android';
      info['model'] = android.model;
      info['version'] = android.version.release;
      setState(() => _info = info);
    } catch (_) {
      // fall back or handle other platforms in future
      setState(() => _info = {'error': 'Unable to read device info'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _info.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: _info.entries
                    .map(
                      (e) => ListTile(
                        title: Text(e.key),
                        subtitle: Text('${e.value}'),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
