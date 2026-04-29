import 'package:flutter/material.dart';
import '../api/services.dart';
import 'sessions_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool loading = false;
  String message = "";

  Future<void> submit() async {
    setState(() {
      loading = true;
      message = "";
    });

    try {
      final service = AuthService();

      if (isLogin) {
        await service.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SessionsScreen(),
          ),
        );
      } else {
        await service.register(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        await service.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SessionsScreen(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = e.toString().replaceAll("Exception: ", "");
      });
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
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
              color: Colors.black.withValues(alpha: 0.55)
            ),
          ),

          Center(
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 180,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    isLogin ? "Logowanie" : "Rejestracja",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Hasło",
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (message.isNotEmpty)
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: message.contains("utworz")
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              isLogin ? "Zaloguj" : "Zarejestruj",
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        message = "";
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Nie masz konta? Zarejestruj się"
                          : "Masz konto? Zaloguj się",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 15,
                      ),
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