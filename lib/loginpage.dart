import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mazrati/main_mazrati.dart';
import 'package:mazrati/mainpage.dart';
import 'package:mazrati/section1.dart';
import 'package:mazrati/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:login_demo/auth.dart';
//import 'package:login_demo/auth_provider.dart';




class Loginpage extends StatefulWidget {
  // FirebaseApp app;
  // Sign_up({this.app});
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}
class _LoginPageState extends State<Loginpage> {
  GlobalKey<FormState> key = new GlobalKey<FormState>();
  GlobalKey<FormState> keyforgot = new GlobalKey<FormState>();
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
    if(value.length <6){
      return 'Password can\'t be less than 6 chracters' ;
    }
    if(value.isEmpty){
      return 'Password can\'t be empty' ;
    }
    return null;
  }
  static String validatename(String value) {
    if(value.isEmpty){
      return 'Place name can\'t be empty';
    }
    return null;
  }
  @override
  void initState() {
    super.initState();
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ref = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController name = new TextEditingController();
 // TextEditingController email = new TextEditingController();
  TextEditingController emailorphone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController emailforgot = new TextEditingController();
  TextEditingController passwordforgot = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final refrence = ref.reference();
    void forgot() async{
      var namechange;
      if(keyforgot.currentState.validate()) {
        try {
          await refrence.child("resturant_ac").once().then((DataSnapshot value){
            Map<dynamic,dynamic> values = value.value;
            values.forEach((key, value) {
              if(value["email"] == emailforgot.text){
                namechange =value["name"].toString();
              }
            });

          });
          await auth.sendPasswordResetEmail(email: emailforgot.text);
          await refrence.child("resturant_ac").child(namechange).child("password").remove();
          Navigator.of(context).pop();
          return showDialog(context: context, builder: (context) {
            return AlertDialog(title: new Text("Error"),
                content: new Text("plsese go to your email to change the password"),
                actions: [
                  new ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text("ok"))
                ]);
          });
        } on FirebaseAuthException catch (e) {
          return showDialog(context: context, builder: (context) {
            return AlertDialog(title: new Text("Error"),
                content: new Text(e.message),
                actions: [
                  new ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: Text("ok"))
                ]);
          });
        }
      }
      else{
      }
    }
    void getData() async {
      final response = await http.get(Uri.parse("https://mazrati.000webhostapp.com/mazratitest.php"));
      print(jsonDecode(response.body));
    }
   void Logins() async{
      //getData();
     var state = key.currentState;
     List data;
     if(state.validate()){
       try {
         showDialog(
             barrierDismissible: false, context: context, builder: (context) {
           return AlertDialog(title: new Text(
             "الرجاء الانتظار بضعة لحظات لكي تسجيل الدخول",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blueAccent),),
             content: Container(width: MediaQuery.of(context).size.width*0.25
                 ,height: MediaQuery.of(context).size.width*0.25,child: new Center(child: CircularProgressIndicator(),)),
           );
         });
         //var url = "http://www.mazrati.epizy.com/mazrati.php";
         //var url = "http://10.0.2.2:8585/notification/mazrati.php";
         var response = await http.get(Uri.parse("https://mazrati.000webhostapp.com/mazrati.php"));
         var pdfText = jsonDecode(response.body);
         data = pdfText;
       }
       catch(exception ){
print(exception);
       }
       // body;
       var nameable =false;
       var passable =false;
       for (int s = 0; s < data.length; s++) {
         if (data[s]["username"] == name.text) {
          nameable =true;
          if (data[s]["password"] == password.text) {
            passable = true;
          }
         }
         }
       if(nameable ==false){
         Navigator.of(context,rootNavigator: true).pop('dialog');
         return showDialog(context: context, builder: (context) {
           return AlertDialog(title: new Text("Error"),
               content: new Text("لا يوجد حساب بهذا الاسم!"),
               actions: [
                 new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
               ]);
         });

       }
       else if(nameable ==true&&passable==false ){
         Navigator.of(context,rootNavigator: true).pop('dialog');
         return showDialog(context: context, builder: (context) {
           return AlertDialog(title: new Text("Error"),
               content: new Text("this  password is not correct. pls try again"),
               actions: [
                 new ElevatedButton(onPressed:(){Navigator.of(context).pop();}, child: Text("ok"))
               ]);
         });
       }
       else if(nameable ==true && passable ==true){
         Navigator.of(context,rootNavigator: true).pop('dialog');
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
           return Mainpage(username: name.text,);
         }));
       }

     }

    }
      Login() async{
        var state = key.currentState;
        if(state.validate()){
          await refrence.child("users").once().then((DataSnapshot value){
            Map<dynamic,dynamic> values = value.value;
            var nameable =false;
            var passable =false;
            values.forEach((key, value) async {
              if (value["name"] == name.text) {
                nameable = true;
                if (value["password"] == password.text) {
                  passable = true;
                }
              }
            });
            if(nameable ==false){
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("Error"),
                    content: new Text("this  name is not exist. pls try again"),
                    actions: [
                      new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
                    ]);
              });

            }
            else if(nameable ==true&&passable==false ){
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("Error"),
                    content: new Text("this  password is not correct. pls try again"),
                    actions: [
                      new ElevatedButton(onPressed:(){Navigator.of(context).pop();}, child: Text("ok"))
                    ]);
              });
            }
            else if(nameable ==true && passable ==true){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return Mainpage(username: name.text,);
              }));
            }
          });
        }
      }
      return Scaffold(
          appBar: AppBar(

          ),
          body: SingleChildScrollView(
              child: Container(
                  child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height *0.35,
                          width: MediaQuery.of(context).size.height *0.35,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
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
                                    child: Text("Log in", style: TextStyle(
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
                                                hintText: "User name",
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
                                            Logins();
                                          },
                                          child: Text("Login", style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),),)))
                                ,SizedBox(height: 40),
                                InkWell(onTap: (){
                                  var alnas =false;
                                  return showDialog(context: context, builder: (context) {
                                    return AlertDialog(title: new Text("ارجاع كلمة السر"),
                                        content:  Container(height: 100,child: Form( key: keyforgot, child:SingleChildScrollView(child :Column(children:[
                                          Text("رجاء أدخل اسم الحساب هنا!"),
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(validator: validateemail,
                                              controller: emailforgot,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "User name",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[400])
                                              ),
                                            ),
                                          )
                                        ]))),),
                                        actions: [
                                          new ElevatedButton( child: Text("recover") , onPressed: ()async {
                                            var response = await http.get(Uri.parse("https://mazrati.000webhostapp.com/mazrati.php"));
                                            List pdfText = jsonDecode(response.body);
                                            var ablo =true;
                                            for(int j=0;j<pdfText.length;j++){
                                              if(pdfText[j]["username"]==emailforgot.text){
                                                ablo =false;
                                                emailforgot.text ="";
                                                Navigator.of(context).pop('dialog');
                                                return showDialog(context: context, builder: (context) {
                                                  return AlertDialog(title: new Text("كلمة السر هي :"),
                                                      content: new Text(pdfText[j]["password"]),
                                                      actions: [
                                                        new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
                                                      ]);
                                                });
                                              }}
                                              if(ablo ==true){
                                                emailforgot.text ="";
                                                return showDialog(context: context, builder: (context) {
                                                  return AlertDialog(title: new Text("خطأ"),
                                                      content: new Text("لا يوجد حساب بهذا الاسم!"),
                                                      actions: [
                                                        new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
                                                      ]);
                                                });
                                            }
                                          }
                                            ,),new ElevatedButton( child: Text("cancel") , onPressed: () {
                                            Navigator.of(context).pop();
                                          }
                                            ,)
                                        ]);
                                  });
                                }, child: Text("Do you forgot your password?",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                )),SizedBox(height: 40),
                                Container( padding: EdgeInsets.all(15),decoration: BoxDecoration(color: Colors.white,
                                    border: Border.all(color: Colors.blueAccent) ,borderRadius: BorderRadius.circular(10)),
                                    child : InkWell( child: Text("Click here if you don't have an account",
                                      style: TextStyle(color: Colors.blueAccent,fontSize: 15),),onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                      return Sign_up();
                                    }));},)
                                )    ]
                          ),
                        ),
                      ])
              )));
    }
  }
