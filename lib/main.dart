import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.images.prefix = 'assets/';

  runApp(const SettlementSimApp());
}

class SettlementSimApp extends StatelessWidget {
  const SettlementSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Settlement Sim',
      theme: ThemeData.dark(),
      home: const AuthScreen(),
    );
  }
}