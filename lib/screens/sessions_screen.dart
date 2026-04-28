import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../services/session_service.dart';
import 'game_screen.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final SessionService service = SessionService();
  final TextEditingController controller = TextEditingController();

  List<SessionModel> sessions = [];
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

      sessions =
          (response.data as List).map((e) => SessionModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("SESSION ERROR: $e");
    }

    setState(() => loading = false);
  }

  Future<void> createSession() async {
    if (controller.text.trim().isEmpty) return;

    try {
      await service.createSession(controller.text.trim());
      controller.clear();
      loadSessions();
    } catch (e) {
      debugPrint("CREATE SESSION ERROR: $e");
    }
  }

  Future<void> joinSession(String id) async {
    try {
      final response = await service.joinSession(id);

      final accessToken = response.data["accessToken"];
      final settlementId = response.data["settlementId"];

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

  Future<void> deleteSession(String id) async {
    try {
      await service.deleteSession(id);
      loadSessions();
    } catch (e) {
      debugPrint("DELETE ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sesje Gry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Nazwa sesji",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: createSession,
                  child: const Text("Utwórz"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final s = sessions[index];

                        return Card(
                          child: ListTile(
                            title: Text(s.name),
                            subtitle: Text(
                              "Graczy: ${s.playerCount} | ${s.status}",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () => joinSession(s.id),
                                  child: const Text("Dołącz"),
                                ),
                                IconButton(
                                  onPressed: () => deleteSession(s.id),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
