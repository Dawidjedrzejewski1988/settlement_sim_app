import 'package:flutter/material.dart';
import '../ui/ui_system.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: UiColors.gold, width: 2),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A3813),
              Color(0xFF3B1C08),
              Color(0xFF1B0B03),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Witaj w Settlement Sim!",
              style: UiText.title(size: 34),
            ),

            const SizedBox(height: 18),

            Text(
              "Twoim zadaniem jest rozwój własnej osady i przekształcenie jej w potężne oraz dobrze prosperujące miasto.\n\nBuduj nowe budynki produkcyjne i mieszkalne, zarządzaj ekonomią, handlem oraz poziomem morale mieszkańców.\n\nRozwijaj technologie i specjalizacje przemysłowe, aby zwiększać wydajność osady i odblokowywać nowe bonusy.\n\nNa rynku możesz kupować oraz sprzedawać surowce zależnie od aktualnych cen i sytuacji gospodarczej.\n\nSystem polityki pozwala decydować o podatkach, pracy mieszkańców oraz dystrybucji żywności, co wpływa na morale i rozwój populacji.\n\nW trakcie gry będą pojawiały się losowe wydarzenia takie jak pożary, susze czy festiwale, które mogą pomóc lub zaszkodzić osadzie.\n\nWykonuj zadania, rozwijaj populację i wspinaj się w rankingu najlepszych osad.",
              textAlign: TextAlign.center,
              style: UiText.body(size: 18),
            ),

            const SizedBox(height: 26),

            SizedBox(
              width: 220,
              child: UiButton(
                text: "Rozpocznij",
                icon: Icons.play_arrow,
                color: UiColors.green,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}