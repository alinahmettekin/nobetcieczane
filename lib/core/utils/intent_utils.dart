import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:io';
import 'package:nobetcieczane/core/init/cache/cache_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// IntentUtils is a class that contains methods for launching intents.
class IntentUtils {
  IntentUtils._();

  /// launchGoogleMaps is a static method that launches
  /// Google Maps or Apple Maps with the given LatLng.
  /// On iOS, shows native iOS action sheet to choose between Apple Maps and Google Maps.
  /// On Android, directly opens Google Maps.
  static Future<void> launchGoogleMaps(
    BuildContext context,
    LatLng latLng,
  ) async {
    final destinationLatitude = latLng.latitude;
    final destinationLongitude = latLng.longitude;

    if (Platform.isIOS) {
      // On iOS, always ask the user which map app to use
      _showIOSMapSelectionSheet(context, destinationLatitude, destinationLongitude);
    } else {
      // On Android, directly open Google Maps
      await _launchGoogleMapsApp(destinationLatitude, destinationLongitude);
    }
  }

  static Future<void> _launchGoogleMapsApp(double latitude, double longitude) async {
    if (Platform.isAndroid) {
      // Android: Use google.navigation scheme for turn-by-turn navigation
      final navigationUri = Uri(
        scheme: 'google.navigation',
        queryParameters: {
          'q': '$latitude,$longitude',
        },
      );
      
      if (await canLaunchUrl(navigationUri)) {
        await launchUrl(navigationUri);
        return;
      }
    }
    
    // iOS and fallback: Open Google Maps web directions
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Google Maps açılamadı');
    }
  }

  static Future<void> _launchAppleMaps(double latitude, double longitude) async {
    // Apple Maps: Direct URL for navigation
    final appleMapsUrl = 'maps://?daddr=$latitude,$longitude';
    
    if (await canLaunchUrlString(appleMapsUrl)) {
      await launchUrlString(appleMapsUrl);
    } else {
      // Fallback to web maps
      final webUrl = 'https://maps.apple.com/?daddr=$latitude,$longitude';
      
      if (await canLaunchUrlString(webUrl)) {
        await launchUrlString(webUrl);
      }
    }
  }

  static void _showIOSMapSelectionSheet(
    BuildContext context,
    double latitude,
    double longitude,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Harita Seç'),
        message: const Text('Hangi harita uygulamasını kullanmak istersiniz?'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchAppleMaps(latitude, longitude);
            },
            child: const Text('Apple Maps'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _launchGoogleMapsApp(latitude, longitude);
            },
            child: const Text('Google Maps'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('İptal'),
        ),
      ),
    );
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
  ///
  /// After the 3rd open, the review dialog is attempted on every launch
  /// indefinitely. The OS (iOS / Android) handles throttling — if the user
  /// has already given a rating, the platform will suppress the dialog
  /// automatically, so we never need to hard-cap on our side.
  static Future<void> checkAndRequestReview(CacheService cacheService) async {
    final isRequested = await cacheService.isReviewRequested();
    debugPrint('App Review: isRequested status in cache: $isRequested');
    if (isRequested) return;

    await cacheService.incrementAppOpenCount();
    final count = await cacheService.getAppOpenCount();
    debugPrint('App Review: Current app open count: $count');

    if (count >= 3) {
      // Small delay to ensure the UI is fully loaded before showing the dialog
      await Future<void>.delayed(const Duration(seconds: 3));

      debugPrint('App Review: Attempting to request review...');
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        debugPrint('App Review: inAppReview is available, calling requestReview()');
        await inAppReview.requestReview();
        // The OS suppresses the dialog once the user has interacted with it
        // (given a rating). We intentionally do NOT mark isRequested = true
        // here so the dialog is attempted again on the next launch; the
        // platform decides whether to actually display it.
      } else {
        debugPrint('App Review: inAppReview is NOT available on this device/environment.');
      }
    }
  }
}
