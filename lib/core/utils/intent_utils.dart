import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IntentUtils {
  IntentUtils._();

  static Future<void> launchGoogleMaps(LatLng latLng) async {
    double destinationLatitude = latLng.latitude;
    double destinationLongitude = latLng.longitude;
    final uri = Uri(scheme: "google.navigation", queryParameters: {
      'q': '$destinationLatitude, $destinationLongitude',
    });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  static launchPhoneCall(String phone) {
    launchUrlString("tel://$phone");
  }

  static launchGooglePlay() async {
    // ignore: deprecated_member_use
    launch('https://play.google.com/store/apps/details?id=com.aatstdio.nobetcieczane');
  }
}
