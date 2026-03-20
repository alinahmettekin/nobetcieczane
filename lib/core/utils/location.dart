import 'dart:async';

import 'package:location/location.dart';

/// Represents the outcome of a location request.
enum LocationResultStatus {
  /// Location successfully obtained.
  granted,

  /// User denied the permission (can be asked again).
  denied,

  /// User permanently denied the permission (must go to settings).
  deniedForever,

  /// Device location service is turned off.
  serviceDisabled,
}

/// Holds either a successful [LocationData] or a [LocationResultStatus] error.
class LocationResult {
  const LocationResult._({this.data, required this.status});

  factory LocationResult.success(LocationData data) =>
      LocationResult._(data: data, status: LocationResultStatus.granted);

  factory LocationResult.denied() =>
      const LocationResult._(status: LocationResultStatus.denied);

  factory LocationResult.deniedForever() =>
      const LocationResult._(status: LocationResultStatus.deniedForever);

  factory LocationResult.serviceDisabled() =>
      const LocationResult._(status: LocationResultStatus.serviceDisabled);

  /// Non-null when [status] is [LocationResultStatus.granted].
  final LocationData? data;
  final LocationResultStatus status;

  bool get isSuccess => status == LocationResultStatus.granted;
}

/// Returns a [LocationResult] describing what happened during the location
/// permission + fetch flow. Callers should inspect [LocationResult.status]
/// to show the appropriate UI message.
Future<LocationResult> getUserLocation() async {
  final location = Location();

  try {
    // 1. Check / request location service
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return LocationResult.serviceDisabled();
      }
    }

    // 2. Check permission status
    var permissionGranted = await location.hasPermission();

    // 3. Permanently denied → caller must open settings
    if (permissionGranted == PermissionStatus.deniedForever) {
      return LocationResult.deniedForever();
    }

    // 4. Not yet granted → ask the user
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted == PermissionStatus.deniedForever) {
        return LocationResult.deniedForever();
      }

      if (permissionGranted == PermissionStatus.denied) {
        return LocationResult.denied();
      }
    }

    // 5. Granted (or grantedLimited on iOS) → fetch location
    if (permissionGranted == PermissionStatus.granted ||
        permissionGranted == PermissionStatus.grantedLimited) {
      final locationData = await location.getLocation();
      return LocationResult.success(locationData);
    }

    return LocationResult.denied();
  } catch (_) {
    return LocationResult.denied();
  }
}
