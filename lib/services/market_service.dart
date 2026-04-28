import 'package:dio/dio.dart';

class MarketService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://settlementsim.pl",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  void _auth(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<Response> getOffers(String token) async {
    _auth(token);

    return await dio.get(
      "/api/market/offers",
    );
  }

  Future<void> createOffer({
    required String token,
    required String settlementId,
    required String resourceType,
    required double quantity,
    required double pricePerUnit,
  }) async {
    _auth(token);

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

  Future<void> buyOffer({
    required String token,
    required String offerId,
    required String settlementId,
    required double quantity,
  }) async {
    _auth(token);

    await dio.post(
      "/api/market/offers/$offerId/buy",
      data: {
        "buyerSettlementId": settlementId,
        "quantity": quantity,
      },
    );
  }

  Future<void> deleteOffer({
    required String token,
    required String offerId,
  }) async {
    _auth(token);

    await dio.delete(
      "/api/market/offers/$offerId",
    );
  }
}
