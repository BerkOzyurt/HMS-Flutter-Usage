import 'dart:async';

import 'package:flutter/material.dart';
import 'package:huawei/locationkit/ActivityConversion.dart';
import 'package:huawei/locationkit/MyActivityIdentService.dart';
import 'package:huawei/locationkit/MyFusedLocationService.dart';
import 'package:huawei/locationkit/MyGeofenceService.dart';
import 'package:prefs/prefs.dart';

class LocationPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LocationPageState createState() => new _LocationPageState();
}

class _LocationPageState extends State<LocationPage> with SingleTickerProviderStateMixin{

  final MyFusedLocationService myFusedLocationService = new MyFusedLocationService();
  final MyGeofenceService myGeofenceService = new MyGeofenceService();
  final MyActivityIdentService myActivityIdentService = new MyActivityIdentService();

  String fusedLocationDescription = 'HMS Location Kit Flutter Usage';
  String fusedLocationSubTitle = "Select an Fused Location Action";
  String activityIdentificationDescription = 'HMS Location Kit Flutter Usage';
  String activityIdentificationSubTitle = "Select an Activity Identification Action";
  String geofenceServiceDescription = 'HMS Location Kit Flutter Usage';
  String geofenceServiceSubTitle = "Select an Geofence Service Action";

  @override
  void initState() {
    myFusedLocationService.initFusedLocation();
    myGeofenceService.initGeofenceService();
    myActivityIdentService.initActivityIdentification();
    super.initState();
  }

  @override
  void dispose() {
  }

