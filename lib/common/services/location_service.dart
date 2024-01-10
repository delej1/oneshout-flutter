import 'dart:async';
import 'dart:io';
import 'package:app_core/app_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService with UiLogger {
  Future<Position?> getLocation() async {
    logger.d('getting location...');
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        final enabled = await Geolocator.openLocationSettings();
        if (!enabled) return null;
        // return null;
        // return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        if (Platform.isAndroid) {
          permission = await Geolocator.requestPermission();

          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.

            return null;
          }
        }
        if (Platform.isIOS) {
          await Geolocator.openAppSettings();
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return null;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  // Future<bool> hasLocationPermissions() async {
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted;
  //   final location = Location();

  //   serviceEnabled = await location.serviceEnabled();

  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return false;
  //     }
  //   }

  //   permissionGranted = await location.hasPermission();

  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return false;
  //     }
  //   }

  //   return true;
  // }
}
