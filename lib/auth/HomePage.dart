import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:agconnect_core/agconnect_core.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:huawei/auth/AuthManager.dart';
import 'package:huawei/auth/LoginPage.dart';
import 'package:huawei/auth/RegisterPage.dart';

import '../utils/DelayedAnimation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  final AuthManager authManager = new AuthManager();


  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });

    AGCApp.instance.setClientId('544188200009073856');
    AGCApp.instance.setClientSecret('BA65BD56ED9A5CC7BB7FDC71E5C644C54E1BFF751249111C42A50068667FB0BB');
    AGCApp.instance.setApiKey('CgB6e3x98fBHd7TathWIv46cPkrWRk3l7S2Une71GkzrBw5LR0nw4HF0mUfL4ND9AEfHMHQnHfekrxGfR07Qw/MX');

    authManager.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(0xFFF4EADE);
    _scale = 1 - _controller.value;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFF4EADE),
          body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.all(20.0),
                    child: new Container()
                ),
                AvatarGlow(
                  endRadius: 90,
                  duration: Duration(seconds: 2),
                  glowColor: Color(0xFF2F496E),
                  repeat: true,
                  repeatPauseDuration: Duration(seconds: 2),
                  startDelay: Duration(seconds: 1),
                  child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: color,
                        backgroundImage: AssetImage('assets/huawei_logo.png'),
                        radius: 50.0,
                      )
                  ),
                ),
                DelayedAnimation(
                  child: Text(
                    "Where Am I ?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                        color: Color(0xFF2F496E)),
                  ),
                  delay: delayedAmount + 1000,
                ),
                DelayedAnimation(
                  child: Text(
                    "Wellcome",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Color(0xFF2F496E)),
                  ),
                  delay: delayedAmount + 2000,
                ),
                SizedBox(
                  height: 30.0,
                ),
                DelayedAnimation(
                  child: Text(
                    "Your New Personal",
                    style: TextStyle(fontSize: 20.0, color: Color(0xFF2F496E)),
                  ),
                  delay: delayedAmount + 3000,
                ),
                DelayedAnimation(
                  child: Text(
                    "Journaling  companion",
                    style: TextStyle(fontSize: 20.0, color: Color(0xFF2F496E)),
                  ),
                  delay: delayedAmount + 3000,
                ),
                SizedBox(height: 50.0,),
                SizedBox(
                  height: 60,
                  width: 270,
                  child: DelayedAnimation(
                    child: RaisedButton(
                      color: Color(0xFF2F496E),
                      highlightColor: Color(0xFF2F496E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      onPressed: (){
                        _goLoginPage();
                      },
                      child: Text(
                        'Sign-in',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    delay: delayedAmount + 4000,
                  ),
                ),

                SizedBox(height: 50.0,),
                DelayedAnimation(
                    delay: delayedAmount + 5000,
                    child: InkWell(
                      onTap: () {
                        _goRegisterPage();
                      },
                      child: Text(
                        "Let's Register!",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F496E)),
                      ),
                    )
                ),
                SizedBox(height: 50.0,),
              ],
            ),
          ),

          )
      ),
    );
  }

  _goRegisterPage(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  _goLoginPage(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}