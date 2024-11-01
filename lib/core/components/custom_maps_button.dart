import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nobetcieczane/core/utils/intent_utils.dart';
import 'package:nobetcieczane/translations/locale_keys.g.dart';

class CustomMapsButton extends StatelessWidget {
  final LatLng latLng;
  const CustomMapsButton({super.key, required this.latLng});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        IntentUtils.launchGoogleMaps(latLng);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 5),
              Text(LocaleKeys.navigate_button.tr()),
            ],
          ),
        ),
      ),
    );
  }
}
