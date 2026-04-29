import 'package:signalr_netcore/signalr_client.dart';
import 'dart:developer' as dev;
import './api_client.dart';
import './models.dart';

class GameHubService {
  HubConnection? _connection;

  bool get isConnected =>
      _connection != null &&
      _connection!.state == HubConnectionState.Connected;

  Future<void> connect() async {
    if (isConnected) return;

    final connection = HubConnectionBuilder()
        .withUrl(
          "https://www.settlementsim.pl/hubs/game",
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              return await ApiClient().storage.read(key: "token") ?? "";
            },
          ),
        )
        .withAutomaticReconnect()
        .build();

    _connection = connection;

    try {
      final startFuture = connection.start();
      await startFuture!.timeout(const Duration(seconds: 10));

      dev.log("SignalR connected");
    } catch (e) {
      dev.log("SignalR connection error", error: e);
    }
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      try {
        _connection?.off("TickUpdate");
        _connection?.off("SettlementUpdated");
        _connection?.off("BuildingsUpdated");
        _connection?.off("EventTriggered");

        await _connection!.stop();
      } catch (_) {}

      _connection = null;
      dev.log("SignalR disconnected");
    }
  }

  Future<void> reconnect() async {
    try {
      await disconnect();
    } catch (_) {}

    await connect();
  }

  Future<void> joinSession(String sessionId) async {
    if (!isConnected) {
      dev.log("SignalR not connected");
      return;
    }

    try {
      await _connection!.invoke("JoinSession", args: [sessionId]);
    } catch (e) {
      dev.log("JoinSession error", error: e);
    }
  }

  Future<void> leaveSession(String sessionId) async {
    if (!isConnected) return;

    try {
      await _connection!.invoke("LeaveSession", args: [sessionId]);
    } catch (e) {
      dev.log("LeaveSession error", error: e);
    }
  }

  // =============================
  // EVENTS
  // =============================

  void onTickUpdate(void Function(dynamic tick) handler) {
    _connection?.off("TickUpdate");
    _connection?.on("TickUpdate", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        handler(arguments[0]);
      }
    });
  }

  void onSettlementUpdated(void Function(Settlement) handler) {
    _connection?.off("SettlementUpdated");
    _connection?.on("SettlementUpdated", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        handler(Settlement.fromJson(data));
      }
    });
  }

  void onBuildingsUpdated(void Function(List<Building>) handler) {
    _connection?.off("BuildingsUpdated");
    _connection?.on("BuildingsUpdated", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final list = (arguments[0] as List? ?? [])
            .map((e) => Building.fromJson(e as Map<String, dynamic>))
            .toList();

        handler(list);
      }
    });
  }

  void onEventTriggered(void Function(Event) handler) {
    _connection?.off("EventTriggered");
    _connection?.on("EventTriggered", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0] as Map<String, dynamic>;
        handler(Event.fromJson(data));
      }
    });
  }
}