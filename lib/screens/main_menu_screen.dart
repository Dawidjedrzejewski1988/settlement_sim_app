import 'package:flutter/material.dart';
import 'sessions_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// TŁO
          Positioned.fill(
            child: Image.asset(
              'assets/ui/menu_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// CIEMNA WARSTWA
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),

          /// MENU
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// LOGO
                  Image.asset(
                    'assets/ui/logo_main.png',
                    width: 500,
                  ),

                  const SizedBox(height: 35),

                  MenuButton(
                    text: "Nowa Gra",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SessionsScreen(),
                        ),
                      );
                    },
                  ),

                  MenuButton(
                    text: "Wczytaj",
                    onPressed: () {},
                  ),

                  MenuButton(
                    text: "Ranking",
                    onPressed: () {},
                  ),

                  MenuButton(
                    text: "Ustawienia",
                    onPressed: () {},
                  ),

                  MenuButton(
                    text: "Wyjście",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Settlement Sim v1.0",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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

class MenuButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 340,
        height: 64,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                hover ? const Color(0xFF9C5A20) : const Color(0xFF5A341F),
            foregroundColor: Colors.amber.shade100,
            elevation: hover ? 12 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: hover ? Colors.amber : Colors.brown.shade300,
                width: 2,
              ),
            ),
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: widget.onPressed,
          child: Text(widget.text),
        ),
      ),
    );
  }
}
