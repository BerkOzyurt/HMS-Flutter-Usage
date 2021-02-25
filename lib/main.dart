import 'package:flutter/material.dart';
import 'package:huawei/Dashboard.dart';
import 'package:huawei/auth/AuthManager.dart';
import 'package:huawei/auth/LoginPage.dart';
import 'package:huawei/auth/RegisterPage.dart';
import 'package:huawei/locationkit/ActivityConversion.dart';
import 'package:huawei/locationkit/LocationPage.dart';
import 'package:huawei/mapkit/MapPage.dart';
import 'package:huawei/safetydetect/SafetyDetectPage.dart';
import 'package:huawei/scankit/ScanQRPage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'auth/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  final AuthManager authManager = new AuthManager();
  PermissionStatus _status;

  @override
  void initState() {
    authManager.signOut();
    _requestPerms();
  }

  void _requestPerms() async {
    Map<Permission, PermissionStatus> statuses = await
    [
      Permission.locationWhenInUse,
      Permission.locationAlways
    ].request();

    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      _updateStatus(PermissionStatus.granted);
      setState(() {});
      //openAppSettings();
    }
  }

  void _updateStatus(PermissionStatus value) {
    setState(() {
      _status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huawei Auth Service',
      theme: ThemeData(),
      darkTheme:ThemeData.dark(),
      home: HomePage(),
    );
  }

}
