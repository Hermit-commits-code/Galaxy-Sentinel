import 'dart:convert';

class SystemSnapshot {
  final DateTime timestamp;
  final double? cpuTempC; // Celsius
  final int? batteryLevel; // 0-100
  final int? ramFreeBytes;
  final double? cpuUsage; // 0.0 - 1.0
  final int? diskFreeBytes;

  const SystemSnapshot({
    required this.timestamp,
    this.cpuTempC,
    this.batteryLevel,
    this.ramFreeBytes,
    this.cpuUsage,
    this.diskFreeBytes,
  });

  SystemSnapshot copyWith({
    DateTime? timestamp,
    double? cpuTempC,
    int? batteryLevel,
    int? ramFreeBytes,
    double? cpuUsage,
    int? diskFreeBytes,
  }) {
    return SystemSnapshot(
      timestamp: timestamp ?? this.timestamp,
      cpuTempC: cpuTempC ?? this.cpuTempC,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      ramFreeBytes: ramFreeBytes ?? this.ramFreeBytes,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      diskFreeBytes: diskFreeBytes ?? this.diskFreeBytes,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'cpuTempC': cpuTempC,
        'batteryLevel': batteryLevel,
        'ramFreeBytes': ramFreeBytes,
        'cpuUsage': cpuUsage,
        'diskFreeBytes': diskFreeBytes,
      };

  factory SystemSnapshot.fromJson(Map<String, dynamic> json) {
    return SystemSnapshot(
      timestamp: DateTime.parse(json['timestamp'] as String),
      cpuTempC: (json['cpuTempC'] as num?)?.toDouble(),
      batteryLevel: json['batteryLevel'] as int?,
      ramFreeBytes: json['ramFreeBytes'] as int?,
      cpuUsage: (json['cpuUsage'] as num?)?.toDouble(),
      diskFreeBytes: json['diskFreeBytes'] as int?,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}