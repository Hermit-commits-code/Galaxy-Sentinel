package com.example.galaxy_sentinel

import android.content.Context
import android.content.SharedPreferences
import androidx.work.Worker
import androidx.work.WorkerParameters
import android.app.ActivityManager
import android.os.Environment
import android.os.StatFs
import java.io.RandomAccessFile
import org.json.JSONObject
import org.json.JSONArray

/**
 * TelemetryWorker runs on the native side and performs the same sampling we
 * expose to Dart. It writes a simple JSON snapshot to SharedPreferences under
 * key `telemetry.latest` so the app can read persisted samples.
 */
class TelemetryWorker(context: Context, params: WorkerParameters) : Worker(context, params) {
    override fun doWork(): Result {
        try {
            val prefs = applicationContext.getSharedPreferences("galaxysentinel", Context.MODE_PRIVATE)
            val snapshot = sampleSnapshot()
            if (snapshot != null) {
                prefs.edit().putString("telemetry.latest", snapshot.toString()).apply()

                // Append to a rolling history stored as a JSON array in SharedPreferences.
                // Keep a bounded history to avoid unbounded storage growth.
                try {
                    val historyKey = "telemetry.history"
                    val existing = prefs.getString(historyKey, null)
                    val newHistory = JSONArray()
                    // add newest first
                    newHistory.put(snapshot)
                    if (existing != null) {
                        val old = JSONArray(existing)
                        var idx = 0
                        val maxEntries = 288 // ~one entry per 5 min for one day
                        while (idx < old.length() && newHistory.length() < maxEntries) {
                            newHistory.put(old.get(idx))
                            idx += 1
                        }
                    }
                    prefs.edit().putString(historyKey, newHistory.toString()).apply()
                } catch (e: Exception) {
                    // ignore history failures
                }
            }
            return Result.success()
        } catch (e: Exception) {
            return Result.failure()
        }
    }

    private fun sampleSnapshot(): JSONObject? {
        val cpuTemp = getCpuTempCelsius()
        val mem = getMemoryInfo()
        val disk = getDiskInfo()
        val cpuUsage = getCpuUsagePercent()
        val obj = JSONObject()
        try {
            obj.put("cpuTempC", if (cpuTemp != null) cpuTemp else JSONObject.NULL)
            obj.put("ramFreeBytes", mem?.get("availableBytes") ?: JSONObject.NULL)
            obj.put("diskFreeBytes", disk?.get("availableBytes") ?: JSONObject.NULL)
            obj.put("cpuUsage", if (cpuUsage != null) cpuUsage else JSONObject.NULL)
            obj.put("timestamp", System.currentTimeMillis())
            return obj
        } catch (e: Exception) {
            return null
        }
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
            } catch (_: Exception) { }
        }
        return null
    }

    private fun getMemoryInfo(): Map<String, Long>? {
        val activityManager = applicationContext.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        val total = memInfo.totalMem
        val avail = memInfo.availMem
        return mapOf("totalBytes" to total, "availableBytes" to avail)
    }

    private fun getDiskInfo(): Map<String, Long>? {
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
