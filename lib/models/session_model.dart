class SessionModel {
  final String id;
  final String name;
  final int playerCount;
  final String status;

  SessionModel({
    required this.id,
    required this.name,
    required this.playerCount,
    required this.status,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json["id"],
      name: json["name"] ?? "",
      playerCount: json["playerCount"] ?? 0,
      status: json["status"] ?? "",
    );
  }
}