  //FusedLocation
  void _toggleLastLocation() async{
    setState(() {
      myFusedLocationService.getLastLocation();
      setLastLocationData();
    });
  }
  void setLastLocationData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCurrentLocation = prefs.getString("currentLocation");
    fusedLocationDescription = userCurrentLocation;
    fusedLocationSubTitle = "Last Location";
    print("LOCATION IN ACTIVITY : " + userCurrentLocation);
  }

  void _toggleAllInfo() async{
    setState(() {
      myFusedLocationService.getAllLocation();
      setAllInfoData();
    });
  }
  void setAllInfoData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String allLocationInfo = prefs.getString("allLocationInfo");
    fusedLocationDescription = allLocationInfo;
    fusedLocationSubTitle = "All Location Info";
    print("LOCATION IN ACTIVITY : " + allLocationInfo);
  }

  void _toggleLocationAvailability() async{
    setState(() {
      myFusedLocationService.getLocationAvailability();
      setLocationAvailabilityData();
    });
  }
  void setLocationAvailabilityData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationAvailability = prefs.getString("locationAvailability");
    fusedLocationDescription = locationAvailability;
    fusedLocationSubTitle = "Location Availability";
    print("Location Availability: " + locationAvailability);
  }

  //ActivityIdentification
  void _toogleCheckPermission() async{
    setState(() {
      myActivityIdentService.hasPermission();
      setActivityIdentificationPermissionStatus();
    });
  }
  void setActivityIdentificationPermissionStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String permissionResult = prefs.getString("permissionResult");
    activityIdentificationDescription = permissionResult;
    activityIdentificationSubTitle = "Permission Result";
    print("permissionResult: " + permissionResult);
  }

  void _toogleAIPermission() async{
    setState(() {
      myActivityIdentService.requestActivityRecognitionPermission();
      setAIPermissionStatus();
    });
  }
  void setAIPermissionStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String activityPermissionRequest = prefs.getString("requestActivityRecognitionPermission");
    activityIdentificationDescription = activityPermissionRequest;
    activityIdentificationSubTitle = "Request Activity Permission";
    print("requestActivityRecognitionPermission: " + activityPermissionRequest);
  }

  void _toogleCreateAIUpdates() async{
    setState(() {
      myActivityIdentService.createActivityIdentificationUpdates();
      setAIUpdatesStatus();
    });
  }
  void setAIUpdatesStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String AIUpdatesStatus = prefs.getString("createActivityIdentificationUpdates");
    activityIdentificationDescription = AIUpdatesStatus;
    activityIdentificationSubTitle = "Create Activity Identification";
    print("createActivityIdentificationUpdates: " + AIUpdatesStatus);
  }

  void _toogleDeleteAI() async{
    setState(() {
      myActivityIdentService.deleteActivityIdentificationUpdates();
      setAIDeleteStatus();
    });
  }
  void setAIDeleteStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String AIDeleteStatus = prefs.getString("deleteActivityIdentificationUpdates");
    activityIdentificationDescription = AIDeleteStatus;
    activityIdentificationSubTitle = "Delete Activity Identification";
    print("deleteActivityIdentificationUpdates: " + AIDeleteStatus);
  }

  //GeofenceService
  void _toogleAddGeofenceList()async{
    setState(() {
      myGeofenceService.addGeofence();
      setAddGeofenceStatus();
    });
  }
  void setAddGeofenceStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String AddGeofenceStatus = prefs.getString("addGeofence");
    geofenceServiceDescription = AddGeofenceStatus;
    geofenceServiceSubTitle = "Add Geofence";
    print("addGeofence: " + AddGeofenceStatus);
  }

  void _toogleCreateGeofenceList()async{
    setState(() {
      myGeofenceService.createGeofenceList();
      setCreateGeofenceStatus();
    });
  }
  void setCreateGeofenceStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String CreateGeofenceStatus = prefs.getString("createGeofenceList");
    geofenceServiceDescription = CreateGeofenceStatus;
    geofenceServiceSubTitle = "Create Geofence List";
    print("createGeofenceList: " + CreateGeofenceStatus);
  }

  void _toogleDeleteGeofenceList()async{
    setState(() {
      myGeofenceService.deleteGeofenceList();
      setDeleteGeofenceStatus();
    });
  }
  void setDeleteGeofenceStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String DeleteGeofenceStatus = prefs.getString("deleteGeofenceList");
    geofenceServiceDescription = DeleteGeofenceStatus;
    geofenceServiceSubTitle = "Delete Geofence List";
    print("deleteGeofenceList: " + DeleteGeofenceStatus);
  }

  @override
  Widget build(BuildContext context) {

    final fusedLocationCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: const Text('Fused Location'),
            subtitle: Text(
              fusedLocationSubTitle,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                fusedLocationDescription,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toggleLastLocation();
                },
                child: const Text('Last Location'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toggleAllInfo();
                },
                child: const Text('Full Info'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toggleLocationAvailability();
                },
                child: const Text('Availability'),
              ),
            ],
          ),
        ],
      ),
    );

    final geofenceServiceCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: const Text('Geofence Service'),
            subtitle: Text(
              geofenceServiceSubTitle,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                geofenceServiceDescription,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleAddGeofenceList();
                },
                child: const Text('Add Geofence'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleCreateGeofenceList();
                },
                child: const Text('Create Geofence List'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleDeleteGeofenceList();
                },
                child: const Text('Delete Geofence List'),
              ),
            ],
          ),
        ],
      ),
    );

    final activitiyIdentificationCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: const Text('Activity Identification Service'),
            subtitle: Text(
              activityIdentificationSubTitle,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                activityIdentificationDescription,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleCheckPermission();
                },
                child: const Text('Check Permission'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleAIPermission();
                },
                child: const Text('Request Activity Identification Permission'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleCreateAIUpdates();
                },
                child: const Text('Create Activity Identification'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toogleDeleteAI();
                },
                child: const Text('Delete Activity Identification'),
              ),
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ActivityConversion()),
                  );
                },
                child: const Text('Activity Conversion'),
              ),
            ],
          ),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Location Kit', style: TextStyle(
              color: Colors.white
          )),
          backgroundColor: Color(0xFFF9C335),
        ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                   Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 5.0),
                              fusedLocationCardView,
                              geofenceServiceCardView,
                              activitiyIdentificationCardView
                          ],
                       ),
                      ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}