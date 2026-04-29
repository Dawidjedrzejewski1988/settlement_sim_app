import 'package:flutter/material.dart';
import '../api/models.dart';
import '../api/services.dart';
import 'game_screen.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final SessionService service = SessionService();

  List<Session> sessions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    try {
      setState(() => loading = true);

      final response = await service.getSessions();
      sessions = response;
    } catch (e) {
      debugPrint("SESSION ERROR: $e");
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> joinSession(String id) async {
    try {
      final response = await service.joinSession(id);

      if (!mounted) return;

      final accessToken = response.accessToken;
      final settlementId = response.settlementId;

      if (accessToken == null) {
        debugPrint("Brak tokena lub settlementId");
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            token: accessToken,
            settlementId: settlementId,
          ),
        ),
      );
    } catch (e) {
      debugPrint("JOIN ERROR: $e");
    }
  }

  String translateStatus(String? status) {
    switch (status) {
      case "Running":
        return "W trakcie";
      case "Finished":
        return "Zakończona";
      default:
        return status ?? "Nieznany";
    }
  }

  Color statusColor(String? status) {
    switch (status) {
      case "Running":
        return Colors.green;
      case "Finished":
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/ui/menu_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),

          Center(
            child: Container(
              width: 700,
              height: 600,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Wybierz sesję",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              final s = sessions[index];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.name ?? "Brak nazwy",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Graczy: ${s.playerCount}",
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                          Text(
                                            "Status: ${translateStatus(s.status)}",
                                            style: TextStyle(
                                              color: statusColor(s.status),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ElevatedButton(
                                      onPressed: () => joinSession(s.id),
                                      child: const Text("Dołącz"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}