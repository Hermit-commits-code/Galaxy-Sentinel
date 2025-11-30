import 'package:flutter/material.dart';
import '../services/consent_service.dart';

/// SettingsScreen provides a minimal UI for telemetry consent and privacy
/// disclosure. It's intentionally small and documented so you can expand it.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ConsentService? _consentService;
  bool _enabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final s = await ConsentService.create();
    setState(() {
      _consentService = s;
      _enabled = s.isTelemetryEnabled();
      _loading = false;
    });
  }

  Future<void> _toggle(bool value) async {
    setState(() => _loading = true);
    await _consentService?.setTelemetryEnabled(value);
    setState(() {
      _enabled = value;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  title: const Text('Allow system telemetry'),
                  subtitle: const Text(
                    'Opt-in to periodic system metrics sampling (CPU/temp/memory). Data stays on this device unless you enable uploads).',
                  ),
                  value: _enabled,
                  onChanged: (v) async {
                    if (v) {
                      // Show short confirmation dialog before enabling
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Enable telemetry'),
                          content: const Text(
                            'Allow Galaxy Sentinel to sample system metrics periodically. This helps diagnostics but may include device metrics such as CPU temperature and memory. No data will be uploaded without further consent.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: const Text('Enable'),
                            ),
                          ],
                        ),
                      );
                      if (ok != true) return;
                    }
                    await _toggle(v);
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Privacy & details',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Telemetry consists of periodic, local-only samples of CPU temperature, CPU usage, free RAM and disk. Data remains on-device unless you explicitly choose to share it. For details, see the full privacy policy.',
                ),
                TextButton(
                  onPressed: () {
                    // Link to privacy policy — for now, show a simple dialog.
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Privacy policy (summary)'),
                        content: const SingleChildScrollView(
                          child: Text(
                            'Galaxy Sentinel collects only local system metrics for diagnostic purposes. No network uploads occur without explicit consent. Please contact the developer for more info.',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('View privacy summary'),
                ),
              ],
            ),
    );
  }
}
