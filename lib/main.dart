import 'package:flutter/material.dart';

import 'Root.dart';
import 'Theme/Color.dart';
import 'welcome/welcomescreen.dart';

void main(){
  runApp(MainPage());
}

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "RalewatMedium",
          primaryColor: primaryColor,
          primaryIconTheme: IconThemeData(
              color: Colors.white
          ),
          primarySwatch: Colors.red, //cursor color
          primaryTextTheme: TextTheme(
            title: TextStyle(
                color: Colors.white
            ),

          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: primaryColor
          )
      ),
      title: "TheRedshank",
      home: Root(),

      debugShowCheckedModeBanner: false,
     /* routes: <String, WidgetBuilder>{'/root': (context) => Root()},*/
    routes: {
      '/root': (context) {
        return Root();
      },

    }
    );
  }
}