import 'dart:convert';
import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:mazrati/adding.dart';
import 'package:mazrati/delegate.dart';
import 'package:mazrati/loginpage.dart';
import 'package:mazrati/main.dart';
import 'package:http/http.dart' as http;
import 'package:mazrati/search.dart';
import 'package:mazrati/section2.dart';
import 'package:mazrati/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Section1 extends StatefulWidget{
  var username;
  Section1({this.username});
  @override
  State<StatefulWidget> createState() {
    return Star(username :username);
  }
}
class Star extends State<Section1>{
  var username;
  FirebaseApp app;
  Star({this.app,this.username});
  List marati =[];
  List farms =[];
  List finalwaqt=[];
  final ref = FirebaseDatabase.instance;
  var refrence;
  TextEditingController code = new TextEditingController();
  var url ="https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F29%2F0a%2Fb7%2F290ab74c1ba00ab4e1d7562f453c34a9.jpg&imgrefurl=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F753086368926193773%2F&tbnid=WKkryqfB7RI4sM&vet=12ahUKEwiHurqf4NDyAhXJtyoKHW36AisQMygBegUIARDMAQ..i&docid=KkU9BMz-iANSvM&w=1280&h=853&q=big%20houses&ved=2ahUKEwiHurqf4NDyAhXJtyoKHW36AisQMygBegUIARDMAQ#imgrc=WKkryqfB7RI4sM&imgdii=aAqV3vHLmBOVDM";
  void getdats() async{
    List farms =[];
    var url = "https://mazrati.000webhostapp.com/mazratietaha.php";
    var response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
    List data =body;
    for(int f =0; f<data.length ; f++) {
      List gg =
      data[f]["waqit"].toString().trim().substring(1, data[f]["waqit"]
          .toString()
          .length - 1).split(",");
      var kes = true;
      for (int i = 0; i < 30; i++) {
        if(kes) {
          for (int y = 0; y < gg.length; y++) {
            if (gg[y].toString().trim() ==
                DateTime.now().add(Duration(days: i)).toString()
                    .substring(0, 10)
                    .trim()) {
              farms.add(data[f]["farmname"]);
              kes =false;
              break;
            }
          }
        }
      }
    }
    marati.clear();
    var url2 = "https://mazrati.000webhostapp.com/mazrati2.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
    List data2 = body2;
    print(data2[0]["farmname"]);
    print(farms[0]);
    for(int y =0;y<data2.length;y++){
      for(int g =0 ; g<farms.length; g++) {
        if (data2[y]["farmname"].toString().trim() == farms[g].toString().trim()) {
          marati.add(data2[y]);
        }
      }
    }
    setState(() {});


  }

