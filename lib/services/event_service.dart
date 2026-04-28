import '../api/api_client.dart';

class EventService {
  final dio = ApiClient().dio;

  Future getEvents() async {
    final res = await dio.get("/api/events");
    return res.data;
  }
}