import 'package:flutter/material.dart';

/// SelectionButton is a StatelessWidget that contains the selection button.
class SelectionButton extends StatelessWidget {
  /// SelectionButton constructor
  const SelectionButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.icon,
    super.key,
  });

  /// Title of the button
  final String title;

  /// Subtitle of the button
  final String subtitle;

  /// Function that will be called when the button is tapped
  final VoidCallback? onTap;

  /// Icon of the button
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                    child: Icon(icon, size: 24, color: Colors.red),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
