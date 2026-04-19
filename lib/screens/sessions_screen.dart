import 'package:flutter/material.dart';
import '../api/session_service.dart';
import '../api/token_storage.dart';
import '../screens/game_screen.dart';
import '../models/session.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final service = SessionService();

  List<Session> sessions = [];
  bool isLoading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      isLoading = true;
      error = "";
    });

    try {
      final data = await service.getSessions();

      if (!mounted) return;

      setState(() {
        sessions = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString().replaceAll("Exception: ", "");
        isLoading = false;
      });
    }
  }

  Future<void> join(String sessionId) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final token = await service.joinSession(sessionId);

      await TokenStorage.saveToken(token);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(token: token, sessionId: sessionId),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    }
  }

  Widget _sessionCard(Session s) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.black.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.amber),
      ),
      child: ListTile(
        title: Text(
          s.name ?? "Brak nazwy",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "Graczy: ${s.playerCount}",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: ElevatedButton(
          onPressed: () => join(s.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: const Text("Dołącz"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("Wybierz serwer"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: load)],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : error.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          : sessions.isEmpty
          ? const Center(
              child: Text(
                "Brak dostępnych sesji",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                return _sessionCard(sessions[index]);
              },
            ),
    );
  }
}
