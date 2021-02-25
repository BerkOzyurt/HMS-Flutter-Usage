import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:huawei/auth/AuthManager.dart';
import 'package:huawei/utils/DelayedAnimation.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin{
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  bool _visible = false;
  String buttonText = "Send Verify Code";

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController verifyCodeController = new TextEditingController();

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
    super.initState();
  }

  void _toggleVerifyCode() {
    setState(() {
      _visible = true;
      buttonText = "Send Again";
      final AuthManager authManager = new AuthManager();
      authManager.sendRegisterVerificationCode(emailController.text);
    });
  }

  void _toggleRegister() {
    setState(() {
      _visible = true;
      buttonText = "Send Again";
      final AuthManager authManager = new AuthManager();
      authManager.registerWithEmail(emailController.text, verifyCodeController.text, passwordController.text, this.context);
    });
  }

  @override
  Widget build(BuildContext context) {

    final color = Color(0xFFF4EADE);
    _scale = 1 - _controller.value;

    final logo = AvatarGlow(
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
            backgroundColor: Color(0xFFF4EADE),
            backgroundImage: AssetImage('assets/huawei_logo.png'),
            radius: 50.0,
          )
      ),
    );

    final title = DelayedAnimation(
      child: Text(
        "Register",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35.0,
            color: Color(0xFF2F496E)),
      ),
      delay: delayedAmount + 500,
    );

    final email = DelayedAnimation(
      delay: delayedAmount + 500,
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: '* Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Color(0xFF2F496E),
            ),
          ),
        ),
      ),
    );

    final password = DelayedAnimation(
      delay: delayedAmount + 1000,
      child: TextFormField(
        controller: passwordController,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: '* Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Color(0xFF2F496E),
            ),
          ),
        ),
      ),
    );

    final sendVerifyCodeButton = RaisedButton(
      color: Color(0xFF2F496E),
      highlightColor: Color(0xFF2F496E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      onPressed: _toggleVerifyCode,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
      ),
    );

    final verifyCode = DelayedAnimation(
      delay: 500,
      child: TextFormField(
        controller: verifyCodeController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: '* Verify Code',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.0),
            borderSide: BorderSide(
              color: Color(0xFF2F496E),
            ),
          ),
        ),
      ),
    );

    final registerButton = RaisedButton(
      color: Color(0xFF2F496E),
      highlightColor: Color(0xFF2F496E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      onPressed: _toggleRegister,
      child: Text(
        'Register',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.normal,
          color: color,
        ),
      ),
    );

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
                  title,
                  logo,
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: email,
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: password,
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: DelayedAnimation(
                        delay: delayedAmount + 1500,
                        child: sendVerifyCodeButton
                    ),
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                      height: 50,
                      width: 300,
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _visible,
                        child: DelayedAnimation(
                            delay: delayedAmount + 1500,
                            child: verifyCode
                        ),
                      )
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                      height: 50,
                      width: 300,
                      child: Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: _visible,
                        child: DelayedAnimation(
                            delay: delayedAmount + 1500,
                            child: registerButton
                        ),
                      )
                  ),
                  SizedBox(height: 50.0,),
                ],
              ),
            ),
          ),
        ),
    );
  }
}