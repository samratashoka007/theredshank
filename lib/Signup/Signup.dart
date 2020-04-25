import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:theredshank/Home/Home.dart';
import 'package:theredshank/Login/Login.dart';
import 'package:theredshank/Modal/Validation.dart';
import 'package:theredshank/Root.dart';
import 'package:theredshank/Theme/Loader.dart';
import 'package:theredshank/Url/Urlconnection.dart';
import 'package:url_launcher/url_launcher.dart';


import '../CustomButton.dart';
import '../FormInputDecoration.dart';
import '../PageHeader.dart';

import 'package:http/http.dart' as http;


class Signup extends StatefulWidget {
  createState() => SignupState();
}

class SignupState extends State<Signup> {

  FocusNode username,firstname,lastname;
  FocusNode email;
  FocusNode password;
  FocusNode confirmPassword;
  FocusNode postCode;
  FocusNode suffix;

  TextEditingController emailCtrl, passwordCtrl, usernameCtrl, cpasswordCtrl,postcodeCtrl,suffixCtrl,fnameCtrl,lnameCtrl;

  final _formKey = GlobalKey<FormState>();
  bool _autoValid = false;
  bool loader = false;
  bool _termsChecked = false;
  bool checkboxValue = false;
  bool visible = false ;
  @override
  void initState() {
    super.initState();



    _autoValid = false;
    loader = false;

    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    usernameCtrl = TextEditingController();
    cpasswordCtrl = TextEditingController();
    postcodeCtrl = TextEditingController();
    suffixCtrl = TextEditingController();
    fnameCtrl = TextEditingController();
    lnameCtrl = TextEditingController();

    username = FocusNode();
    firstname = FocusNode();
    lastname = FocusNode();
    email = FocusNode();
    password = FocusNode();
    confirmPassword = FocusNode();
    postCode = FocusNode();
    suffix = FocusNode();

  }

