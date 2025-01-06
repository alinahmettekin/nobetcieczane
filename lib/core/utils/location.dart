import 'package:location/location.dart';

/// getUserLocation is a method that returns the user's location data
Future<LocationData?> getUserLocation() async {
  final location = Location();

  var serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  var permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  return location.getLocation();
}
