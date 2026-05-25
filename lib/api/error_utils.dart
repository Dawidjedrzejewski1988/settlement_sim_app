import 'package:dio/dio.dart';

String extractErrorMessage(Object error) {
  if (error is DioException) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data["error"];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    if (error.type == DioExceptionType.connectionError) {
      return "Brak połączenia z serwerem";
    }
  }

  return "Wystąpił błąd";
}
