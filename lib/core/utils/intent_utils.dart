import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// IntentUtils is a class that contains methods for launching intents.
class IntentUtils {
  IntentUtils._();

  /// launchGoogleMaps is a static method that launches
  /// Google Maps with the given LatLng.
  static Future<void> launchGoogleMaps(LatLng latLng) async {
    final destinationLatitude = latLng.latitude;
    final destinationLongitude = latLng.longitude;
    final uri = Uri(
      scheme: 'google.navigation',
      queryParameters: {
        'q': '$destinationLatitude, $destinationLongitude',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  /// launchPhoneCall is a static method that launches a phone call
  static void launchPhoneCall(String phone) {
    launchUrlString('tel://$phone');
  }

  /// launchGooglePlay is a static method that launches Google Play
  /// to download the app or give a review.
  static Future<void> launchGooglePlay() async {
    /// urlLauncher method is not working properly in android
    // ignore: deprecated_member_use
    await launch(
      'https://play.google.com/store/apps/details?id=com.aatstdio.nobetcieczane',
    );
  }
}
