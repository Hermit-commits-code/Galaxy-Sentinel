package com.example.galaxy_sentinel
import java.io.File

object ThermalReader {
    private val thermalPaths = listOf(
        "/sys/class/thermal/thermal_zone0/temp",
        "/sys/class/thermal/thermal_zone1/temp",
        "/sys/class/thermal/thermal_zone2/temp",
        "/sys/class/thermal/thermal_zone3/temp",
        "/sys/devices/virtual/thermal/thermal_zone0/temp",
        "/sys/devices/virtual/thermal/thermal_zone1/temp"
    )

    /**
     * Attempts to read CPU temperature in Celsius.
     * Returns the temperature as Double (Celsius) or null if unavailable.
     */
    fun getCpuTemperatureCelsius(): Double? {
        for (path in thermalPaths) {
            try {
                val f = File(path)
                if (!f.exists() || !f.canRead()) continue
                val raw = f.readText().trim()
                if (raw.isEmpty()) continue
                val value = raw.toDoubleOrNull() ?: continue
                // Some devices report millidegrees (e.g. 42000) — normalize:
                return if (value > 1000.0) value / 1000.0 else value
            } catch (e: Exception) {
                // ignore and try next path
            }
        }
        return null
    }
}