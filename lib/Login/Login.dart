import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dart:io';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:theredshank/Modal/Validation.dart';
import 'package:theredshank/Theme/Loader.dart';

import '../CustomButton.dart';
import '../FormInputDecoration.dart';
import '../PageHeader.dart';
import 'LoginClcik.dart';



class Login extends StatefulWidget {
  VoidCallback UpdateLoginState;

  Login({Key key, this.UpdateLoginState});



  createState() => LoginState();
}

class LoginState extends State<Login> {

  FocusNode email;
  FocusNode password;
  TextEditingController emailCtrl, passwordCtrl;
  bool _autoValid = false;
  bool loader = false;
  final _loginForm = GlobalKey<FormState>();

  @override
  void initState() {
    loader = false;

    super.initState();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    email = FocusNode();
    password = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(child: Builder(
        builder: (context) {
          return Stack(
            children: <Widget>[
              LoginForm(context),
              loader ? LoaderWidget() : Container()
            ],
          );
        },
      )),
    );
  }



  ShowDialogBox(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(10.5),
            contentPadding: EdgeInsets.all(20.0),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text("Reset password"),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close),
                  ),
                )
              ],
            ),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      style: FormInputDecoration.CustomTextStyle(),
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.none,
                      decoration:
                          FormInputDecoration.FormInputDesign(name: "Password"),
                    )
                  ],
                ),
              )
            ],
          );
        },
        barrierDismissible: false);
  }



  Widget LoginForm(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
          key: _loginForm,
          autovalidate: _autoValid,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              PageHeader(title: "Sign In"),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
              focusNode: email,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: FormInputDecoration.CustomTextStyle(),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.none,
              decoration: FormInputDecoration.FormInputDesign(name: "Email"),
              onFieldSubmitted: (node) {
                email.unfocus();
                FocusScope.of(context).requestFocus(password);
              },
              validator: (value) => CheckFieldValidation(
                  val: value,
                  password: '',
                  fieldName: "Email",
                  fieldType: VALIDATION_TYPE.EMAIL),
              ),
              SizedBox(
              height: 20.0,
             ),
              TextFormField(
              controller: passwordCtrl,
              focusNode: password,
              obscureText: true,
              textInputAction: TextInputAction.done,
              style: FormInputDecoration.CustomTextStyle(),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.none,
              decoration: FormInputDecoration.FormInputDesign(name: "Password"),
              onFieldSubmitted: (node) {
                password.unfocus();
              //  login(context);
              },
              validator: (value) => CheckFieldValidation(
                  val: value,
                  password: '',
                  fieldName: "Password",
                  fieldType: VALIDATION_TYPE.TEXT),
             ),
              SizedBox(
              height: 20.0,
              ),
              CustomButton(
              text: "Login",
              color: Colors.red.shade800,
              onPressed: () {
                if (_loginForm.currentState.validate()) {
                  _loginForm.currentState.save();
                  LoginClick(emailCtrl.value.text, passwordCtrl.value.text).getData(context).then((result)=>{

                   /* setState(() {
                      loader = true;
                    }),*/
                  });
                }

              },

              ),
              SizedBox(
              height: 20.0,
            ),

          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    emailCtrl.dispose();
    password.dispose();
    passwordCtrl.dispose();
  }
}
