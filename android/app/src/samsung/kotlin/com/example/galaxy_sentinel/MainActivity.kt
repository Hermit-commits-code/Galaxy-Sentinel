package com.example.galaxy_sentinel

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Environment
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit
import java.io.RandomAccessFile

/**
 * Samsung flavor MainActivity: contains vendor-specific native metric
 * implementations. This file is only compiled into the `samsung` flavor
 * variant, so it won't be included in generic builds.
 */
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.galaxysentinel.data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
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

        // Schedule periodic WorkManager job for telemetry sampling.
        private fun scheduleTelemetry() {
            val workRequest = PeriodicWorkRequestBuilder<TelemetryWorker>(15, TimeUnit.MINUTES).build()
            WorkManager.getInstance(applicationContext)
                .enqueueUniquePeriodicWork("telemetry_worker", ExistingPeriodicWorkPolicy.REPLACE, workRequest)
        }

        private fun cancelTelemetry() {
            WorkManager.getInstance(applicationContext).cancelUniqueWork("telemetry_worker")
        }

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
                    return if (v > 1000) v / 1000.0 else v
                }
            } catch (e: Exception) {
                // ignore
            }
        }
        return null
    }

    private fun getMemoryInfo(): Map<String, Long> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        val total = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) memInfo.totalMem else -1L
        val avail = memInfo.availMem
        return mapOf("totalBytes" to total, "availableBytes" to avail)
    }

    private fun getDiskInfo(): Map<String, Long> {
        val path = Environment.getDataDirectory()
        val stat = StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val total = stat.blockCountLong * blockSize
        val avail = stat.availableBlocksLong * blockSize
        return mapOf("totalBytes" to total, "availableBytes" to avail)
    }

    private fun getCpuUsagePercent(): Double? {
        try {
            fun readCpu(): LongArray? {
                val reader = RandomAccessFile("/proc/stat", "r")
                val line = reader.readLine()
                reader.close()
                if (line == null || !line.startsWith("cpu ")) return null
                val parts = line.split(Regex("\\s+"))
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
