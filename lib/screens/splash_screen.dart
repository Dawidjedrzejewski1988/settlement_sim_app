import 'package:flutter/material.dart';
import '../api/token_storage.dart';
import 'login_screen.dart';
import 'sessions_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  String _loadingText = "Inicjalizacja osady...";

  @override
  void initState() {
    super.initState();
    _bootApp();
  }

  Future<void> _bootApp() async {
    try {
      final assetsToLoad = [
        'assets/images/logo.png',
        'assets/images/buildings/tartak.png',
        'assets/images/buildings/chata.png',
        'assets/images/buildings/kamieniolom.png',
        'assets/images/buildings/farma.png',
      ];

      final totalAssets = assetsToLoad.length;

      for (int i = 0; i < assetsToLoad.length; i++) {
        final asset = assetsToLoad[i];

        try {
          await precacheImage(AssetImage(asset), context);
        } catch (_) {
          // jeśli asset nie istnieje, nie wywalamy aplikacji
        }

        if (!mounted) return;

        setState(() {
          _progress = (i + 1) / totalAssets;
          _loadingText = "Ładowanie zasobów (${i + 1}/$totalAssets)...";
        });

        await Future.delayed(const Duration(milliseconds: 250));
      }

      if (!mounted) return;

      setState(() {
        _loadingText = "Sprawdzanie sesji gracza...";
      });

      await Future.delayed(const Duration(milliseconds: 600));

      final token = await TokenStorage.getToken();

      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SessionsScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingText = "Błąd uruchamiania aplikacji";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black87, blurRadius: 20),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.castle, size: 80, color: Colors.amber),
                const SizedBox(height: 16),

                const Text(
                  "ŁADOWANIE OSADY",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.amber,
                      ),
                      minHeight: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  _loadingText,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),

                const SizedBox(height: 8),

                Text(
                  "${(_progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
