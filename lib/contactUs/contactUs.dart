import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theredshank/Home/Home.dart';
import 'package:theredshank/Modal/Validation.dart';
import 'package:theredshank/PageHeader.dart';
import 'package:theredshank/Theme/Loader.dart';
import 'package:theredshank/Url/Urlconnection.dart';
import 'package:theredshank/welcome/welcomescreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../CustomButton.dart';
import '../FormInputDecoration.dart';
import 'package:http/http.dart'as http;

class contactUs extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Contact();
  }
}
class Contact extends State {
  bool loader = false;
  bool _autoValid = false;
  final _formKey = GlobalKey<FormState>();
  bool checkboxValue = false;
  TextEditingController emailCtrl, usernameCtrl,messageCtrl;
  FocusNode email,name,messagebox;
  @override
  void initState() {
    super.initState();



    _autoValid = false;
    loader = false;

    emailCtrl = TextEditingController();
    messageCtrl=TextEditingController();
    usernameCtrl = TextEditingController();


    email = FocusNode();
    name=FocusNode();
    messagebox=FocusNode();


  }
  @override
  void dispose() {
    super.dispose();


    email?.unfocus();
    messagebox?.unfocus();
    name?.unfocus();

    emailCtrl?.dispose();
    messageCtrl?.dispose();
    usernameCtrl?.dispose();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

        backgroundColor: Colors.white,
        body: SafeArea(child: Builder(builder: (context) {
          return Stack(
            children: <Widget>[
              ContactUsForm(context),
              loader ? LoaderWidget() : Container()
            ],
          );
        })));
  }

  Widget ContactUsForm(BuildContext context){
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidate: _autoValid,
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              PageHeader(
                title: 'Contact us',

              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                focusNode: email,
                textInputAction: TextInputAction.next,
                style: FormInputDecoration.CustomTextStyle(),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.none,
                decoration:
                FormInputDecoration.FormInputDesign(name: "Email Address"),
                onFieldSubmitted: (node) {
                  email.unfocus();
                 // FocusScope.of(context).requestFocus(password);
                },

                validator: (value) => CheckFieldValidation(
                    val: value,
                    password: null,
                    fieldName: "Email",
                    fieldType: VALIDATION_TYPE.EMAIL),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: usernameCtrl,
                keyboardType: TextInputType.text,
                focusNode: name,
                textInputAction: TextInputAction.next,
                style: FormInputDecoration.CustomTextStyle(),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.none,
                decoration:
                FormInputDecoration.FormInputDesign(name: "Name"),
                onFieldSubmitted: (node) {
                  name.unfocus();
                  // FocusScope.of(context).requestFocus(password);
                },

                validator: (value) => CheckFieldValidation(
                    val: value,
                    password: null,
                    fieldName: "Name",
                    fieldType: VALIDATION_TYPE.TEXT),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: messageCtrl,
                keyboardType: TextInputType.text,
                focusNode: messagebox,
                textInputAction: TextInputAction.next,
                style: FormInputDecoration.CustomTextStyle(),
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.none,
                decoration:
                FormInputDecoration.FormInputDesign(name: "Message"),
                onFieldSubmitted: (node) {
                  messagebox.unfocus();
                  // FocusScope.of(context).requestFocus(password);
                },

                validator: (value) => CheckFieldValidation(
                    val: value,
                    password: null,
                    fieldName: "Message",
                    ),
              ),
              SizedBox(
                height: 40.0,

              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[
                        Text("subscribe to our channels below", style: TextStyle(fontSize: 14.0),),

                        InkWell(
                            child: new Text("www.theredshank.com",
                              style: TextStyle(color: Colors.red.shade800),),
                            onTap: () => launch('https://www.theredshank.com/')

                        ),
                        InkWell(
                            child: new Text("www.fishncollect.com",
                              style: TextStyle(color: Colors.red.shade800),),
                            onTap: () => launch('https://www.fishncollect.com/')

                        ),InkWell(
                            child: new Text("Facebook.com/theredshankuk",
                              style: TextStyle(color: Colors.red.shade800),),
                            onTap: () => launch('https://Facebook.com/theredshankuk/')

                        ),
                        InkWell(
                            child: new Text("Instagram.com/theredshankuk",
                              style: TextStyle(color: Colors.red.shade800),),
                            onTap: () => launch('https://Instagram.com/theredshankuk/')

                        ),
                        InkWell(
                            child: new Text("Twitter.com/theredshankuk",
                              style: TextStyle(color: Colors.red.shade800),),
                            onTap: () => launch('https://Twitter.com/theredshankuk/')

                        )
                      ],
                    ),

                  ],
                ),
              ),
              /*CheckboxListTile(
                value: checkboxValue,
                onChanged: (val) {
                  if (checkboxValue == false) {
                    setState(() {
                      checkboxValue = true;
                    });
                  } else if (checkboxValue == true) {
                    setState(() {
                      checkboxValue = false;
                    });
                  }
                },
               *//* subtitle: !checkboxValue
                    ? Text(
                  '',
                  style: TextStyle(color: Colors.red.shade800),
                )
                    : null,*//*
               subtitle: checkboxValue?
               Container(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[

                     Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                       children: <Widget>[

                         InkWell(
                             child: new Text("www.theredshank.com",
                               style: TextStyle(color: Colors.red.shade800),),
                             onTap: () => launch('https://www.theredshank.com/')

                         ),
                         InkWell(
                             child: new Text("www.fishcollect.com",
                               style: TextStyle(color: Colors.red.shade800),),
                             onTap: () => launch('https://www.fishcollect.com/')

                         ),InkWell(
                             child: new Text("Facebook.com/theredshankuk",
                               style: TextStyle(color: Colors.red.shade800),),
                             onTap: () => launch('https://Facebook.com/theredshankuk/')

                         ),
                         InkWell(
                             child: new Text("Instagram.com/theredshankuk",
                               style: TextStyle(color: Colors.red.shade800),),
                             onTap: () => launch('https://Instagram.com/theredshankuk/')

                         ),
                         InkWell(
                             child: new Text("Twitter.com/theredshankuk",
                               style: TextStyle(color: Colors.red.shade800),),
                             onTap: () => launch('https://Twitter.com/theredshankuk/')

                         )
                       ],
                     ),

                   ],
                 ),
               ):null,
               *//*InkWell(
                   child: new Text("www.theredshank.com",
                     style: TextStyle(color: Colors.red.shade800),),
                   onTap: () => launch('https://www.theredshank.com/privacy-policy/')

               ):null,*//*

                title: new Text(
                  "Subscribe to our channel.",
                  style: TextStyle(fontSize: 14.0),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.red.shade800,

              ),*/
              SizedBox(
                height: 20.0,

              ),
              CustomButton(
                text: "Submit",
                color: Colors.red.shade800,

                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(checkboxValue.toString());
                    Submitdata();
                  }
                },
              ),
              SizedBox(
                height: 20.0,

              ),
            ],
          ),
        ),
      ),
    );
  }
  Future Submitdata() async{
    email.unfocus();

    name.unfocus();
    messagebox.unfocus();
    String getemail = emailCtrl.value.text;

    String getname = usernameCtrl.value.text;
    String getMessage = messageCtrl.value.text;
    int checkedValue;
    var url = UrlCollection.contact_us;
    if(checkboxValue==false){
      checkedValue==0;

    }
    else{
      checkedValue==1;
    }
    // Showing CircularProgressIndicator.
    setState(() {
      loader = true;
    });

    // Getting value from Controller



    // SERVER API URL
    print(checkboxValue.toString());

    // Store all data with Param Name.
    var data = {'name': getname,'email':getemail,'message':getMessage };

    // Starting Web API Call.
    var response = await http.post(url, body: (data));
    //  String jsonsDataString = response.body.toString();
    // Getting Server response into variable.
    var message = json.decode(response.body);

    // If Web call Success than Hide the CircularProgressIndicator.
    if(response.statusCode == 200){
      setState(() {
        loader = false;
        _formKey.currentState?.reset();
        // widget.firstScreenFormKey?.currentState?.reset();
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(message),
          actions: <Widget>[
            FlatButton(

              child: new Text("OK"),
              onPressed: () {
                if(message=="Thank You For Your Valueable Feedback"){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>contactUs()));
                }
                //Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );

  }
}