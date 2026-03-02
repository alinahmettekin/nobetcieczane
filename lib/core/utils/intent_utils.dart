import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:nobetcieczane/core/init/cache/cache_service.dart';
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
  static Future<void> launchGooglePlay() async {
    /// urlLauncher method is not working properly in android
    // ignore: deprecated_member_use
    await launch(
      'https://play.google.com/store/apps/details?id=com.aatstdio.nobetcieczane',
    );
  }

  /// requestAppReview is a static method that requests an app review
  /// using the in_app_review package.
  static Future<void> requestAppReview() async {
    final inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      // Fallback to store listing if requestReview is not available
      await inAppReview.openStoreListing(
        appStoreId: '...', // Update this for iOS if needed
        microsoftStoreId: '...', // Update this for Windows if needed
      );
    }
  }

  /// checkAndRequestReview is a static method that checks if the app review
  /// should be requested based on the app open count.
  static Future<void> checkAndRequestReview(CacheService cacheService) async {
    final isRequested = await cacheService.isReviewRequested();
    debugPrint('App Review: isRequested status in cache: $isRequested');
    if (isRequested) return;

    await cacheService.incrementAppOpenCount();
    final count = await cacheService.getAppOpenCount();
    debugPrint('App Review: Current app open count: $count');

    // Show review dialog on 3rd, 10th and 20th opens
    if (count >= 3) {
      // Small delay to ensure the UI is fully loaded and stable before showing the dialog
      await Future<void>.delayed(const Duration(seconds: 3));

      debugPrint('App Review: Attempting to request review...');
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        debugPrint('App Review: inAppReview is available, calling requestReview()');
        await inAppReview.requestReview();
        // We set it as requested to avoid showing it too many times in one session
        // or if the user already interacted with it.
        // Note: requestReview does not return whether the user actually reviewed.
        if (count == 20) {
          debugPrint('App Review: Max count reached, marking as requested in cache.');
          await cacheService.setReviewRequested(requested: true);
        }
      } else {
        debugPrint('App Review: inAppReview is NOT available on this device/environment.');
      }
    }
  }
}
