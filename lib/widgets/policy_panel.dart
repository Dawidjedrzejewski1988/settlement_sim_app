// lib/widgets/policy_panel.dart

import 'package:flutter/material.dart';
import '../ui/ui_system.dart';

class PolicyPanel extends StatelessWidget {
  final Map policy;
  final VoidCallback onClose;
  final Function(String optionId) onChoose;

  const PolicyPanel({
    super.key,
    required this.policy,
    required this.onClose,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    final title = policy["title"]?.toString() ?? "Polityka";
    final description = policy["description"]?.toString() ?? "";
    final options = (policy["options"] as List<dynamic>?) ?? [];

    return Positioned(
      top: 90,
      left: 20,
      right: 20,
      bottom: 20,
      child: UiPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: UiText.title(
                      size: 28,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: UiText.body(),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: options.isEmpty
                  ? const Center(
                      child: Text(
                        "Brak decyzji",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (_, index) {
                        final item = options[index];

                        final id = item["id"].toString();

                        final label = item["label"]?.toString() ?? "";

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          padding: const EdgeInsets.all(
                            12,
                          ),
                          decoration: UiDecor.card(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: UiText.value(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: UiButton(
                                  text: "Wybierz",
                                  icon: Icons.gavel,
                                  color: UiColors.gold,
                                  onTap: () => onChoose(
                                    id,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
