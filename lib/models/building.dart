class Building {
  final String id;
  final int type;
  final int level;
  final int workers;
  final int tileX;
  final int tileY;
  final int maxWorkers;

  Building({
    required this.id,
    required this.type,
    required this.level,
    required this.workers,
    required this.tileX,
    required this.tileY,
    required this.maxWorkers,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id']?.toString() ?? '',
      type: (json['type'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      workers: (json['workers'] as num?)?.toInt() ?? 0,
      maxWorkers: (json['maxWorkers'] as num?)?.toInt() ?? 0,
      tileX: (json['tileX'] as num?)?.toInt() ?? 0,
      tileY: (json['tileY'] as num?)?.toInt() ?? 0,
    );
  }
}