  String urlget(var url){
    return "https://mazrati.000webhostapp.com/"+url;
  }
  void getdata() async{
    await refrence.child("etaha").once().then((DataSnapshot data){
      if(data.value !=null){
        Map<dynamic,dynamic> datav = data.value;
        farms.clear();
        datav.forEach((key, value){
          var kes = true;
            List awqat = value.toString().substring(1,value.toString().length-1).split(",");
            for(int i = 0; i < 30; i++){
              if(kes) {
                for (int y = 0; y < awqat.length; y++) {
                  if (awqat[y].toString().trim() ==
                      DateTime.now().add(Duration(days: i)).toString()
                          .substring(0, 10)
                          .trim()) {
                    farms.add(key.toString());
                    print(farms);
                    kes =false;
                    break;
                  }
                }
              }
            }
        }); 
      }
    });
      await refrence.child("farms").once().then((DataSnapshot data) {
        Map<dynamic, dynamic> datav = data.value;
        datav.forEach((key, value) {
          for(int i =0; i<farms.length ;i++){
            if(value["farmname"].toString() ==farms[i].toString()){
              marati.add(value);
              setState(() {});
            }
          }
          print(marati[0]["money"]);
        });
      });

  }
  void deletes()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
      return MyApp();
    }));
  }
  getuser()async{
    if(username !=null){
      saved();
      getdats();
    }
    else{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      username = sharedPreferences.getString("username");
      getdats();
    }
  }
  void saved() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    sharedPreferences.setString("username", username.toString());
    print("okay");
  }
  @override
  void initState() {
    getuser();
    print(username);
    //getdats();
    //saved();
    //refrence = ref.reference();
    //getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(actions: [IconButton(icon: Icon(Icons.refresh), onPressed: getdats),IconButton(icon: Icon(Icons.search), onPressed: (){
      showSearch(context:context , delegate: delegate(listsuggest: marati));
    }),IconButton(icon: Icon(Icons.list), onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return Searchpage();}));})],title: Text("Mazre3na"),centerTitle: true,),
      body: Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,color: Colors.black12,
        child:username==null?Center(child: CircularProgressIndicator(),) :ListView(children: [
          Container(height: MediaQuery.of(context).size.height*0.1,child:ListTile(title: Container(alignment: Alignment.centerRight
              ,child: Text(": مزارعنا",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 25,color: Colors.blueAccent),)
          ),trailing: Icon(Icons.house,size: 35,color: Colors.blueAccent,),) ,),
          Container(height: MediaQuery.of(context).size.height * 0.80,child: marati.length ==0 ? Center(child:Text("ليس هناك مزارع حتى الان"),):
              Container(
              child: ListView.builder(itemCount: marati.length,itemBuilder: (context,i){
                return Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.05)
                  ,width: MediaQuery.of(context).size.width,height :MediaQuery.of(context).size.height*0.45,decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent),color: Colors.white,borderRadius: BorderRadius.circular(30)),
                  child:InkWell(focusColor: Colors.yellowAccent,child: Container(child :InkWell(onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){return  Section2(username: username,farmname: marati[i]["farmname"],);}));
                  }, child: Column(children: [
                    Container(margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02),width: MediaQuery.of(context).size.width  ,height: MediaQuery.of(context).size.height*0.30 ,child:ClipRRect(borderRadius: BorderRadius.circular(20),child: Image(fit: BoxFit.fill,image: NetworkImage(urlget(marati[i]["url1"])),)),)
                    ,Container(height:MediaQuery.of(context).size.height*0.12 ,child: Row(children: [Expanded(flex: 2,child: Container(alignment: Alignment.centerLeft,margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.07),
                      child: Column(children:[ Text("ابتداء من " +marati[i]["money"]+" دينار",style: TextStyle(fontSize: 20,color: Colors.blueAccent),),Text("تغير الأسعار حسب يوم الحجز",style: TextStyle(color: Colors.black54,fontSize: 17),)
                      ]),)) ,Expanded(child: Container(alignment: Alignment.center,child:  Column(children: [Text(marati[i]["farmname"],style: TextStyle(fontStyle: FontStyle.italic,fontSize: 22,color: Colors.black54),),
                      Container(margin: EdgeInsets.only(top: 10),alignment: Alignment.centerRight,child: Row(children: [Icon(Icons.star),Icon(Icons.star,color: Colors.blueAccent),Icon(Icons.star,color: Colors.blueAccent),Icon(Icons.star,color: Colors.blueAccent,)],))]),),)],)),
                  ],),
                  ),)),
                );
              }),
      ))],),
      )
      ,drawer: Drawer(child:ListView(children: [Container(height: MediaQuery.of(context).size.height*0.25,child: UserAccountsDrawerHeader(
        currentAccountPicture: Container(width: 200,height: 200,child: new CircleAvatar(
          radius: 100.0,
          backgroundImage: AssetImage("images/imagesa.png"),
          backgroundColor: const Color(0xFF778899), // for Network image
        ),),
      accountName: Container(margin: EdgeInsets.only(left: 20),child:username=="null"?Text("زائر") :Text(username)),),),
        ListTile(title: Text("تخصيص البحث"),leading: Icon(Icons.search_off_sharp),onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return Searchpage();}));},),
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
      Container(
        child:username == "null" ?Container(child:
          ListTile(title: Text("تسجيل الدخول"),leading: Icon(Icons.logout),onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return Loginpage();
            }));
          },),
        ) :ListTile(title: Text("تسجيل الخروج"),leading: Icon(Icons.logout),onTap: (){
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
        },),
      )]
      ),),
    );
  }
}