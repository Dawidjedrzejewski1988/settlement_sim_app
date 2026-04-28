import '../api/api_client.dart';

class MarketService {
  final dio = ApiClient().dio;

  Future<void> buyOffer({
    required String offerId,
    required String settlementId,
    required double quantity,
  }) async {
    await dio.post(
      "/api/market/offers/$offerId/buy",
      data: {
        "buyerSettlementId": settlementId,
        "quantity": quantity,
      },
    );
  }

  Future getOffers() async {
    final res = await dio.get("/api/market/offers");
    return res.data;
  }

  Future createOffer({
    required String settlementId,
    required String resourceType,
    required double quantity,
    required double pricePerUnit,
  }) async {
    await dio.post(
      "/api/market/offers",
      data: {
        "settlementId": settlementId,
        "resourceType": resourceType,
        "quantity": quantity,
        "pricePerUnit": pricePerUnit,
      },
    );
  }
}