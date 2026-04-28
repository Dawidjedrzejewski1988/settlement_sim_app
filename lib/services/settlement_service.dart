import '../api/api_client.dart';

class SettlementService {
  final dio = ApiClient().dio;

  Future getSettlement() async {
    final res = await dio.get("/api/settlement");
    return res.data;
  }
}