import 'package:agconnect_auth/agconnect_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huawei/auth/HomePage.dart';
import 'package:huawei/auth/LoginPage.dart';

class AuthManager{

  void sendRegisterVerificationCode(String email) async{
    VerifyCodeSettings settings = VerifyCodeSettings(VerifyCodeAction.registerLogin, sendInterval: 30);
    EmailAuthProvider.requestVerifyCode(email, settings)
        .then((result){
      print("sendRegisterVerificationCode : " + result.validityPeriod);
    });
  }
  //1234qqqQ+A

  Future<void> _showMyDialog(BuildContext context, String dialogMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(dialogMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void registerWithEmail(String email, String verifyCode, String password, BuildContext context) async{
    EmailUser user = EmailUser(email, verifyCode, password: password);
    AGCAuth.instance.createEmailUser(user)
        .then((signInResult) {
      print("registerWithEmail : " + signInResult.user.email);
      signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    })
        .catchError((error) {
      print("Register Error " + error.toString());
      _showMyDialog(context, error.toString());
    });
  }

  void sendSigninVerificationCode(String email) async{
    VerifyCodeSettings settings = VerifyCodeSettings(VerifyCodeAction.registerLogin, sendInterval: 30);
    EmailAuthProvider.requestVerifyCode(email, settings)
        .then((result){
      print("sendSigninVerificationCode : " + result.validityPeriod);
    });
  }

  void loginWithEmail(String email, String verifyCode, String password) async{
    AGCAuthCredential credential = EmailAuthProvider.credentialWithVerifyCode(email, verifyCode, password: password);
    AGCAuth.instance.signIn(credential)
        .then((signInResult){
      AGCUser user = signInResult.user;
      print("loginWithEmail : " + user.displayName);

    })
        .catchError((error){
      print("Login Error " + error.toString());
    });
  }

  void sendResetPasswordVerificationCode(String email) async{
    VerifyCodeSettings settings = VerifyCodeSettings(VerifyCodeAction.resetPassword, sendInterval: 30);
    EmailAuthProvider.requestVerifyCode(email, settings)
        .then((result){
          print(result.validityPeriod);
    });
  }

  void resetPassword(String email, String newPassword, String verifyCode) async{
    AGCAuth.instance.resetPasswordWithEmail(email, newPassword, verifyCode)
        .then((value) {
          print("Password Reseted");
    })
        .catchError((error) {
          print("Password Reset Error " + error);
    });
  }

  void signOut() async{
    AGCAuth.instance.signOut().then((value) {
      print("SignInSuccess");
    }).catchError((error) => print("SignOut Error : " + error));
  }

  void getCurrentUser() async {
    AGCAuth.instance.currentUser.then((value) {
      print('current user = ${value?.uid} , ${value?.email} , ${value?.displayName} , ${value?.phone} , ${value?.photoUrl} ');
    });
  }

  void secondMethod(String sth){
    print("Second Method : " + sth);
  }

}