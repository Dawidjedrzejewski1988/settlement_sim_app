class AuthResponse {
  final String accessToken;
  final int? userId;
  final String? settlementId;

  AuthResponse({
    required this.accessToken,
    this.userId,
    this.settlementId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: (json['accessToken'] ?? json['token'] ?? '').toString(),
      userId: (json['userId'] as num?)?.toInt(),
      settlementId: json['settlementId']?.toString(),
    );
  }
}
