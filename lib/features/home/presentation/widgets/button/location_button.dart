import 'package:flutter/material.dart';

/// LocationButton is a custom widget that is used to show a button with a
/// location icon and a title.
class LocationButton extends StatelessWidget {
  /// LocationButton Constructor
  const LocationButton({
    required this.title,
    required this.onTap,
    super.key,
  });

  /// Title of the button
  final String title;

  /// Function that will be called when the button is tapped
  final void Function() onTap;

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
            color: Colors.blueAccent.shade200,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.gps_fixed,
                      size: 24,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