  @override
  void dispose() {
    super.dispose();

    username?.unfocus();
    firstname?.unfocus();
    lastname?.unfocus();
    email?.unfocus();
    password?.unfocus();
    confirmPassword?.unfocus();
    postCode?.unfocus();
    suffix?.unfocus();
    emailCtrl?.dispose();
    passwordCtrl?.dispose();
    usernameCtrl?.dispose();
    cpasswordCtrl?.dispose();
    postcodeCtrl?.dispose();
    suffixCtrl?.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Builder(builder: (context) {
          return Stack(
            children: <Widget>[
              SignupForm(context),
              loader ? LoaderWidget() : Container()
            ],
          );
        })));
  }
  Future userRegistration() async{
    email.unfocus();
    password.unfocus();
    username.unfocus();
    firstname.unfocus();
    lastname.unfocus();
    confirmPassword.unfocus();
    postCode.unfocus();
  //  suffix.unfocus();

    // Showing CircularProgressIndicator.
    if(checkboxValue==false){
      Fluttertoast.showToast(msg: "Please agree on the terms and condition it is required");
    }
    else{
      setState(() {
        loader = true;
      });

      // Getting value from Controller
      String getemail = emailCtrl.value.text;
      String getpassword = passwordCtrl.value.text;
      String getname = usernameCtrl.value.text;
      String getfname = fnameCtrl.value.text;
      String getlname = lnameCtrl.value.text;
      String getpostcode=postcodeCtrl.value.text;
      String getsuffix=suffixCtrl.value.text;


      // SERVER API URL
      var url = UrlCollection.reg_url;

      // Store all data with Param Name.
      var data = {'username': getname,'firstname':getfname,'lastname':getlname, 'email': getemail, 'password' : getpassword,'post_code':getpostcode};

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
                  if(message=="User registered successfully"){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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
  Widget SignupForm(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidate: _autoValid,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                SizedBox(
              height: 20.0,
             ),
                PageHeader(title: "Register Now"),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: usernameCtrl,
                  textInputAction: TextInputAction.next,
                  focusNode: username,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration: FormInputDecoration.FormInputDesign(name: "User Name"),
                  onFieldSubmitted: (node) {
                    username.unfocus();
                    FocusScope.of(context).requestFocus(username);
                  },

                  // validator: validateEmail, //passing the reference of the validation mixin, not calling directly
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: null,
                      fieldName: "UserName",
                      fieldType: VALIDATION_TYPE.TEXT),

                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: fnameCtrl,
                  textInputAction: TextInputAction.next,
                  focusNode: firstname,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration: FormInputDecoration.FormInputDesign(name: "First Name"),
                  onFieldSubmitted: (node) {
                    firstname.unfocus();
                    FocusScope.of(context).requestFocus(firstname);
                  },

                 // validator: validateEmail, //passing the reference of the validation mixin, not calling directly
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: null,
                      fieldName: "First Name",
                      fieldType: VALIDATION_TYPE.TEXT),

                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: lnameCtrl,
                  textInputAction: TextInputAction.next,
                  focusNode: lastname,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration: FormInputDecoration.FormInputDesign(name: "Last Name"),
                  onFieldSubmitted: (node) {
                    lastname.unfocus();
                    FocusScope.of(context).requestFocus(lastname);
                  },

                  // validator: validateEmail, //passing the reference of the validation mixin, not calling directly
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: null,
                      fieldName: "Last Name",
                      fieldType: VALIDATION_TYPE.TEXT),

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
                    FocusScope.of(context).requestFocus(password);
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
                  controller: passwordCtrl,

                  textInputAction: TextInputAction.next,
                  focusNode: password,
                  obscureText: true,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration: FormInputDecoration.FormInputDesign(name: "Password"),
                  onFieldSubmitted: (node) {
                    password.unfocus();
                    FocusScope.of(context).requestFocus(confirmPassword);
                  },
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: null,
                      fieldName: "Password",
                      fieldType: VALIDATION_TYPE.PASSWORD),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: postcodeCtrl,
                  textInputAction: TextInputAction.next,
                  focusNode: postCode,
                  obscureText: true,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration: FormInputDecoration.FormInputDesign(name: "Post Code"),
                  onFieldSubmitted: (node) {
                    postCode.unfocus();
                    FocusScope.of(context).requestFocus(postCode);
                  },
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: null,
                      fieldName: "Post Code",
                      fieldType: VALIDATION_TYPE.POST_Code),
                ),
                SizedBox(
                  height: 20.0,
                ),
                /* CheckboxListTile(
                    title: new Text('Terms and Conditionns'),
                    value: _termsChecked,
                    onChanged: (bool value) =>
                        setState(() => _termsChecked = value),
                ),*/
                /*CheckboxListTile(
                  activeColor: Theme.of(context).accentColor,
                  title: Text("I agree to the Redshank's privacy policy"),
                  value: _termsChecked,
                  onChanged: (bool value) => setState(() => _termsChecked = value),
                  subtitle: !_termsChecked
                      ? Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                   *//* child: Text('Required field', style: TextStyle(color: Color(0xFFe53935), fontSize: 12),
                    ),*//*
                    child: Row(
                      children: [
                         Text('Required field', style: TextStyle(color: Color(0xFFe53935), fontSize: 12),),

                      ],
                    ),

                  )
                      : null,
                ),*/
              CheckboxListTile(
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
              subtitle: !checkboxValue
                  ? Text(
                'Required.',
                style: TextStyle(color: Colors.red.shade800),
              )
                  : null,
              title: new Text(
                "I agree to the Redshank's privacy policy.",
                style: TextStyle(fontSize: 14.0),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.red.shade800,

            ),
                SizedBox(
                  height: 20.0,
                ),
                 InkWell(
                    child: new Text("Click Here to check the Redshank's privacy policy ",
                    style: TextStyle(color: Colors.red.shade800),),
                    onTap: () => launch('https://www.theredshank.com/privacy-policy/')

                ),
                SizedBox(
                  height: 20.0,
                ),
              /*  TextFormField(
                  controller: suffixCtrl,
                  textInputAction: TextInputAction.done,
                  focusNode: suffix,
                  obscureText: true,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration: FormInputDecoration.FormInputDesign(name: "Suffix"),
                  onFieldSubmitted: (node) {
                    suffix.unfocus();
                    FocusScope.of(context).requestFocus(suffix);
                  },
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: null,
                      fieldName: "Suffix",
                      fieldType: VALIDATION_TYPE.SUFFIX),
                ),
                SizedBox(
                  height: 20.0,
                ),*/
            /*    TextFormField(
                  controller: cpasswordCtrl,
                  textInputAction: TextInputAction.done,
                  focusNode: confirmPassword,
                  obscureText: true,
                  style: FormInputDecoration.CustomTextStyle(),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.none,
                  decoration:
                      FormInputDecoration.FormInputDesign(name: "Confirm password"),
                  onFieldSubmitted: (node) {
                    confirmPassword.unfocus();
                 //   signup(context);
                  },
                  validator: (value) => CheckFieldValidation(
                      val: value,
                      password: passwordCtrl.value.text,
                      fieldName: "Confirm password",
                      fieldType: VALIDATION_TYPE.CONFIRM_PASSWORD),
                ),*/
                SizedBox(
                  height: 20.0,
                ),
                CustomButton(
                  text: "Sign up",
                  color: Colors.red.shade800,

                 onPressed: () {
                   if (_formKey.currentState.validate()) {
                     _formKey.currentState.save();
                     userRegistration();
                   }
                 },
                ),
       /*     Container(
              height: 50.0,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "OR",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
              ),
            ),*/
         /*   CustomButton(
              text: "Connect with facebook",
              color: Colors.indigo,
              onPressed: () {},
            ),
            SizedBox(
              height: 5.0,
            ),
            CustomButton(
              text: "Connect with twitter",
              color: Colors.blue,
              onPressed: () {},
            ),*/
          ],
        ),
      ),
    ));
  }
}
