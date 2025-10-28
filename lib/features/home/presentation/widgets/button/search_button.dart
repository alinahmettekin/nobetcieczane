import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/init/theme/cubit/light/color_scheme_light.dart';

/// SearchButton is a StatelessWidget that contains the search button.
class SearchButton extends StatelessWidget {
  /// SearchButton constructor
  const SearchButton({
    required this.title,
    required this.onTap,
    required this.icon,
    super.key,
  });

  /// Title of the button
  final String title;

  /// Function that will be called when the button is tapped
  final void Function() onTap;

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
            elevation: 1,
            color: ColorSchemeLight.instance.red,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                    child: Icon(icon, size: 24, color: Colors.white),
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
