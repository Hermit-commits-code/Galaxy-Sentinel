class BatteryReading {
  final DateTime timestamp;
  final int level; // 0-100

  const BatteryReading({required this.timestamp, required this.level});

  Map<String, dynamic> toJson() => {
    't': timestamp.toIso8601String(),
    'l': level,
  };

  factory BatteryReading.fromJson(Map<String, dynamic> json) => BatteryReading(
    timestamp: DateTime.parse(json['t'] as String),
    level: (json['l'] as num).toInt(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatteryReading &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp &&
          level == other.level;

  @override
  int get hashCode => timestamp.hashCode ^ level.hashCode;

  @override
  String toString() => 'BatteryReading(timestamp: $timestamp, level: $level)';
}
