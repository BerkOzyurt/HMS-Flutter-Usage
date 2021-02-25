import 'dart:async';

import 'package:huawei_location/activity/activity_identification_data.dart';
import 'package:huawei_location/activity/activity_identification_response.dart';
import 'package:huawei_location/activity/activity_identification_service.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:prefs/prefs.dart';

class MyActivityIdentService{
  int callbackId;
  PermissionHandler permissionHandler;
  ActivityIdentificationService activityIdentificationService;
  StreamSubscription<ActivityIdentificationResponse> streamSubscription;
  int _vehicle;
  int _bike;
  int _foot;
  int _still;
  int _others;
  int _tilting;
  int _walking;
  int _running;
  int requestCode;

  void initActivityIdentification(){
    permissionHandler = PermissionHandler();
    activityIdentificationService = ActivityIdentificationService();
    streamListen();
    _vehicle = 0;
    _bike = 0;
    _foot = 0;
    _still = 0;
    _others = 0;
    _tilting = 0;
    _walking = 0;
    _running = 0;
  }

  void requestActivityRecognitionPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      bool status = await permissionHandler.requestActivityRecognitionPermission();
      if(status){
        prefs.setString("requestActivityRecognitionPermission", "Activity Recognition Permission Granted.");
      }else{
        prefs.setString("requestActivityRecognitionPermission", "Activity Recognition Permission Don't Granted");
      }
    } catch (e) {
      prefs.setString("requestActivityRecognitionPermission", e.toString());
    }
  }

  void hasPermission() async {
    bool status = await permissionHandler.hasActivityRecognitionPermission();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(status){
      prefs.setString("permissionResult", "Permission Granted.");
    }else{
      prefs.setString("permissionResult", "Permission Don't Granted");
    }
  }

  void  createActivityIdentificationUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      requestCode = await activityIdentificationService.createActivityIdentificationUpdates(5000);
      prefs.setString("createActivityIdentificationUpdates", "Created Activity Identification Updates successfully.");
    } catch (e) {
      prefs.setString("createActivityIdentificationUpdates",  e.toString());
    }
  }

  void  onActivityIdentificationResponse(ActivityIdentificationResponse response)  {
    for (ActivityIdentificationData data
    in response.activityIdentificationDatas) {
      setChange(data.identificationActivity , data.possibility);
      print("data.identificationActivity" + data.identificationActivity.toString() + "data.possibility" + data.possibility.toString());

      //data.identificationActivity include activity type like vehicle,bike etc.
      //data.posibility The confidence for the user to execute the activity.
      //The confidence ranges from 0 to 100. A larger value indicates more reliable activity authenticity.
    }
  }
  void streamListen() {
    streamSubscription = activityIdentificationService.onActivityIdentification.listen(onActivityIdentificationResponse);
    print( "Vehicle(100): " + _vehicle.toString() + "Bike(101): " + _bike.toString() + "Foot(102): " + _foot.toString() + "Still(103): " + _still.toString()
    + "Others(104): " + _others.toString() + "Tilting(105): " + _tilting.toString() +  "Walking(107): " + _walking.toString() + "Runnig(108): " + _running.toString());
  }

  void deleteActivityIdentificationUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (requestCode != null) {
      try {
        await activityIdentificationService.deleteActivityIdentificationUpdates(requestCode);
        requestCode = null;
        print("deleteActivityIdentificationUpdates + Deleted Activity Identification Updates successfully.");
      } catch (e) {
        prefs.setString("deleteActivityIdentificationUpdates", e.toString());
      }
    } else {
      print("deleteActivityIdentificationUpdates + Create Activity Identification Updates first.");
    }
    if(requestCode == null){
      prefs.setString("deleteActivityIdentificationUpdates", "Deleted Activity Identification Updates successfully. Create Activity Identification Updates first. ");
    }else{
      prefs.setString("deleteActivityIdentificationUpdates", "Create Activity Identification Updates first.");
    }
  }

  void setChange(int activity, int possibility) {
    switch (activity) {
      case ActivityIdentificationData.VEHICLE:
        _vehicle = possibility;
        break;
      case ActivityIdentificationData.BIKE:
        _bike = possibility;
        break;
      case ActivityIdentificationData.FOOT:
        _foot = possibility;
        break;
      case ActivityIdentificationData.STILL:
        _still = possibility;
        break;
      case ActivityIdentificationData.OTHERS:
        _others = possibility;
        break;
      case ActivityIdentificationData.TILTING:
        _tilting = possibility;
        break;
      case ActivityIdentificationData.WALKING:
        _walking = possibility;
        break;
      case ActivityIdentificationData.RUNNING:
        _running = possibility;
        break;
      default:
        break;
    }
  }
}