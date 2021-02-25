import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:huawei/locationkit/LocationPage.dart';
import 'package:huawei/mapkit/MapPage.dart';
import 'package:huawei/scankit/ScanQRPage.dart';
import 'package:huawei/safetydetect/SafetyDetectPage.dart';

class Dashboard extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{
  TabController controller;

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    color: Color(getColorHexFromStr('#FDD148')),
                  ),
                  Positioned(
                    bottom: 50.0,
                    right: 100.0,
                    child: Container(
                      height: 400.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200.0),
                          color: Color(getColorHexFromStr('#FEE16D'))
                              .withOpacity(0.4)),
                    ),
                  ),
                  Positioned(
                    bottom: 100.0,
                    left: 150.0,
                    child: Container(
                        height: 300.0,
                        width: 300.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150.0),
                            color: Color(getColorHexFromStr('#FEE16D'))
                                .withOpacity(0.5))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 15.0),
                          Container(
                            alignment: Alignment.topLeft,
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                    width: 2.0),
                                image: DecorationImage(
                                    image: AssetImage('assets/huawei_logo.png'), fit: BoxFit.cover)),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 120.0),
                          Container( //Change To SignOut
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(Icons.logout),
                              onPressed: () {},
                              color: Colors.white,
                              iconSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 15.0),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          'Wellcome !',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text(
                          'This is an example about how to use HMS Kits with Flutter.',
                          style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 25.0),
                      SizedBox(height: 10.0)
                    ],
                  )
                ],
              ),
              SizedBox(height: 10.0),
              itemCard('Map Kit', 'assets/mapkit.png', 'Map Kit Flutter Example'),
              itemCard('Location Kit', 'assets/locationkit.png', 'Location Kit Flutter Example'),
              itemCard('Scan Kit', 'assets/scankit.png', 'Scan Kit Flutter Example'),
              itemCard('Safety Detect Kit', 'assets/safety.png', 'Safety Detect Kit Example')
            ],
          )
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.yellow,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home, color: Colors.yellow))
          ],
        ),
      ),
    );
  }

  Widget itemCard(String title, String imgPath, String desc) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Container(

        height: 150.0,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath), fit: BoxFit.fitHeight)),
            ),
            SizedBox(width: 44.0),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(height: 55.0),
                    Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Colors.grey,
                        fontSize: 12.0),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  height: 40,
                  width: 100,
                    child: RaisedButton(
                      color: Color(0xFFF9C335),
                      highlightColor: Color(0xFFF9C335),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      onPressed: (){
                        if(title == "Map Kit"){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => MapPage()));
                        }else if(title == "Location Kit"){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => LocationPage()));
                        }else if(title == "Scan Kit"){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ScanQRPage()));
                        }else if(title == "Safety Detect Kit"){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => SafetyDetectPage()));
                        }else{
                          print("WTFFF???");
                        }

                      },
                      child: Text(
                        'Go >',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
              ],
            )
          ],
        ),
      ),
    );
  }
}