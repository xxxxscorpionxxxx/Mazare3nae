import 'dart:convert';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mazrati/main_mazrati.dart';
import 'package:mazrati/mainpage.dart';
import 'package:mazrati/section1.dart';
import 'package:http/http.dart' as http;
import 'loginpage.dart';
//import 'package:login_demo/auth.dart';
//import 'package:login_demo/auth_provider.dart';




class Sign_up extends StatefulWidget {
 // FirebaseApp app;
 // Sign_up({this.app});
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}
class _LoginPageState extends State<Sign_up> {
  FirebaseApp app ;
  _LoginPageState({this.app});
  final ref = FirebaseDatabase.instance;
  var refrence;
  GlobalKey<FormState> key = new GlobalKey<FormState>();
  static String validateemail(String value) {
    RegExp exp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
 if(exp.hasMatch(value)){
   return null;
 }
    else{
      return "email cant be like that";
    }
  }



  static String validatepassword(String value) {
    if(value.isEmpty){
     return 'Password can\'t be empty' ;
    }
    if(value.length <6){
      return 'Password can\'t be less than 6 charachter' ;
    }
    return null;
  }
  static String validatename(String value) {
    RegExp exp =new RegExp('[a-zA-Z]');
    if(value.isEmpty){
      return 'Place name can\'t be empty';
    }
    if(value.length <5){
      return 'Place name can\'t be less than 5 charachter';
   }
    for(int s=0 ;s<value.length;s++) {
      if (!exp.hasMatch(value[s])) {
        return 'يجب استخدام اللغة الانكيزية!';
      }
    }
    return null;
  }
  @override
  void initState() {
    refrence = ref.reference();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
var go = true;
  final auth = FirebaseAuth.instance;
  TextEditingController name = new TextEditingController();
  TextEditingController emailorphone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  Future signups() async {
    if(go) {
      if (key.currentState.validate()) {
       showDialog(
            barrierDismissible: false, context: context, builder: (context) {
          return AlertDialog(title: new Text(
              "الرجاء الانتظار بضعة لحظات لكي يتم انشاء الحساب الخاص بك",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blueAccent),),
            content: Container(width: MediaQuery.of(context).size.width*0.25
                ,height: MediaQuery.of(context).size.width*0.25,child: new Center(child: CircularProgressIndicator(),)),
          );
        });
        go = false;
        var url = "https://mazrati.000webhostapp.com/mazrati.php";
        var response = await http.get(Uri.parse(url));
        var body = jsonDecode(response.body);
        List data = body;
        var able = true;
        if (data.length != null) {
          for (int s = 0; s < data.length; s++) {
            if (data[0]["username"] == name.text) {
              able = false;
              Navigator.of(context,rootNavigator: true).pop('dialog');
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("Error"),
                    content: new Text(
                        "the name is already exist pls change it"),
                    actions: [
                      new ElevatedButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, child: Text("ok"))
                    ]);
              });
            }
          }
          if (able) {
            var data = {"username": name.text, "password": password.text};
            var url = "https://mazrati.000webhostapp.com/addmazrati.php";
            var response = await http.post(Uri.parse(url), body: data);
            if (response.body.toString().trim() == "tm") {
              Navigator.of(context,rootNavigator: true).pop('dialog');
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return Mainpage(username: name.text,);
                  }));
            }
            else {
              Navigator.of(context,rootNavigator: true).pop('dialog');
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("Error"),
                    content: new Text(response.body.toString().trim()),
                    actions: [
                      new ElevatedButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, child: Text("ok"))
                    ]);
              });
            }
          }
        }
      }
      go =true;
    }
  }

  @override
  Widget build(BuildContext context) {
    void signup() async{
      var able =true;
      var state = key.currentState;
      if(state.validate()){
        await refrence.child("users").once().then((DataSnapshot value){
          Map<dynamic,dynamic> values = value.value;
          if(values != null){
            values.forEach((key, value){
              if(value["name"] == name.text){
                able =false;
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title: new Text("Error"),
                      content: new Text("the name is already exist pls change it"),
                      actions: [
                        new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
                      ]);
                });
              }
            });
            if(able){
              var data = {
                "name": name.text,
                "password": password.text
              };
              try {
                refrence.child("users").child(name.text).set(data);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) {
                      return Mainpage(username: name.text,);
                    }));
              } on FirebaseDatabase catch (e) {
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title: new Text("Error"),
                      content: new Text(e.toString()),
                      actions: [
                        new ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("ok"))
                      ]);
                });
              }
            }
          }
          if(false){
            var data = {
              "name": name.text,
              "password": password.text
            };
            try{
              refrence.child("users").child(name.text).set(data);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return Section1(username: name.text,);
              }));
            } on FirebaseDatabase catch (e){
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("Error"),
                    content: new Text(e.toString()),
                    actions: [
                      new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
                    ]);
              });
            }
          }
        });



      }
    }
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height *0.35,
                  width: MediaQuery.of(context).size.height *0.35,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.blue,
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage('images/signicon.jpg'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: Container(
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: Center(
                          child: Text("Sign up", style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),),
                        ),
                      )
                      ,Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child:Form( key: key,
                        child : Column(
                          children: <Widget>[ Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[100]))
                            ),
                            child: TextFormField(validator: validatename,
                              controller: name,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nick name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400])
                              ),
                            ),
                          ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(obscureText: true,validator: validatepassword,
                                controller: password,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[400])
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                        ),
                        child: Center(
                          child:InkWell(
                            onTap: (){
                              signups();
                            },
                          child: Text("Sign up", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),),))),
                      SizedBox(height: 70),
                     InkWell(onTap: (){
                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                         return Loginpage();
                       }));
                     }, child: Text("Do you have an account?",
                        style: TextStyle(
                            color: Colors.blue,
                  ),
                ))
              ]
            ),
          ),
        ])
    )));
  }
}