class Resource {
  final String code;
  final String? name;
  final double amount;

  Resource({required this.code, this.name, required this.amount});

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      code: (json['code'] ?? '').toString(),
      name: json['name']?.toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'amount': amount};
  }
}
