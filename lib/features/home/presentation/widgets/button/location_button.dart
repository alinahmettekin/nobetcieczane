import 'package:flutter/material.dart';
import 'package:nobetcieczane/core/init/theme/cubit/light/color_scheme_light.dart';

/// LocationButton is a custom widget that is used to show a button with a
/// location icon and a title.
class LocationButton extends StatelessWidget {
  /// LocationButton Constructor
  const LocationButton({
    required this.title,
    required this.onTap,
    this.isLoading = false,
    super.key,
  });

  /// Title of the button
  final String title;

  /// Function that will be called when the button is tapped
  final void Function() onTap;

  /// Shows a loading spinner instead of the icon when true
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoading ? 0.7 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Card(
              elevation: 1,
              color: ColorSchemeLight.instance.blue,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent.withValues(alpha: 0.1),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.gps_fixed,
                              size: 24,
                              color: ColorSchemeLight.instance.red,
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
      ),
    );
  }
}
