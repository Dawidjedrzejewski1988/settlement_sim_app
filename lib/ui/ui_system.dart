// lib/ui/ui_system.dart

import 'package:flutter/material.dart';

class UiColors {
  static const Color gold = Color(0xFFD6A74A);
  static const Color goldDark = Color(0xFF8E6725);

  static const Color woodLight = Color(0xFF5C351A);
  static const Color wood = Color(0xFF3C2312);
  static const Color woodDark = Color(0xFF1E120A);

  static const Color panel = Color(0xEE1C120C);

  static const Color green = Color(0xFF6FAE2E);
  static const Color red = Color(0xFFB33A2B);
  static const Color blue = Color(0xFF345D96);

  static const Color text = Color(0xFFF4E7C2);
  static const Color textSoft = Color(0xCCF4E7C2);
}

class UiText {
  static TextStyle title({
    double size = 24,
    Color color = UiColors.text,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
      letterSpacing: 0.4,
    );
  }

  static TextStyle body({
    double size = 15,
    Color color = UiColors.textSoft,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
    );
  }

  static TextStyle value({
    double size = 16,
    Color color = Colors.white,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }
}

class UiDecor {
  static BoxDecoration woodPanel({
    double radius = 18,
  }) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          UiColors.woodLight,
          UiColors.wood,
          UiColors.woodDark,
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: UiColors.gold,
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration card({
    bool active = false,
  }) {
    return BoxDecoration(
      color: active
          ? UiColors.gold.withValues(alpha: 0.14)
          : Colors.black.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: active ? UiColors.gold : Colors.white10,
      ),
    );
  }

  static BoxDecoration button({
    required Color color,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: 0.95),
          color.withValues(alpha: 0.75),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white24,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class UiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  final double height;

  const UiButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = UiColors.green,
    this.icon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.55 : 1,
        child: Container(
          height: height,
          decoration: UiDecor.button(
            color: color,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: UiText.value(
                    size: 16,
                    color: Colors.white,
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

class UiPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  const UiPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.radius = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: UiDecor.woodPanel(
        radius: radius,
      ),
      child: child,
    );
  }
}
