import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.images.prefix = 'assets/';

  runApp(const SettlementSimApp());
}

class SettlementSimApp extends StatelessWidget {
  const SettlementSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Settlement Sim',
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
