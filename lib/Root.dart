import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theredshank/welcome/welcomescreen.dart';



import 'Home/Home.dart';
import 'Theme/Loader.dart';


class Root extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RootState();
  }
}

class RootState extends State<Root> {
 //Widget launchWidget = LoaderWidget();
  startTime() async {
    var _duration = new Duration(seconds: 5);

    // return new Timer(_duration, navigationPage);
  }

 @override
 void initState() {
   super.initState();
   //  startTime();
   Route route;

   Future.delayed(Duration(seconds: 3), () {
     getBooleanValue('logged_in').then((value) {
       if (value) {
//        route = MaterialPageRoute(builder: (context) => Home());
         route =  MaterialPageRoute(builder: (context) => Welcome());
         Navigator.pushReplacement(context, route);
       } else {
         route = MaterialPageRoute(builder: (context) => HomeScreen());
         Navigator.pushReplacement(context, route);
        // launchWidget=HomeScreen();
       }
     });
   });
 }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('images/splash.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            /*child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),*/
          ),
         /* new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset('images/assets/logo.png'),
            ],
          ),*/
        ],
      ),
    );

  }
 Future<bool> getBooleanValue(String key) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   return prefs.getBool(key) ?? false;
 }
}
