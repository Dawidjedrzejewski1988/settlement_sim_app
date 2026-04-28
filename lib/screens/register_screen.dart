import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  String message = "";

  Future<void> register() async {
    setState(() {
      loading = true;
      message = "";
    });

    try {
      final service = AuthService();

      await service.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      setState(() {
        message = "Konto utworzone!";
      });

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        message = "Błąd rejestracji";
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Rejestracja",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Hasło",
                ),
              ),
              const SizedBox(height: 20),
              if (message.isNotEmpty)
                Text(
                  message,
                  style: TextStyle(
                    color: message == "Konto utworzone!"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : register,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Załóż konto"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
