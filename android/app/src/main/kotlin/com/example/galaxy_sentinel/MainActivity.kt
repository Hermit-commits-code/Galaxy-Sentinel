package com.example.galaxy_sentinel

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile

/**
 * MainActivity sets up a MethodChannel to provide system-level metrics to Dart.
 *
 * Contains simple implementations for:
 * - getCpuTemp: Attempts to read thermal sensor files (best-effort).
 * - getMemoryInfo: Returns total and available memory in bytes.
 * - getDiskInfo: Returns total and available bytes on the data partition.
 * - getCpuUsage: Performs a short two-sample read of /proc/stat to estimate CPU usage.
 *
 * The implementations are intentionally straightforward so they're easy to read
 * and learn from; they are best-effort and may return null if not available.
 */
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.galaxysentinel.data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // Only expose these device-specific metrics on Samsung devices.
            // The app will be distributed on Samsung Galaxy Store and should
            // avoid exposing vendor-specific sensors on non-Samsung hardware.
            val manufacturer = (android.os.Build.MANUFACTURER ?: "").lowercase()
            val isSamsung = manufacturer.contains("samsung")

            if (!isSamsung) {
                // For non-Samsung devices return null for all supported methods.
                when (call.method) {
                    "getCpuTemp", "getMemoryInfo", "getDiskInfo", "getCpuUsage" -> {
                        result.success(null)
                        return@setMethodCallHandler
                    }
                }
            }

            when (call.method) {
                "getCpuTemp" -> {
                    val t = getCpuTempCelsius()
                    if (t != null) result.success(t) else result.success(null)
                }
                "getMemoryInfo" -> {
                    val mem = getMemoryInfo()
                    result.success(mem)
                }
                "getDiskInfo" -> {
                    val disk = getDiskInfo()
                    result.success(disk)
                }
                "getCpuUsage" -> {
                    val usage = getCpuUsagePercent()
                    result.success(usage)
                }
                else -> result.notImplemented()
            }
        }
    }

    // Try to read a common thermal file exposing millidegrees.
    private fun getCpuTempCelsius(): Double? {
        val candidates = listOf(
            "/sys/class/thermal/thermal_zone0/temp",
            "/sys/class/thermal/thermal_zone1/temp",
            "/sys/class/thermal/thermal_zone2/temp"
        )
        for (path in candidates) {
            try {
                val s = RandomAccessFile(path, "r").use { it.readLine() }
                if (s != null) {
                    val v = s.trim().toDoubleOrNull() ?: continue
                    // many sensors report millidegrees
                    return if (v > 1000) v / 1000.0 else v
                }
            } catch (e: Exception) {
                // ignore and try next
            }
        }
        return null
    }

    // Use ActivityManager.MemoryInfo for reliable memory stats.
    private fun getMemoryInfo(): Map<String, Long> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        val total = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) memInfo.totalMem else -1L
        val avail = memInfo.availMem
        return mapOf("totalBytes" to total, "availableBytes" to avail)
    }

    // Use StatFs to get disk space for the data directory.
    private fun getDiskInfo(): Map<String, Long> {
        val path = Environment.getDataDirectory()
        val stat = StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val total = stat.blockCountLong * blockSize
        val avail = stat.availableBlocksLong * blockSize
        return mapOf("totalBytes" to total, "availableBytes" to avail)
    }

    // Simple CPU usage estimator: read /proc/stat twice with a short sleep.
    // Returns fraction 0.0-1.0 or null on failure.
    private fun getCpuUsagePercent(): Double? {
        try {
            fun readCpu(): LongArray? {
                val reader = RandomAccessFile("/proc/stat", "r")
                val line = reader.readLine()
                reader.close()
                if (line == null || !line.startsWith("cpu ")) return null
                val parts = line.split(Regex("\\s+"))
                // parts[1..] are user, nice, system, idle, iowait, irq, softirq, steal
                val nums = parts.drop(1).mapNotNull { it.toLongOrNull() }
                val idle = if (nums.size > 3) nums[3] else 0L
                val total = nums.sum()
                return longArrayOf(idle, total)
            }

            val a = readCpu() ?: return null
            Thread.sleep(120)
            val b = readCpu() ?: return null
            val idleDiff = b[0] - a[0]
            val totalDiff = b[1] - a[1]
            if (totalDiff <= 0) return null
            val usage = (totalDiff - idleDiff).toDouble() / totalDiff.toDouble()
            return usage.coerceIn(0.0, 1.0)
        } catch (e: Exception) {
            return null
        }
    }
}
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
