import 'dart:math';

import 'package:flutter/services.dart';
import 'package:huawei_location/geofence/geofence.dart';
import 'package:huawei_location/geofence/geofence_request.dart';
import 'package:huawei_location/geofence/geofence_service.dart';
import 'package:prefs/prefs.dart';
class MyGeofenceService{

  List<Geofence> geofenceList;
  List<String> geofenceIdList;
  int fenceCount;
  int callbackId;
  int requestCode;
  GeofenceRequest geofenceRequest;
  GeofenceService geofenceService;

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  void initGeofenceService(){
    geofenceList = <Geofence>[];
    geofenceIdList = <String>[];
    geofenceService = GeofenceService();
    geofenceRequest = GeofenceRequest();
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  void addGeofence()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String uniqueId = getRandomString(5);

      if (uniqueId == '') {
          prefs.setString("addGeofence", "UniqueId cannot be empty.");
      } else if (geofenceIdList.contains(uniqueId)) {
          prefs.setString("addGeofence", "Geofence with this UniqueId already exists.");
      } else {
        int conversions = 60;
        int validDuration = 1000000;
        double latitude = 41.014759;
        double longitude = 29.104684;
        double radius = 100;
        int notificationInterval = 100;
        int dwellDelayTime = 10000;

        Geofence geofence = Geofence(
          uniqueId: uniqueId,
          conversions: conversions,
          validDuration: validDuration,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          notificationInterval: notificationInterval,
          dwellDelayTime: dwellDelayTime,
        );

        geofenceList.add(geofence);
        geofenceIdList.add(geofence.uniqueId);

        prefs.setString("addGeofence", "Geofence added successfully.\n" + geofenceList.toString());
      }
    } catch (e) {
        prefs.setString("addGeofence", e.toString());
    }
  }

  void createGeofenceList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (requestCode != null) {
      prefs.setString("createGeofenceList", "Already created Geofence list. Call deleteGeofenceList method first.");
    } else if (geofenceList.isEmpty) {
      prefs.setString("createGeofenceList", "Add Geofence first.");
    } else {
      geofenceRequest.geofenceList = geofenceList;
      geofenceRequest.initConversions = 5;
      try {
        requestCode =
        await geofenceService.createGeofenceList(geofenceRequest);
        prefs.setString("createGeofenceList", "Created geofence list successfully.");
        print("GeofenceListHERE 2: " +  geofenceList.toString());
      } on PlatformException catch (e) {
        prefs.setString("createGeofenceList", e.toString());
      }
    }
  }

  void deleteGeofenceList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (requestCode == null) {
      prefs.setString("deleteGeofenceList", "Call createGeofenceList method first.");
    } else {
      try {
        await geofenceService.deleteGeofenceList(requestCode);
        requestCode = null;
        prefs.setString("deleteGeofenceList", "Geofence deleted.");
      } on PlatformException catch (e) {
        prefs.setString("deleteGeofenceList", e.toString());
      }
    }
  }

  void deleteGeofenceListWithIds() async {
    if (requestCode == null) {
      print("Call createGeofenceList method first.");
    } else {
      try {
        await geofenceService.deleteGeofenceListWithIds(geofenceIdList);
        requestCode = null;
        print("Geofence list is successfully deleted.");
      } on PlatformException catch (e) {
        print(e.toString());
      }
    }
  }
}