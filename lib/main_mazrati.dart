import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazrati/adding.dart';
import 'package:mazrati/firebase.dart';
import 'package:mazrati/search.dart';
import 'package:http/http.dart' as http;
import 'package:mazrati/view2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit.dart';
import 'main.dart';

class Main_Maz extends StatefulWidget{
var username;
 Main_Maz({this.username});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Stateo(username: username);
  }

}
class Stateo extends State<Main_Maz>{
  var username ;
  FirebaseApp app ;
  GlobalKey<FormState> key =new GlobalKey();
  static String validatepassword(String value) {
    if(value.isEmpty){
      return 'code can\'t be empty' ;
    }
    if(value.length <4){
      return 'code can\'t be less than 4 charachter' ;
    }
    return null;
  }
  static String validatename(String value) {
    if(value.isEmpty){
      return 'farmname name can\'t be empty';
    }
    if(value.length <5){
      return 'farmname name can\'t be less than 5 charachter';
    }
    return null;
  }
  Stateo(  {this.app,this.username});
 final FirebaseDatabase refrence = FirebaseDatabase.instance;
  TextEditingController code = new TextEditingController();
  TextEditingController name = new TextEditingController();
  File file ;
  List list1 =[];
  bool asas = false;
  Map<dynamic,dynamic> fromdata;
  var ref;
  deletecode(int i){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(title:new Text("warning"),
          content: new Text("Do you want to delete this account??!!"),
          actions: [
            new ElevatedButton(onPressed:(){
              ref.child(list1[i]['code'].toString()).remove();
              setState(() {
                getdata();
              });
              Navigator.of(context).pop();} , child: Text("ok"))
          ,new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("cancel"))]);
    });

  }
   ImagePicker imagePicker;
  void pic_photo() async{
    //var Imagepicker = ImagePicker();
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
  file  = File(image.path);
  }
  void saved() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setString("username", username.toString());
    print("okay");
  }
  @override
  void initState()  {
    ref = refrence.reference().child("codes");
     getdata();
     saved();
    super.initState();
  }
  void getdata() async{
    list1.clear();
    var url2 = "https://mazrati.000webhostapp.com/mazraticode.php";
    var response2 = await http.get(Uri.parse(url2));
    var body = jsonDecode(response2.body);
    print(body);
    list1 =body;
    setState(() {});
  }
  void deletes(int i)async{
    return showDialog(context: context, builder: (context) {
      return AlertDialog(title:new Text("warning"),
          content: new Text("هل تريد حقا حذف التطبيق"),
          actions: [
            new ElevatedButton(onPressed:() async {
              Navigator.of(context,rootNavigator: true).pop('dialog');
               showDialog(context: context, builder: (context) {
                return AlertDialog(title:new Text("warning"),
                    content: new Text("!عليك الانتظار قليلا لا تقم باغلاق التطبيق حتى يتم تغير الاعدادات"),
                    actions: [
                      new ElevatedButton(onPressed:()  {
                        Navigator.of(context).pop();} , child: Text("ok"))
                      ,new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("cancel"))]);
              });
               var ablo =true;
              var data = {"farmname": list1[i]["farmname"]};
              var url3 = "https://mazrati.000webhostapp.com/mazratietahadelete.php";
              var response3 = await http.post(Uri.parse(url3), body: data);
              var data3 = {"farmname": list1[i]["farmname"]};
              var url4 = "https://mazrati.000webhostapp.com/mazratihajizdelete.php";
              var response4 = await http.post(Uri.parse(url4), body: data3);
              var url = "https://mazrati.000webhostapp.com/mazrati2.php";
              var response= await http.get(Uri.parse(url));
              var body = jsonDecode(response.body);
              List data2 = body;
              for(int y =0;y<data2.length;y++){
                if(data2[y]["farmname"] == list1[i]["farmname"]){
                  ablo =false;
                  for(int i=1;i<9;i++){
                    var url = "https://mazrati.000webhostapp.com/mazratideleteimage.php";
                    var response = await http.post(Uri.parse(url), body: {"imagename":data2[y]["url"+i.toString()]});
                  }
                }
              }
              if(ablo ==true) {
                var url = "https://mazrati.000webhostapp.com/mazrati22.php";
                var response = await http.get(Uri.parse(url));
                var body = jsonDecode(response.body);
                List data2 = body;
                for (int y = 0; y < data2.length; y++) {
                  if(data2[y]["farmname"]==list1[i]["farmname"]) {
                    for (int i = 1; i < 9; i++) {
                      var url = "https://mazrati.000webhostapp.com/mazratideleteimage.php";
                      var response = await http.post(
                          Uri.parse(url), body: {"imagename": data2[y]["url" +
                          i.toString()]});
                    }
                  }
                }
              }
              var url2 = "https://mazrati.000webhostapp.com/mazratideletecode.php";
              var response2 = await http.post(Uri.parse(url2), body: {"farmname" : list1[i]["farmname"]});
              setState(() {
                getdata();
              });
              Navigator.of(context).pop();} , child: Text("ok"))
            ,new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("cancel"))]);
    });
  }
  void add(Map<dynamic,dynamic> data)async{
    if(key.currentState.validate()) {
      var ablename =true;
      var ablecode =true;
      for(int r =0;r<list1.length;r++){
        if(list1[r]["farmname"]==data["farmname"]){
          ablename =false;
          return showDialog(context: context, builder: (context) {
            return AlertDialog(title:new Text("warning"),
                content:Text("لا يمكنك اضافة كود اخر لنفس المزرعة")
                ,actions: [
                  new ElevatedButton(onPressed:(){
                    Navigator.of(context).pop();} , child: Text("ok"))
                ]);
          });
        }
        else if(list1[r]["codes"]==data["code"]){
          ablecode =false;
          return showDialog(context: context, builder: (context) {
            return AlertDialog(title:new Text("warning"),
                content:Text("لا يمكنك اضافة كود موجود مسبقا لمزرعة اخرى!")
                ,actions: [
                  new ElevatedButton(onPressed:(){
                    Navigator.of(context).pop();} , child: Text("ok"))
                ]);
          });
        }
      }
      if(ablecode ==true && ablename==true) {
        var url2 = "https://mazrati.000webhostapp.com/mazratiaddcode.php";
        var response2 = await http.post(Uri.parse(url2), body: data);
        Navigator.of(context,rootNavigator: true).pop('dialog');
        Navigator.of(context).push(MaterialPageRoute(builder: (context){return Adding(farmname: name.text,);}));
        code.text = "";
      }
    }
    }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(actions: [IconButton(icon: Icon(Icons.refresh), onPressed: getdata)],title:Center(child : ListTile(title: Text("Mazrati",style: TextStyle(color: Colors.white,fontSize: 20),)
          ,subtitle: Text("main",style: TextStyle(color: Colors.white,fontSize: 15)))) ,centerTitle: true,),
      body: Container(color: Colors.black12,
        child: Stack(
          children: [Container(child:list1.length !=0 ?  ListView.builder( itemCount: list1.length,itemBuilder: (context,i){
            return Container(margin: EdgeInsets.all(10),decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent),color: Colors.white,borderRadius: BorderRadius.circular(100)),
                child : InkWell(child : ListTile(subtitle: Text(list1[i]['farmname'].toString(),style: TextStyle(color: Colors.blueAccent),)
                ,leading: Icon(Icons.code_rounded),
              trailing: InkWell(child: Icon(Icons.announcement),onTap: (){
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title:new Text("warning"),
                      content:Container(child: Row(children: [Expanded(
                        child: Container(margin: EdgeInsets.only(left: 10,right: 10),
                          child: Expanded(child:ElevatedButton(onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Viewfarm2(farmname: list1[i]["farmname"]);}));},
                            child: Text("معاينة المزرعة"),)),
                        ),
                      ),Expanded(
                          child: Container(margin: EdgeInsets.only(left: 10,right: 10),child: Expanded(child:ElevatedButton(onPressed: (){
                            Navigator.of(context,rootNavigator: true).pop('dialog');
                            deletes(i);},
                            child: Text("حذف كامل المزرعة"),)),
                          )),]))
                      ,actions: [
                        new ElevatedButton(onPressed:(){
                          Navigator.of(context).pop();} , child: Text("ok"))
                      ]);
                });

              },) ,title:Text( "Code:   "+list1[i]['codes'].toString(),style: TextStyle(color: Colors.black54))),onTap: (){
            },));
          }) : Center(child: Text("there is no any farms"),),)
           , Positioned(left:MediaQuery.of(context).size.width -100,top: MediaQuery.of(context).size.height - 200 ,
                child: Container( width: 60,height: 60,decoration:  BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30))
                  ,child: IconButton(onPressed: (){
                    return showDialog(context: context, builder: (context) {
                      return AlertDialog(title:new Text("Add a farm"),
                          content:Form(key: key,
                            child: new Container(width: 200,height: 210,child: ListView(
                              children: [
                                new Text("add the code to promote adding a farm"),
                                new TextFormField(validator: validatepassword,controller:code ,decoration: InputDecoration(labelText: "code"),)
                                , new TextFormField(validator: validatename,controller:name ,decoration: InputDecoration(labelText: "farmname"))
                              ],
                            ),),
                          ),
                          actions: [
                            new ElevatedButton(onPressed:(){
                              Map<dynamic,dynamic> data = {
                                "code" : code.text,
                                "farmname" : name.text
                              };
                              add(data);} , child: Text("ok"))
                          ]);
                    });
                  }, icon: Icon(Icons.add,color: Colors.white,size: 35,),color: Colors.white,),))
    ],
        ),
      )


    );
  }


}