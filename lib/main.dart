import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mazrati/adding.dart';
import 'package:mazrati/edit.dart';
import 'package:mazrati/loginpage.dart';
import 'package:mazrati/mainpage.dart';
import 'package:mazrati/search.dart';
import 'package:mazrati/section1.dart';
import 'package:mazrati/sign_up.dart';
import 'package:mazrati/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dates.dart';
import 'main_mazrati.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var data;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot)  {
          // Check for errors
          if (snapshot.hasError) {
            return MaterialApp(title: "error",
              home: Scaffold(body: Center(child: Text("Pls check internet connection"),),),);
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(future: getdataw() , builder: (context ,snapshot ){
              if(snapshot.hasError){
                return MaterialApp(title: "error",debugShowCheckedModeBanner: false,
                  home: Scaffold(body: Center(child: Text("Pls check internet connection"),),),);
              }
              if(snapshot.connectionState ==ConnectionState.done){
                return MaterialApp(title: "Mazre3na",debugShowCheckedModeBanner: false,
                  home: data ==null ? Loginpage(): Mainpage(username: data,) //Section1(username: data,)
                );
              }
              return MaterialApp(title:"Loading",
                home: Scaffold(body: CircularProgressIndicator(),),);
            },);

          }
          // Otherwise, show something whilst waiting for initialization to complete
          return MaterialApp(title:"Loading",
            home: Scaffold(body: CircularProgressIndicator(),),);
        },
      );
  }
  Future getdataw() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     data = sharedPreferences.get("username");
     return data;
  }
}




