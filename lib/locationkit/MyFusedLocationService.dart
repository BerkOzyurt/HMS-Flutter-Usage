import 'dart:async';

import 'package:flutter/services.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/hwlocation.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_availability.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/location/location_settings_request.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:huawei_map/components/components.dart';
import 'package:prefs/prefs.dart';

class MyFusedLocationService {

  LatLng center;
  PermissionHandler permissionHandler;
  FusedLocationProviderClient locationService;
  LocationSettingsRequest locationSettingsRequest;
  final LocationRequest locationRequest = LocationRequest()..interval = 500;
  StreamSubscription<Location> streamSubscription;
  int _requestCode;

  void initFusedLocation()async{
    requestPermission();

    permissionHandler = PermissionHandler();
    locationService = FusedLocationProviderClient();
    locationSettingsRequest =LocationSettingsRequest(requests: <LocationRequest>[locationRequest]);

    getLastLocation();
  }

  void requestPermission() async {
    bool hasPermission = await permissionHandler.hasLocationPermission();
    if (!hasPermission) {
      try {
        bool status = await permissionHandler.requestLocationPermission();
        print("Is permission granted $status");
      } catch (e) {
        print(e.toString());
      }
    }
    bool backgroundPermission =
    await permissionHandler.hasBackgroundLocationPermission();
    if (!backgroundPermission) {
      try {
        bool backStatus =
        await permissionHandler.requestBackgroundLocationPermission();
        print("Is background permission granted $backStatus");
      } catch (e) {
        print(e.toString);
      }
    }
  }

  void requestLocationUpdates() async {
    if (_requestCode == null) {
      try {
        final int requestCode =
        await locationService.requestLocationUpdates(locationRequest);
        _requestCode = requestCode;
        print("Location updates requested successfully");

        streamSubscription = locationService.onLocationData.listen((location) {
          print("fullLocation : " + location.toString());
        });
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else {
      print("Already requested location updates. Try removing location updates");
    }
  }

  void removeLocationUpdates() async {
    if (_requestCode != null) {
      try {
        await locationService.removeLocationUpdates(_requestCode);
        _requestCode = null;
        print("Location updates are removed successfully");
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else {
      print("requestCode does not exist. Request location updates first");
    }
  }

  void removeLocationUpdatesOnDispose() async {
    if (_requestCode != null) {
      try {
        await locationService.removeLocationUpdates(_requestCode);
        _requestCode = null;
      } on PlatformException catch (e) {
        print(e.toString());
      }
    }
  }

  void getLastLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final Location location = await locationService.getLastLocation();
      prefs.setString("currentLocation", "LatLng : " + location.latitude.toString().substring(0,10) + ", " + location.longitude.toString().substring(0,10));
    }
    on PlatformException catch (e) {
      prefs.setString("currentLocation", e.toString());
    }
  }

  void getAllLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final HWLocation location = await locationService.getLastLocationWithAddress(locationRequest);
      prefs.setString("allLocationInfo", location.toString());
    }
    on PlatformException catch (e) {
      prefs.setString("allLocationInfo", e.toString());
    }
  }

  void getLocationAvailability() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final LocationAvailability availability =
      await locationService.getLocationAvailability();

      final result = StringBuffer();
      result.writeln("getLocationAvailability Location available: ${availability.isLocationAvailable}");
      result.write("getLocationAvailability Details: ${availability.toString()}");

      prefs.setString("locationAvailability", "Location Availability : " + availability.isLocationAvailable.toString()
          + "\n" + "Result : " + result.toString());

    } on PlatformException catch (e) {
      prefs.setString("locationAvailability",e.toString());
    }
  }
}