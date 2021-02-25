import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei/safetydetect/SafetyDetectService.dart';
import 'package:huawei_safetydetect/huawei_safetydetect.dart';
import 'package:prefs/prefs.dart';

class SafetyDetectPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _SafetyDetectPageState createState() => new _SafetyDetectPageState();
}

class _SafetyDetectPageState extends State<SafetyDetectPage> with SingleTickerProviderStateMixin{

  final SafetyDetectService mySafeDetectService = new SafetyDetectService();

  String appID = "XXX";

  String SysIntegrityResult = "Click 'Check' Button";
  String MaliciousAppsListResult = "Click 'Get Malicious Apps List' Button";
  String URLCheckResult = "Click 'Check URL' Button";
  String UsertDetectResultText = "Click 'Check' Button";

  TextEditingController urlTextFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _toggleSysIntegrity() async{
    mySafeDetectService.checkSysIntegrity();

    SharedPreferences checkSysIntegrityPrefs = await SharedPreferences.getInstance();
    String checkSysIntegrityPrefsResult = checkSysIntegrityPrefs.getString("checkSysIntegrityPrefs");
    print("setSysIntegrityData in Activity : " + checkSysIntegrityPrefsResult);

    setState(() {
      SysIntegrityResult = checkSysIntegrityPrefsResult;
    });
  }

  void _toggleMaliciousApps() async{
    mySafeDetectService.getMaliciousAppsList();

    SharedPreferences maliciousAppsListPrefs = await SharedPreferences.getInstance();
    String maliciousAppsResult = maliciousAppsListPrefs.getString("maliciousAppsListPrefs");
    print("setMaliciousAppsData in Activity : " + maliciousAppsResult);

    setState(() {
      MaliciousAppsListResult = maliciousAppsResult;
    });
  }

  void _toggleURLCheck() async{
    mySafeDetectService.urlCheck(urlTextFieldController.text);

    SharedPreferences urlCheckPrefs = await SharedPreferences.getInstance();
    String URLCheckResults = urlCheckPrefs.getString("urlCheckPrefs");
    print("setURLCheckData in Activity : " + URLCheckResults);

    setState(() {
      URLCheckResult = URLCheckResults;
    });
  }

  void userDetection() async {
    try {
      String token = await SafetyDetect.userDetection(appID);
      print("User verification succeeded, user token: $token");
      setState(() {
        UsertDetectResultText = "Verification Succeeded. User Token : " + token;
      });
    } on PlatformException catch (e) {
      print("Error occurred: ${e.code}:" + SafetyDetectStatusCodes[e.code]);
      setState(() {
        UsertDetectResultText = "Verification Couldn't Succeeded. " + e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final SysIntegrityCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.security),
            title: const Text('SysIntegrity'),
            subtitle: Text(
              "Safety Detect SysIntegrity",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                SysIntegrityResult,
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
                  _toggleSysIntegrity();
                },
                child: const Text('Check'),
              ),
            ],
          ),
        ],
      ),
    );

    final AppsCheckCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.security),
            title: const Text('AppsCheck'),
            subtitle: Text(
              "Malicious Apps List",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                MaliciousAppsListResult,
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
                  _toggleMaliciousApps();
                },
                child: const Text('Get Malicious Apps List'),
              ),
            ],
          ),
        ],
      ),
    );

    final urlTextField = Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: SizedBox(
          height: 30,
          width: 300,
          child: TextField(
            controller: urlTextFieldController,
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'URL',
            ),
          ),
        ),
      ),
    );

    final URLCheckCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.security),
            title: const Text('URL Check'),
            subtitle: Text(
              "Safety Detect URL Check",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                URLCheckResult,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          urlTextField,
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  _toggleURLCheck();
                },
                child: const Text('Check URL'),
              ),
            ],
          ),
        ],
      ),
    );

    final userDetectCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.security),
            title: const Text('User Detect'),
            subtitle: Text(
              "Safety Detect User Detect",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                UsertDetectResultText,
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
                  userDetection();
                },
                child: const Text('Check'),
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
          title: const Text('Safety Detect Kit', style: TextStyle(
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
                        SysIntegrityCardView,
                        AppsCheckCardView,
                        URLCheckCardView,
                        userDetectCardView
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
