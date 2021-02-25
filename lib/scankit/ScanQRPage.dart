import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_scan/HmsScanLibrary.dart';
import 'package:huawei_scan/hmsScanPermissions/HmsScanPermissions.dart';

class ScanQRPage extends StatefulWidget {
  @override
  _ScanQRPageState createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {

  TextEditingController nameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();

  BuildBitmapRequest bitmapRequest;
  int scanTypeValueFromDropDown = HmsScanTypes.QRCode;
  String QRContent = "";
  Image _image = new Image.asset('barcode.png');
  String QRCodeResultText = "Name : \nLast Name : \nAge : ";

  @override
  void initState() {
    super.initState();
    permissionRequest();
  }

  void permissionRequest() async {
    bool permissionResult =
    await HmsScanPermissions.hasCameraAndStoragePermission();
    if (permissionResult == false) {
      await HmsScanPermissions.requestCameraAndStoragePermissions();
    }
  }

  void startScan() async {
    DefaultViewRequest request = new DefaultViewRequest(scanType: HmsScanTypes.AllScanType);
    ScanResponse response = await HmsScanUtils.startDefaultView(request);
    String result = response.originalValue;
    debugPrint("Detail Scan Result: " + result.toString());

    setState(() {
      if (result != null) {
        print("MyScanResult : " + result);
        QRCodeResultText = result;
      } else {
        print("MyScanResult : NULL" + result);
        QRCodeResultText = "NULL";
      }
    });
  }


  BuildBitmapRequest getContentDetail(String barcodeContent) {

      bitmapRequest = BuildBitmapRequest(content: barcodeContent);
      bitmapRequest.type = scanTypeValueFromDropDown;

      String name = nameController.text;
      String lastName = lastNameController.text;
      String age = ageController.text;

      QRContent = QRContent + name + " ";
      QRContent = QRContent + lastName + " ";
      QRContent = QRContent + age;
      bitmapRequest.content = QRContent;

      return bitmapRequest;
  }

  generateBarcode() async {
    bitmapRequest = getContentDetail(QRContent);
    if (bitmapRequest == null) {
      print("Check bitmalRequest object.");
      _image = null;
    } else {
      Image image;
      try {
        image = await HmsScanUtils.buildBitmap(bitmapRequest);
      } on PlatformException catch (err) {
        debugPrint(err.details);
      }
      _image = image;
      print("GeneratedImage : " + _image.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final startQRScanCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: const Text('Scan Kit'),
            subtitle: Text(
              "QR Code Scan Result",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                QRCodeResultText,
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
                  startScan();
                },
                child: const Text('Start Scan QR Code'),
              ),
            ],
          ),
        ],
      ),
    );

    final nameTextField = Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: SizedBox(
            height: 30,
            width: 300,
            child: TextField(
              controller: nameController,
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
        ),
      ),
    );

    final lastNameTextField = Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: SizedBox(
          height: 30,
          width: 300,
          child: TextField(
            controller: lastNameController,
            obscureText: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Last Name',
            ),
          ),
        ),
      ),
    );

    final ageTextField = Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: SizedBox(
          height: 30,
          width: 300,
          child: TextField(
            controller: ageController,
            obscureText: false,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Age',
            ),
          ),
        ),
      ),
    );


    final generateQRCodeCardView = Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: const Text('Scan Kit'),
            subtitle: Text(
              "Generate QR Code",
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          nameTextField,
          lastNameTextField,
          ageTextField,
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              FlatButton(
                textColor: const Color(0xFFF9C335),
                onPressed: () {
                  generateBarcode();
                },
                child: const Text('Generate'),
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
          title: const Text('Scan Kit', style: TextStyle(
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
                        startQRScanCardView,
                        generateQRCodeCardView,
                        _image != null
                            ? _image
                            :Image.asset(
                          "assets/barcode.png",
                        ),
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