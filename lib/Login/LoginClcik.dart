import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:theredshank/Theme/Loader.dart';
import 'package:theredshank/Url/Urlconnection.dart';
import 'package:theredshank/welcome/welcomescreen.dart';

class LoginClick {
  final String email;
  final String password;

  Widget launchWidget = LoaderWidget();
  LoginClick(this.email,this.password);
  bool loader = false;


  Future getData(BuildContext context) async {

    bool isSuccessed;
    String userId;
    var data = { 'email': email, 'password' : password};
    // Starting Web API Call.
    var response = await http.post(UrlCollection.login_url,body: data);
     var data1 = jsonDecode(response.body);
    print(data1.toString());
    if(data1=="Invalid email and password!"){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text(data1),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                },
              ),
            ],
          );
        },
      );
    }
    else{
      if (response.statusCode == 200) {
        Map<String, dynamic> user = jsonDecode(response.body) as Map;
        isSuccessed = user['logged_in'];
        userId = user['u_id'];
        if (isSuccessed) {
          saveBooleanValue('logged_in', isSuccessed);
          saveStringValue('email', email);
          saveStringValue('password', password);
          saveStringValue('u_id', userId);


          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Welcome()),
              ModalRoute.withName('/root'));
        }
      }
      else{
        Fluttertoast.showToast(msg: "Please Check Internet Connection");
      }
    }




    return isSuccessed;
  }

  Future<bool> saveBooleanValue(String key ,bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  Future<bool> saveStringValue(String key ,String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }
}