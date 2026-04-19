class Session {
  final String id;
  final String? name;
  final int playerCount;
  final DateTime? createdAt;
  final int? status;

  Session({
    required this.id,
    required this.name,
    required this.playerCount,
    required this.createdAt,
    required this.status,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      playerCount: (json['playerCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      status: (json['status'] as num?)?.toInt(),
    );
  }
}
