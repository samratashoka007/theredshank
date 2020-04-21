import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';


import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart'as http;
import 'package:move_to_background/move_to_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theredshank/Login/Login.dart';
import 'package:theredshank/Modal/Validation.dart';
import 'package:theredshank/Signup/Signup.dart';
import 'package:theredshank/Theme/Loader.dart';
import 'package:theredshank/Url/Urlconnection.dart';
import 'package:theredshank/contactUs/contactUs.dart';
import '../CustomButton.dart';
import '../FormInputDecoration.dart';
import '../Root.dart';

class Welcome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WelcomeScree();
  }
}
const alarmAudioPath = "sound_alarm.mp3";
class WelcomeScree extends State {

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String name, username, avatar,tokenNotified;
  bool isData = false;
  String msg ,getToken;
  String email,password,userId;
  bool loader = false;
  Future<Album> futureAlbum;
  TextEditingController tokenCtrl;
  bool _validate = false;
  bool _buttonEnabled = true;
  String d_userId,tokenId;
  static AudioCache player = new AudioCache();



  Timer timer;
  //int counter = 0;
  @override
  void initState() {
    super.initState();
    tokenCtrl = TextEditingController();
    ///_authentication = Authentication();
    //startTimer();
   ///
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => fetchTrack());
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchOrder());
   // fetchTrack();
    loader = false;
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    fetchData();

  }
  fetchData() async{
    SharedPreferences savetokenData=await SharedPreferences.getInstance();
    setState(() {
      getToken=(savetokenData.getString('tokenNo')??'');
      print(getToken);

      if(getToken.length==0||getToken=="null"){
        msg="";
        tokenCtrl.text="";
      }
      else{
        msg=getToken.toString();
        tokenCtrl.text=getToken.toString();
        _buttonEnabled=false;
        timer = Timer.periodic(Duration(seconds: 60), (Timer t) => fetchTrack());
        timer = Timer.periodic(Duration(seconds: 30), (Timer t) => fetchOrder());
      }
    });
  }
