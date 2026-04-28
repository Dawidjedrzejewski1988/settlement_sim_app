import '../api/api_client.dart';

class PolicyService {
  final dio = ApiClient().dio;

  Future<Map<String, dynamic>> getTaxPolicy() async {
    final res = await dio.get("/api/policy/tax");
    return res.data;
  }

  Future<void> chooseTaxPolicy({
    required String optionId,
  }) async {
    await dio.post(
      "/api/policy/tax",
      data: {
        "optionId": optionId,
      },
    );
  }
}