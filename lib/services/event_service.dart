import 'package:dio/dio.dart';

class EventService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://settlementsim.pl",
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<Response> getEvents(String token) async {
    return await dio.get(
      "/api/events",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}
