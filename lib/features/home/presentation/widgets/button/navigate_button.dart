import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/init/lang/translations/locale_keys.g.dart';
import 'package:nobetcieczane/core/init/theme/cubit/light/color_scheme_light.dart';
import 'package:nobetcieczane/core/utils/intent_utils.dart';

/// NavigateButton is a StatelessWidget that contains the navigate button.
class NavigateButton extends StatelessWidget {
  /// NavigateButton constructor
  const NavigateButton({required this.latLng, super.key});

  /// latLng is a final variable of type LatLng
  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        IntentUtils.launchGoogleMaps(latLng);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: ColorSchemeLight.instance.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 5),
              Text(
                LocaleKeys.buttons_navigate.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
