import 'dart:convert';
import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mazrati/adding.dart';
import 'package:mazrati/search.dart';
import 'package:mazrati/section2.dart';
import 'package:mazrati/view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class Mainpage extends StatefulWidget{
  var username;
  Mainpage({this.username});
  @override
  State<StatefulWidget> createState() {
    return Star(username: username);
  }
}
class Star extends State<Mainpage>{
  FirebaseApp app;
  var username;
  Star({this.app,this.username});
  List marati =[];
  final ref = FirebaseDatabase.instance;
  var refrence;
  TextEditingController code = new TextEditingController();
  void checkcode2() async{
    bool available = false;
    bool available2 = true;
    var farmname;
    var url2 = "https://mazrati.000webhostapp.com/mazraticode.php";
    var response2 = await http.get(Uri.parse(url2));
    List body = jsonDecode(response2.body);
    var urlfarm = "https://mazrati.000webhostapp.com/mazrati2.php";
    var responsefarm = await http.get(Uri.parse(urlfarm));
    List bodyfarm = jsonDecode(responsefarm.body);
    for(int h =0; h<body.length; h++){
      if(body[h]["codes"]==code.text){
        farmname = body[h]["farmname"];
        available =true;
        for(int e =0 ;e<bodyfarm.length;e++){
          if(bodyfarm[e]["farmname"] == body[h]["farmname"]){
            available2 =false;
          }
        }
      }
    }
    if(available ==false ){
      return showDialog(context: context, builder: (context) {
        return AlertDialog(title: new Text("error"),
            content: new Text("هذا الكود غير موجود اصلا"),
            actions: [new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
            ]);
      });
    }
    else if(available ==true && available2 ==false){
      return showDialog(context: context, builder: (context) {
        return AlertDialog(title: new Text("error"),
            content: new Text("هذا الكود تم استخدامه مسبقا"),
            actions: [new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
            ]);
      });
    }
    else if(available ==true&&available2==true){
      Navigator.of(context,rootNavigator: true).pop('dialog');
      showDialog(context: context, builder: (context) {
        return AlertDialog(title: new Text("انتظر"),
            content: new Text("الرجاء الانتظار يتم الان تفعيل المزرعة"),
            actions: [new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
            ]);
      });
      var url = "https://mazrati.000webhostapp.com/mazrati22.php";
      var response = await http.get(Uri.parse(url));
      var body = jsonDecode(response.body);
      List data2 = body;
      for (int y = 0; y < data2.length; y++) {
        if(data2[y]["farmname"] ==farmname) {
          Map<dynamic,dynamic> data ={
            "username" : username,
            "farmname" : farmname,
            "url1" : data2[y]["url1"],
            "url2" : data2[y]["url2"],
            "url3":  data2[y]["url3"] ,
            "url4": data2[y]["url4"],
            "url5": data2[y]["url5"],
            "url6": data2[y]["url6"],
            "url7": data2[y]["url7"],
            "url8": data2[y]["url8"],
            "place" : data2[y]["place"],
            "latlng" : data2[y]["latlng"],
            "money" : data2[y]["money"],
            "money1" : data2[y]["money1"],
            "money2" : data2[y]["money2"],
            "money3" : data2[y]["money3"],
            "money4" : data2[y]["money4"],
            "money5" : data2[y]["money5"],
            "money6" : data2[y]["money6"],
            "money7" : data2[y]["money7"],
            "money8" : data2[y]["money8"],
            "money9" : data2[y]["money9"],
            "money10" : data2[y]["money10"],
            "money11" : data2[y]["money11"],
            "day1" : data2[y]["day1"],
            "day2" : data2[y]["day2"],
            "day3" : data2[y]["day3"],
            "day4" : data2[y]["day4"],
            "day5" : data2[y]["day5"],
            "day6" : data2[y]["day6"],
            "nazil" : data2[y]["nazil"],
            "msaha" : data2[y]["msaha"],
            "numofpath": data2[y]["numofpath"],
            "hajem" : data2[y]["hajem"],
            "omiq" : data2[y]["omiq"],
            "descrip" :data2[y]["descrip"],
            "mizat" :data2[y]["mizat"],
            "phone" : data2[y]["phone"],
            "phone1" : data2[y]["phone1"]
          };
          var url = "https://mazrati.000webhostapp.com/mazratiaddmazra.php";
          var response = await http.post(Uri.parse(url), body: data);
          getdata();
        }
      }

    }
  }
  void checkcode() async{
    bool available = false;
  await refrence.child("codes").once().then((DataSnapshot value){Map<dynamic,dynamic> codes =value.value;
    codes.forEach((key, value){
      if(value["code"] == code.text){
        available = true;
      }
    });
    if(!available){
      return showDialog(context: context, builder: (context) {
        return AlertDialog(title: new Text("error"),
            content: new Text("this code is not available"),
            actions: [new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
            ]);
      });
    }else{
     // Navigator.of(context).push(MaterialPageRoute(builder: (context){return Adding(username:"username");}));
    }
  });
  }
  var url ="https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F29%2F0a%2Fb7%2F290ab74c1ba00ab4e1d7562f453c34a9.jpg&imgrefurl=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F753086368926193773%2F&tbnid=WKkryqfB7RI4sM&vet=12ahUKEwiHurqf4NDyAhXJtyoKHW36AisQMygBegUIARDMAQ..i&docid=KkU9BMz-iANSvM&w=1280&h=853&q=big%20houses&ved=2ahUKEwiHurqf4NDyAhXJtyoKHW36AisQMygBegUIARDMAQ#imgrc=WKkryqfB7RI4sM&imgdii=aAqV3vHLmBOVDM";
    void getdata() async{
      marati.clear();
      var url2 = "https://mazrati.000webhostapp.com/mazrati2.php";
      var response2 = await http.get(Uri.parse(url2));
      var body2 = jsonDecode(response2.body);
      List data2 = body2;
      for(int y =0;y<data2.length;y++){
        if(data2[y]["username"] == username){
          marati.add(data2[y]);
        }
      }
      setState(() {});
    }
    String urlget(var url){
      return "https://mazrati.000webhostapp.com/"+url;
    }
    getuser()async{
      if(username ==null) {
        SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
        username = sharedPreferences.getString("username");
        saved();
      }
      saved();
      getdata();
    }
  void saved() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setString("username", username.toString());
    print("okay");
  }
  void deletes()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
      return MyApp();
    }));
  }
  @override
  void initState() {
        getuser();
    //refrence = ref.reference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Mazare3na"),centerTitle: true,actions: [IconButton(icon: Icon(Icons.refresh), onPressed: getdata)],),
      body: Container(
        child:username ==null?Center(child: CircularProgressIndicator(),) :Stack(children: [Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,color: Colors.black12,
        child: ListView(children: [
   Container(height: MediaQuery.of(context).size.height*0.1,child:ListTile(title: Container(alignment: Alignment.centerRight
                ,child: Text(": مزارعي",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 25,color: Colors.blueAccent),)
            ),trailing: Icon(Icons.house,size: 35,color: Colors.blueAccent,),) ,) ,
          Container(height: MediaQuery.of(context).size.height * 0.80,child: marati.length ==0 ? Center(child:Text("ليس هناك مزارع حتى الان"),):
          Container(
            child: ListView.builder(itemCount: marati.length,itemBuilder: (context,i){
              return Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.05)
              ,width: MediaQuery.of(context).size.width,height :MediaQuery.of(context).size.height*0.45,decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent),color: Colors.white,borderRadius: BorderRadius.circular(30)),
                child:InkWell(focusColor: Colors.yellowAccent,child: Container(child :InkWell(onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){return  Viewfarm(farmname: marati[i]["farmname"],username: username,);}));
                }, child: Column(children: [
                  Container(margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02),width: MediaQuery.of(context).size.width  ,height: MediaQuery.of(context).size.height*0.30 ,child:ClipRRect(borderRadius: BorderRadius.circular(20),child: Image(fit: BoxFit.fill,image: NetworkImage(urlget(marati[i]["url1"])),)),)
                  ,Container(height:MediaQuery.of(context).size.height*0.12 ,child: Row(children: [Expanded(flex: 2,child: Container(alignment: Alignment.centerLeft,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.07),
                    child: Column(children:[ Text("ابتداء من " +marati[i]["money"]+" دينار",style: TextStyle(fontSize: 20,color: Colors.blueAccent),),Text("تغير الأسعار حسب يوم الحجز",style: TextStyle(color: Colors.black54,fontSize: 17),)
                    ]),)) ,Expanded(child: Container(alignment: Alignment.center,child:  Column(children: [Text(marati[i]["farmname"],style: TextStyle(fontStyle: FontStyle.italic,fontSize: 22,color: Colors.black54),),
                  Container(margin: EdgeInsets.only(top: 10),alignment: Alignment.centerRight,child: Row(children: [Icon(Icons.all_inclusive_sharp,color: Colors.blueAccent),Icon(Icons.all_inclusive_sharp,color: Colors.blueAccent),Icon(Icons.all_inclusive_sharp,color: Colors.blueAccent,),Icon(Icons.all_inclusive_sharp,color: Colors.blueAccent,)],))]),),)],)),
                ],),
                ),)),
              );
            }),
          ))],),
    ),Positioned(top: MediaQuery.of(context).size.height /1.4,left:MediaQuery.of(context).size.width /1.4 ,
          child: Container( width: 60,height: 60,decoration:  BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(30))
            ,child: IconButton(onPressed: (){
              return showDialog(context: context, builder: (context){
                return AlertDialog(title: Directionality(textDirection: ui.TextDirection.rtl,child: Text("اضافة مزرعة جديدة لهذا الحساب")),
                  content: Container(height:MediaQuery.of(context).size.height*0.3 ,child: Column(children: [
                    Directionality(textDirection: ui.TextDirection.rtl,child: Text("في البداية يجب أن تمتلك الكود الخاص لاضافة المزرعة")),
                    TextFormField(controller: code,decoration: InputDecoration(hintText: "the code"),)
                  ],),),actions: [
                    TextButton(onPressed: (){return checkcode2();}, child: Text("enter")),
                    TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("cancel"))
                  ],);
              });
            }, icon: Icon(Icons.add,color: Colors.white,size: 35,),color: Colors.white,),),
        )
        ],),
      )
      ,drawer: Drawer(child:ListView(children: [Container(height: MediaQuery.of(context).size.height*0.25,child: UserAccountsDrawerHeader(
        currentAccountPicture: Container(width: 200,height: 200,child: new CircleAvatar(
          radius: 100.0,
          backgroundImage: AssetImage("images/imagesa.png"),
          backgroundColor: const Color(0xFF778899), // for Network image
        ),),
        accountName: Container(margin: EdgeInsets.only(left: 20),child:username==null?Text("null") :Text(username)),),),
        ListTile(title: Text("تواصل معنا"),leading: Icon(Icons.phone_iphone_rounded),onTap: (){
          return showDialog(context: context, builder: (context) {
            return AlertDialog(title: new Text("تواصل معنا"),
                content: new Container(width: MediaQuery.of(context).size.width *0.1,height:MediaQuery.of(context).size.height *0.2 ,child: Column(children: [
                  Directionality(textDirection: ui.TextDirection.rtl, child: Text("يمكن التواصل مع صاحب التطبيق على هذا الرقم "),),
                  Directionality(textDirection: ui.TextDirection.ltr, child: Text("0779881737"),),
                ],),),
                actions: [
                  new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))
                ]);
          });
        },),
        ListTile(title: Text("تسجيل الخروج"),leading: Icon(Icons.logout),onTap: (){
          return showDialog(context: context, builder: (context) {
          return AlertDialog(title: new Text("تحذير!!"),
              content: new Text("هل أنت متأكد من الخروج؟؟"),
              actions: [
                new ElevatedButton(onPressed: (){
                  deletes();
                }, child: Text("ok")),
                new ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("cancel"))
              ]);
        });
        },)]
      ),),
    );
  }


}
