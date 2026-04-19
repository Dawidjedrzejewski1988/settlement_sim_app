import 'package:signalr_netcore/signalr_client.dart';

class GameHubService {
  HubConnection? _connection;

  bool get isConnected =>
      _connection != null && _connection!.state == HubConnectionState.Connected;

  Future<void> connect(String token) async {
    if (isConnected) return;

    _connection = HubConnectionBuilder()
        .withUrl(
          "https://www.settlementsim.pl/hubs/game",
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
            transport: HttpTransportType.LongPolling,
          ),
        )
        .build();

    try {
      await _connection!.start();
      print("SignalR connected");
    } catch (e) {
      print("SignalR connection error: $e");
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      try {
        await _connection!.stop();
      } catch (_) {}
      _connection = null;
      print("SignalR disconnected");
    }
  }

  Future<void> reconnect(String token) async {
    await disconnect();
    await connect(token);
  }

  Future<void> joinSession(String sessionId) async {
    if (!isConnected) return;

    try {
      await _connection!.invoke("JoinSession", args: [sessionId]);
    } catch (e) {
      print("JoinSession error: $e");
    }
  }

  Future<void> leaveSession(String sessionId) async {
    if (!isConnected) return;

    try {
      await _connection!.invoke("LeaveSession", args: [sessionId]);
    } catch (_) {}
  }

  void onTickUpdate(Function(dynamic) handler) {
    _connection?.off("TickUpdate");
    _connection?.on("TickUpdate", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        handler(arguments[0]);
      }
    });
  }

  void onSettlementUpdated(Function(dynamic) handler) {
    _connection?.off("SettlementUpdated");
    _connection?.on("SettlementUpdated", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        handler(arguments[0]);
      }
    });
  }

  void onBuildingsUpdated(Function(dynamic) handler) {
    _connection?.off("BuildingsUpdated");
    _connection?.on("BuildingsUpdated", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        handler(arguments[0]);
      }
    });
  }

  void onEventTriggered(Function(dynamic) handler) {
    _connection?.off("EventTriggered");
    _connection?.on("EventTriggered", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        handler(arguments[0]);
      }
    });
  }
}
