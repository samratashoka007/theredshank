import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theredshank/Login/Login.dart';
import 'package:theredshank/Signup/Signup.dart';
import 'package:theredshank/contactUs/contactUs.dart';


import '../CustomButton.dart';
class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Home();
  }
}

class Home extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(

        children: <Widget>[

          Expanded(
            child: Image.asset(
              "images/splash.jpg",
             fit: BoxFit.fill,

            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  ("the Redshank"),
                  style: TextStyle(fontSize: 30.0,
                  color: Colors.white),
                ),
                SizedBox(
                  height: 15.0,
                ),

                CustomButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  text: "Sign Up",
                  color: Colors.red.shade800,
                  width: 250.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  text: "Log In",
                  color: Colors.red.shade800,
                  width: 250.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => contactUs()));
                  },
                  text: "Contact us",
                  color: Colors.red.shade800,
                  width: 250.0,
                ),
                SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
