import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Włączenie pełnego ekranu (ukrycie pasków systemowych)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Opcjonalnie: wymuszenie orientacji poziomej (landscape)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const SettlementSimApp());
}

class SettlementSimApp extends StatelessWidget {
  const SettlementSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settlement Sim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      // TUTAJ ZMIANA: Aplikacja teraz ładuje SplashScreen zamiast zwykłego tekstu!
      home: const SplashScreen(),
    );
  }
}
