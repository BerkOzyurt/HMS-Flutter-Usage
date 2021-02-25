import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:huawei_safetydetect/huawei_safetydetect.dart';
import 'package:prefs/prefs.dart';

class SafetyDetectService{

  String appID = "XXX";

  void checkSysIntegrity() async {
    SharedPreferences checkSysIntegrityPrefs = await SharedPreferences.getInstance();

    Random secureRandom = Random.secure();
    List randomIntegers = List<int>();
    for(var i = 0; i < 24; i++) {
      randomIntegers.add(secureRandom.nextInt(255));
    }
    Uint8List nonce = Uint8List.fromList(randomIntegers);
    try {
      String sysIntegrityResult = await SafetyDetect.sysIntegrity(nonce, appID);
      List<String> jwsSplit = sysIntegrityResult.split(".");
      String decodedText = utf8.decode(base64Url.decode(jwsSplit[1]));
      Map<String, dynamic> jsonMap = json.decode(decodedText);

      String apkDigestSha256 = jsonMap['apkDigestSha256'];
      String apkPackageName = jsonMap['apkPackageName'];
      bool basicIntegrity = jsonMap['basicIntegrity'];
      String jsonNonce = jsonMap['nonce'];
      int timestampMs = jsonMap['timestampMs'];

      print("SysIntegrityCheck result is: $decodedText");

      checkSysIntegrityPrefs.setString("checkSysIntegrityPrefs",
              "apkDigestSha256 : " + apkDigestSha256.toString() + "\n \n" +
              "apkPackageName : " + apkPackageName.toString() + "\n \n" +
              "basicIntegrity : " + basicIntegrity.toString() + "\n \n" +
              "nonce : " + jsonNonce.toString() + "\n \n" +
              "timestampMs : " + timestampMs.toString());

    } on PlatformException catch (e) {
      print("Error occurred while getting SysIntegrityResult. Error is : ${e.toString()}");
    }
  }

  void getMaliciousAppsList() async {
    SharedPreferences maliciousAppsListPrefs = await SharedPreferences.getInstance();

    List<MaliciousAppData> maliciousApps = List();
    maliciousApps = await SafetyDetect.getMaliciousAppsList();
    String maliciousAppsResult = maliciousApps.length == 0
        ? "No malicious apps detected."
        : "Malicious Apps:" + maliciousApps.toString();
    print(maliciousAppsResult);

    maliciousAppsListPrefs.setString("maliciousAppsListPrefs", maliciousAppsResult);
  }

  void urlCheck(String _url) async {
    SharedPreferences urlCheckPrefs = await SharedPreferences.getInstance();

    String concernedUrl = _url;
    String urlCheckResult = "";

    List<UrlThreatType> urlThreatTypes = [
      UrlThreatType.malware,
      UrlThreatType.phishing];

    List<UrlCheckThreat> urlCheckResults = await SafetyDetect.urlCheck(concernedUrl , appID, urlThreatTypes);
    if (urlCheckResults.length == 0) {
      urlCheckResult = "No threat is detected for this URL: $concernedUrl";
    } else {
      urlCheckResults.forEach((element) {
        urlCheckResult += "${element.getUrlThreatType} is detected on this URL: $concernedUrl";
      });
    }
    print(urlCheckResult);
    urlCheckPrefs.setString("urlCheckPrefs", urlCheckResult);
  }

  void userDetection() async {
    SharedPreferences userDetectionPrefs = await SharedPreferences.getInstance();

    try {
      String token = await SafetyDetect.userDetection(appID);
      print("User verification succeeded, user token: $token");
      userDetectionPrefs.setString("userDetectionPrefs", "Verification Succeeded. User Token : " + token);
    } on PlatformException catch (e) {
      print("Error occurred: ${e.code}:" + SafetyDetectStatusCodes[e.code]);
      userDetectionPrefs.setString("userDetectionPrefs", "Verification Couldn't Succeeded. " + e.message);
    }
  }
}