/* Future onSelectNotification(String payload) {
   debugPrint("payload : $payload");
   showDialog(
     context: context,
     builder: notificationExpiredAlert
     *//*builder: (_) => new AlertDialog(
       title: new Text('TheRedshank'),
       content: new Text('$payload'),
     ),*//*
   );
 }*/

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("The Redshank"),
          backgroundColor: Colors.red.shade800,

          actions: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child:  new IconButton(

                  icon: new Icon(Icons.power_settings_new),
                  onPressed: () {

                    showAlertDialog1(context);

                  }
              ),
            ),



          ],

        ),
          body:SafeArea(child: Builder(builder: (context) {
            return Stack(
              children: <Widget>[
                WelcomFormn(context),
                loader ? LoaderWidget() : Container(),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: new Padding(
                      padding: EdgeInsets.only(top: 200.0,bottom: 10.0),
                      child:RaisedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => contactUs()));
                        },
                        child: Text("Contact us", style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,

                        ),
                        ),
                        textColor: Colors.white,

                        color: Colors.red.shade800,
                        //width: 250.0,

                      ),

                    ),
                    /*child: MaterialButton(
                      onPressed: () => {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => contactUs()))
                      },
                      child: Text('Contact us'),
                    ),*/
                  ),
                ),
              ],
            );
          }



          )
          )

      ),
      //  key: _scaffoldKey,

       /* body:WillPopScope(
          onWillPop: (){ // will triggered as we click back button
            saveLastScreen(Route lastRoute); // saving to SharedPref here
            return Future.value(true);
          },
          child:SafeArea(child: Builder(builder: (context) {
            return Stack(
              children: <Widget>[
                WelcomFormn(context),
                loader ? LoaderWidget() : Container()
              ],
            );
          }


          )) ,
        )*/




    );


  }


   fetchTrack() async {
     var urlLogout='http://foodtruck.websquareit.com/index.php/welcome/data';
     SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     setState(() {
       email=(sharedPreferences.getString('email')??'');
       userId=(sharedPreferences.getString('u_id')??'');

     });

     var data = {'u_id' : userId};
     //loader=true;
     //var logoutdata={'u_id':userId,'email':email};
     var response = await http.post(urlLogout,body: data);
     String jsonsDataStringf = response.body.toString();
     // Getting Server response into variable.
     var messagef = json.decode(response.body);
      print(messagef);
      print(jsonsDataStringf);
      d_userId=messagef['u_id'];
      tokenId=messagef['token_num'];

      if(userId==d_userId){
        if(tokenId==''||tokenId.length==0){
         // loader=false;
          sessionExpiredAlert(context);
        }

      }

     /*    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
     setState(() {
       email=(sharedPreferences.getString('email')??'');
       userId=(sharedPreferences.getString('u_id')??'');

     });
    final response =
    await http.post('http://foodtruck.websquareit.com/index.php/welcome/data');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      var responseJson = json.decode(response.body);
      // assume there is only one track to display
      // SO question mentioned 'display current track'
     *//* var track = responseJson['logged_in']
          .map((musicFileJson) => responseJson(musicFileJson['track']))
          .first;
      return track;*//*

      d_userId = responseJson['u_id'];

      if (d_userId==userId) {
       *//* saveBooleanValue('logged_in', isSuccessed);
        saveStringValue('email', email);
        saveStringValue('password', password);
        saveStringValue('u_id', userId);*//*

        sessionExpiredAlert(context);
      }

    else{
      Fluttertoast.showToast(msg: "Please Check Internet Connection");
    }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }*/
  }
  fetchOrder() async {

    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    setState(() {
      email=(sharedPreferences.getString('email')??'');
      userId=(sharedPreferences.getString('u_id')??'');

    });
    var data = {'u_id' : userId};
    var Response = await http.post(
      "http://foodtruck.websquareit.com/index.php/welcome/co_data",
    //  headers: {"Accept": "application/json"},
      body: data
    );
   // loader=true;
    //var logoutdata={'u_id':userId,'email':email};
    if (Response.statusCode == 200) {
      if(userId==d_userId){
        String responseBody = Response.body;
        var responseJSON = json.decode(responseBody);
        username = responseJSON['u_id'];
      //  name = responseJSON['email'];
        avatar = responseJSON['msg'];
        tokenNotified = responseJSON['token_num'];
        if(avatar==''||avatar==null||avatar.length==0){
          isData= false;
        }
        else{
          if(tokenNotified==msg){
            isData = true;
            setState(() {
              print('UI Updated');
            });
            for(int i=0;i<1;i++){
              showNotification();
            }

          }

        }

      }

    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
    }
  /*showNotification() async {
   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
       'your channel id', 'your channel name', 'your channel description',
       importance: Importance.Max, priority: Priority.High);
   var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
   var platformChannelSpecifics = new NotificationDetails(
       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
   await flutterLocalNotificationsPlugin.show(
     0,
     'Food is ready',
     '$avatar',
     platformChannelSpecifics,
     payload: 'Please Pickup Your Order',
   );
 }*/
  showNotification() async {

    /*String alarmUri = await platform.invokeMethod('getAlarmUri');
    final x = UriAndroidNotificationSound(alarmUri);*/
   var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
       'your channel id', 'your channel name', 'your channel description',
        sound:RawResourceAndroidNotificationSound("moonless"),
       importance: Importance.Max,
       priority: Priority.High,
      );
   var iOSPlatformChannelSpecifics =
   new IOSNotificationDetails(sound: "slow_spring_board.aiff");
   var platformChannelSpecifics = new NotificationDetails(
       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
   await flutterLocalNotificationsPlugin.show(
     0,
     'TheRedshank',
     '$avatar',
     platformChannelSpecifics,
     payload: notificationExpiredAlert(context),
   );
   player.play(alarmAudioPath);
   /*FlutterRingtonePlayer.play(
     android: AndroidSounds.notification,
     ios: IosSounds.glass,
     looping: true, // Android only - API >= 28
     volume: 0.1, // Android only - API >= 28
     asAlarm: false, // Android only - all APIs
   );*/
 }
  /*Future showNotification() async {
    var scheduledNotificationDateTime =
    new DateTime.now().add(new Duration(seconds: 5));
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'app_icon',
        sound: RawResourceAndroidNotificationSound('slow_spring_board.mp3'),
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        //vibrationPattern: vibrationPattern,
        vibrationPattern: vibrationPattern,
        color: const Color.fromARGB(255, 255, 0, 0));
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        '$avatar',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }*/
 /* Future<void> showNotification() async {
  *//*
   var android = new AndroidNotificationDetails(
       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
       priority: Priority.High,importance: Importance.Max,

   );
   var iOS = new IOSNotificationDetails();
   var platform = new NotificationDetails(android, iOS);
   await flutterLocalNotificationsPlugin.show(
       0, 'Your Order is ready', '$avatar', platform,
       payload: 'Please Pickup Your Order');*//*
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'app_icon',
        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        largeIcon: DrawableResourceAndroidBitmap('sample_large_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        '$avatar',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
 }*/


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  Future<String> fetchPatientCount() async {
    print("fetchPatientCount");
    return DateTime.now().toIso8601String();
  }

  /*void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }*/

 /* void navigateUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    Route route;
    if (status) {
      route = MaterialPageRoute(builder: (context) => Welcome());
      Navigator.pushReplacement(context, route);
    } else {
      route = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, route);
    }
  }*/
 notificationExpiredAlert(BuildContext context){
   Widget cancel = FlatButton(
     child: Text("Cancel"),
     onPressed: () {
       Navigator.of(context).pop();
     },
   );
   Widget yesButtn = FlatButton(
     child: Text("OK"),
     onPressed: () {
       logout();
       clearAllValue();
       Route route = MaterialPageRoute(builder: (context) => Root());
       Navigator.pushAndRemoveUntil(context, route,ModalRoute.
       withName('/root'));
     },
   );


   CupertinoAlertDialog cupertinoAlertDialog=CupertinoAlertDialog(
     title: Text("Your Food is Ready"),
     content: Text("Enjoy Your Food || If You Want new order please re login"),
     actions: <Widget>[
       //cancel,
       yesButtn,
     ],
   );
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return cupertinoAlertDialog;
     },
   );
 }
  sessionExpiredAlert(BuildContext context){
    Widget cancel = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButtn = FlatButton(
      child: Text("OK"),
      onPressed: () {
        logout();
        clearAllValue();
        Route route = MaterialPageRoute(builder: (context) => Root());
        Navigator.pushAndRemoveUntil(context, route,ModalRoute.
        withName('/root'));
      },
    );


    CupertinoAlertDialog cupertinoAlertDialog=CupertinoAlertDialog(
      title: Text("Token Expired"),
      content: Text("You need to login again"),
      actions: <Widget>[
       // cancel,
        yesButtn,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
  showAlertDialog1(BuildContext context){
    Widget cancel = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButtn = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        logout();
        clearAllValue();
        Route route = MaterialPageRoute(builder: (context) => Root());
        Navigator.pushAndRemoveUntil(context, route,ModalRoute.
        withName('/root'));
      },
    );


    CupertinoAlertDialog cupertinoAlertDialog=CupertinoAlertDialog(
      title: Text("Logout"),
      content: Text("would you like to logout ? "),
      actions: <Widget>[
        cancel,
        yesButtn,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return cupertinoAlertDialog;
      },
    );
  }
  logout() async{
  var urlLogout=UrlCollection.logout;
  SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
  setState(() {
    email=(sharedPreferences.getString('email')??'');
    userId=(sharedPreferences.getString('u_id')??'');

  });
  loader=true;
  var logoutdata={'u_id':userId,'email':email};
  var response = await http.post(urlLogout,body: logoutdata);
  String jsonsDataString = response.body.toString();
  // Getting Server response into variable.
  var message = json.decode(response.body);


  // Starting Web API Call.
  print(message);
  print(jsonsDataString);

  if(response.statusCode == 200){
    setState(() {
      loader = false;
  });
  }
  else {
    print('Something went wrong. \nResponse Code : ${response.statusCode}');
    Fluttertoast.showToast(msg: "Something went wrong");
    //showDialog(context: build(context))


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Please Try Again"),
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
  }
  String isRequired(String val, String fieldName) {
    if (val == null || val == '') {
      return "$fieldName is required";
    }
    return null;
  }

  checkTextFieldEmptyOrNot(){

    // Creating 3 String Variables.
    String text1;

    // Getting Value From Text Field and Store into String Variable
    text1 = tokenCtrl.text ;
 
    // Checking all TextFields.
    if(text1 == '' )
    {
      // Put your code here which you want to execute when Text Field is Empty.
      print('Text Field is empty, Please Fill All Data');
      Fluttertoast.showToast(msg: "Please Fill All the fields");

    }else{

      // Put your code here, which you want to execute when Text Field is NOT Empty.
      print('Not Empty, All Text Input is Filled.');
    }

  }
  FetchJSON() async {
    _buttonEnabled=false;

    checkTextFieldEmptyOrNot();
    var url = UrlCollection.token_genrate;
    // Store all data with Param Name.
    String tokengenration= tokenCtrl.value.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = (prefs.getString('email')??'');
      userId=(prefs.getString('u_id')??'');

     // password = (prefs.getString('password')??'');
    });
    loader = true;
   var data = {'u_id': userId,'token_num':tokengenration};
    var response = await http.post(url,body: data);
    String jsonsDataString = response.body.toString();
    // Getting Server response into variable.
    var message = json.decode(response.body);
  //  msg=jsonsDataString;

    // Starting Web API Call.
    print(message);
    print(jsonsDataString);

    String tokenNo=message['token_num'];
    print(tokenNo);
    msg=tokenNo;
    saveTokenNo('tokenNo',tokenNo);
    if(response.statusCode == 200){
      setState(() {
        loader = false;

        
      });
    }
    else {
      print('Something went wrong. \nResponse Code : ${response.statusCode}');
      Fluttertoast.showToast(msg: "Something went wrong");
      //showDialog(context: build(context))
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text("Please Try Again"),
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


  }
  Future<Album> createAlbum() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = (prefs.getString('email')??'');
      password = (prefs.getString('password')??'');
    });
    final http.Response response = await http.post(
      UrlCollection.token_genrate,
      headers: <String, String>{
        'Content-Type': 'text/html; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email
      }),
    );
      print(response);
    if (response.statusCode == 200) {
      var token=Album.fromJson(json.decode(response.body));
      int t1=token.id;
     // int t1=token['token_no'];
      print(t1);
      return Album.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to create album.');
    }

  }

  Future<bool> saveTokenNo(String key ,String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }
  Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
  Future<bool> clearAllValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
 WelcomFormn(BuildContext context ) {

   return SingleChildScrollView(
     child: Form(
       child: Padding(

         padding: EdgeInsets.symmetric(horizontal: 30.0),
         child: new Column(
           mainAxisAlignment: MainAxisAlignment.start,

           children: <Widget>[
             new Text(
               'Welcome to the Redshank',
               style: new TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 20.0,

               ),
             ),
             SizedBox(
               height: 20.0,
             ),
             new Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[

                 TextFormField(
                   controller: tokenCtrl,
                   textInputAction: TextInputAction.done,
                   //focusNode: password,
                   keyboardType: TextInputType.number,
                   //obscureText: true,
                   style: FormInputDecoration.CustomTextStyle(),
                   textAlign: TextAlign.center,
                   textCapitalization: TextCapitalization.none,
                   decoration: FormInputDecoration.FormInputDesign(name: "Enter Order No",
                     errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                   onFieldSubmitted: (node) {
                     //  password.unfocus();
                     //FocusScope.of(context).requestFocus(confirmPassword);
                   },
                   validator: (value) => CheckFieldValidation(
                       val: value,
                       password: null,
                       fieldName: "Token No",
                       fieldType: VALIDATION_TYPE.TokenNo),


                 ),
                 SizedBox(
                   height: 20.0,
                 ),
               ],
             ),
             new Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[


                 new RaisedButton(
                   /*  onPressed: () {

                       setState(() {
                         if(tokenCtrl.text.isEmpty || tokenCtrl.text == ''){
                           tokenCtrl.text.isEmpty ? _validate = true : _validate = false;
                         }
                        else{
                           FetchJSON();
                         }

                      });
                    },*/
                   //onPressed: !_buttonEnabled ? () {} : null,
                   onPressed: (){
                     setState(() {
                       if(_buttonEnabled){
                         if(tokenCtrl.text.isEmpty || tokenCtrl.text == ''){
                           tokenCtrl.text.isEmpty ? _validate = true : _validate = false;
                         }
                         else{
                           FetchJSON();
                         }
                       }
                       else{
                         Fluttertoast.showToast(msg: "You need to wait Until your first order completed");
                       }

                     });
                   },
                   textColor: Colors.white,
                   color: Colors.red.shade800,
                   padding: const EdgeInsets.all(10.0),
                   child: new Text(

                     "Submit",
                     style: new TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 20.0,

                     ),
                   ),

                 ),
                 SizedBox(
                   height: 20.0,
                 ),
               ],
             ),

             new Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 new Container(
                   height: 250,
                   width: 190,
                   child: Stack(
                     children: <Widget>[
                       Center(
                         child: Image.asset('images/golden_token.png'),
                       ),
                       Center(

                         child: Text('Order is = $msg',
                           style: new TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 20.0,

                           ),
                         ),
                       )
                     ],
                   ),
                 ),

                 SizedBox(
                   height: 20.0,
                 ),
               ],
             ),



             /*Container(
               width: MediaQuery.of(context).size.width,
               child: Column(

                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[

                  Align(
                    alignment: Alignment.bottomCenter,
                    child:  CustomButton(

                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      text: "Sign Up",
                      color: Colors.red.shade800,
                      width: 250.0,
                    ),

                  ),
                     SizedBox(
                       height: 5.0,
                     ),

                 ],
               ),
             )*/
             /* new FutureBuilder<String>(
                future: fetchPatientCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      *//* below text needs to be updated every 5 mins or so *//*
                      return new Text('#' + snapshot.data.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 7.0));
                    } else if (snapshot.hasError) {
                      return new Text("${snapshot.error}");
                    }
                  }
                }
            ),*/
             /* new Row(
                children: <Widget>[
              new FutureBuilder<String>(
                  future: fetchPatientCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      *//* below text needs to be updated every 5 mins or so *//*
                      return new Text('#' + snapshot.data.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 7.0));
                    } else if (snapshot.hasError) {
                      return new Text("${snapshot.error}");
                    }
                  }
                }
               ),
                ],
              ),*/
             /* new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  child: Stack(
                    children: <Widget>[
                      loader ? LoaderWidget() : Container()
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),*/



           ],
         ),
       ),
     ),
   );
 }

  void saveLastRoute(Route lastRoute) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_route', lastRoute.settings.name);
  }
}




class Album {
  final int id;


  Album(this.id);

  factory Album.fromJson(dynamic json) {
    return Album(json['token'] as int);
  }
}

