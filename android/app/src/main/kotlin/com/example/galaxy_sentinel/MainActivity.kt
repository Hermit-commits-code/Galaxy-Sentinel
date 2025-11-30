package com.example.galaxy_sentinel

import io.flutter.embedding.android.FlutterActivity

// Minimal MainActivity for non-Samsung (generic) builds. Keeping this file
// small ensures that the Samsung-only native metric implementation is not
// included in generic APKs when using product flavors.
class MainActivity: FlutterActivity()
package com.example.galaxy_sentinel

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.galaxysentinel.data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getCpuTemp" -> {
                    try {
                        val temp = ThermalReader.getCpuTemperatureCelsius()
                        if (temp != null) {
                            result.success(temp) // send double Celsius
                        } else {
                            result.success(null)
                        }
                    } catch (e: Exception) {
                        result.error("ERR_TEMP", "Failed to read CPU temperature: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
