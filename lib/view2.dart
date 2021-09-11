import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazrati/dates.dart';
import 'package:mazrati/edit.dart';
import 'package:http/http.dart' as http;
import 'package:mazrati/editimage.dart';
import 'package:mazrati/main_mazrati.dart';
import 'package:mazrati/mainpage.dart';
import 'package:mazrati/specificloc.dart';

class Viewfarm2 extends StatefulWidget{
  var farmname ;
  //var username;
  Viewfarm2({this.farmname});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Statev(farmname : farmname);
  }

}
class Statev extends State<Viewfarm2>{
  final ref = FirebaseDatabase.instance;
  var refrence;
  LatLng lato;
  var url ="https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F29%2F0a%2Fb7%2F290ab74c1ba00ab4e1d7562f453c34a9.jpg&imgrefurl=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F753086368926193773%2F&tbnid=WKkryqfB7RI4sM&vet=12ahUKEwiHurqf4NDyAhXJtyoKHW36AisQMygBegUIARDMAQ..i&docid=KkU9BMz-iANSvM&w=1280&h=853&q=big%20houses&ved=2ahUKEwiHurqf4NDyAhXJtyoKHW36AisQMygBegUIARDMAQ#imgrc=WKkryqfB7RI4sM&imgdii=aAqV3vHLmBOVDM";
  var farmname ;
  Statev({this.farmname});
  var string ="افادت وزارة الصحة في العاصمة الافغانية كابول ان حصيلة القتلى في واقعة التفجير قرب مطار كابول، أمس، الخميس، ارت";
  List marati =[];
  String urlget(var url){
    return "https://mazrati.000webhostapp.com/"+url;
  }
  void getlatlang(var latlng){
    List g= marati[0]["latlng"].toString().substring(7,marati[0]["latlng"].toString().length-1).trim().split(",");
    lato = LatLng(double.parse(g[0]),double.parse(g[1]));
  }
  //Statev({this.farmname});
  void getdata() async{
    print(farmname);
    marati.clear();
    var url2 = "https://mazrati.000webhostapp.com/mazrati2.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
    List data2 = body2;
    for(int y =0;y<data2.length;y++){
      if(data2[y]["farmname"] == farmname){
        marati.add(data2[y]);
      }
    }
    if(marati.length == 0){
      marati.clear();
      var url3 = "https://mazrati.000webhostapp.com/mazrati22.php";
      var response3 = await http.get(Uri.parse(url3));
      var body3 = jsonDecode(response3.body);
      List data2 = body3;
      for(int y =0;y<data2.length;y++){
        if(data2[y]["farmname"] == farmname){
          marati.add(data2[y]);
        }
      }
    }
    //print(marati[0]["latlng"].toString().substring(7,marati[0]["latlng"].toString().length-1));
    getlatlang(marati[0]["latlng"]);
    setState(() {});
  }
  void viewfeat(){
    String strin = marati[0]["mizat"];
    if(strin =="null"){
      showDialog(context: context, builder: (context) {
        return AlertDialog(title: Text("الميزات الاضافية"),actions: [ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))],
          content: new Container(width: 100,height: 100,child:Text("لا يوجد ميزات مضافة من قبل صاحب المزرعة")),);
      });
    }
    else{
      String  newstrin = strin.substring(1,strin.length -1);
      List stro = newstrin.split(",");
      showDialog(context: context, builder: (context) {
        return AlertDialog(title: Text("الميزات الاضافية"),actions: [ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("ok"))],
          content: new Container(width: 100,height: 100,child:ListView.builder(itemCount:stro.length,itemBuilder: (context,i){
            return ListTile(trailing: Icon(Icons.data_usage),title: Text(stro[i]),);
          }),),);
      });
    }}
  void view(){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Container(width: MediaQuery.of(context).size.width*0.50,height:MediaQuery.of(context).size.height*0.40,
          child: new Column(children:[Container(child: Text("اضغط على الصورة لتكبيرها "),),Container(width: MediaQuery.of(context).size.width*0.50,height:MediaQuery.of(context).size.height*0.35,
            child: ListView.builder(scrollDirection: Axis.horizontal,itemCount: 7,itemBuilder: (context,i){
              return InkWell(onTap: (){
                showDialog(context: context, builder: (context) {
                  return AlertDialog(content:Container(width: MediaQuery.of(context).size.width *0.8,height:MediaQuery.of(context).size.height *0.8 ,child:Image(fit: BoxFit.fill, image: NetworkImage(urlget(marati[0]["url"+(i+2).toString()]))),)
                    ,actions: [ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("okay"))],);
                });
              },child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                margin: EdgeInsets.all(10),child:Image(image: NetworkImage(urlget(marati[0]["url"+(i+2).toString()]))),),);
            }),
          )],),
        ),actions: [ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("okay"))],);
    });

  }
  @override
  void initState() {
    refrence = ref.reference();
    getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Container(
      child:marati.length==0?Center(child: CircularProgressIndicator(),) :Container(height: MediaQuery.of(context).size.height,child: Stack(children: [
        Stack(children:[ Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.35,child: ClipRRect(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0)),child: Image(fit: BoxFit.fill,image: NetworkImage(urlget(marati[0]["url1"])),)),)
          ,Container(margin: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.02),child: IconButton(icon: Icon(Icons.arrow_back,color: Colors.indigo,size: MediaQuery.of(context).size.height * 0.1,), onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Main_Maz();}));
          }))])
        ,Positioned(top: MediaQuery.of(context).size.height * 0.32,child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(15))),height: MediaQuery.of(context).size.height -175,width: MediaQuery.of(context).size.width,child:ListView(shrinkWrap:true,children: [
          Container(alignment: Alignment.centerRight,child: Row( children: [Expanded(flex: 3,child: Container(alignment: Alignment.centerRight,child: InkWell(onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context){return specLocation(latlng: marati[0]["latlng"],slected: marati[0]["place"]);}));},child:  Text("الذهاب للموقع",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)))),
            Expanded(child:  Icon(Icons.map,size: 25,color: Colors.blueAccent,)),Expanded(flex: 3,child: Container(alignment: Alignment.centerRight,child: ListTile(leading:Text(marati[0]["farmname"],style: TextStyle(fontSize: 22),) ,title:Transform.translate(offset: Offset(-16, 0),child: Icon(Icons.location_on_rounded,size: 27,)) )))],) )
          , Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.photo_sharp,color: Colors.blue,),title: Container(alignment: Alignment.centerRight,child: ElevatedButton(onPressed: view,child: Text("عرض كامل الصور",style: TextStyle(fontSize: 20,color: Colors.white),)))),)
          ,Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.description),title: Container(alignment: Alignment.centerRight,child: Text(": الوصف",style: TextStyle(fontSize: 25,color: Colors.blueAccent),))),)
          ,Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text(marati[0]["descrip"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.data_usage),title: Container(alignment: Alignment.centerRight,child: Text(":الاستخدام اليومي",style: TextStyle(fontSize: 25,color: Colors.blueAccent),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text("توقيت الاستلام-"+marati[0]["day1"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),)),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text("توقيت التسليم-"+marati[0]["day2"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.data_usage),title: Container(alignment: Alignment.centerRight,child: Text(": المبيت ",style: TextStyle(fontSize: 25,color: Colors.blueAccent),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text("توقيت الاستلام-"+marati[0]["day3"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),)),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text("توقيت التسليم-"+marati[0]["day4"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.details),title: Container(alignment: Alignment.centerRight,child: Text(": مواصفات المزرعة ",style: TextStyle(fontSize: 25,color: Colors.blueAccent),))),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.people,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": النزيل المفضل ",style: TextStyle(fontSize: 20,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text(marati[0]["nazil"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.house,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": مساحة المزرعة ",style: TextStyle(fontSize: 20,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text(marati[0]["msaha"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.house,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": عدد الحمامات ",style: TextStyle(fontSize: 20,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text(marati[0]["numofpath"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.pool,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": حجم المسبح ",style: TextStyle(fontSize: 20,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text(marati[0]["hajem"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.pool,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": عمق المسبح ",style: TextStyle(fontSize: 20,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.rtl,child: Text(marati[0]["omiq"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.phone,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": رقم التواصل من داخل الاردن",style: TextStyle(fontSize: 17,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60,bottom: 20),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.ltr,child: Text(marati[0]["phone"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20),child: ListTile(trailing: Icon(Icons.phone,size: 20,color: Colors.blueAccent,),title: Container(alignment: Alignment.centerRight,child: Text(": رقم التواصل من خارج الاردن ",style: TextStyle(fontSize: 17,color: Colors.black),))),),
          Container(margin: EdgeInsets.only(right: 60,bottom: 20),alignment: Alignment.centerRight,child: Directionality(textDirection: TextDirection.ltr,child: Text(marati[0]["phone1"],style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,color: Colors.black54),)),),
          Container(margin: EdgeInsets.only(right: 20,bottom: 20),child: ListTile(trailing: Icon(Icons.featured_play_list_sharp),title: Container(alignment: Alignment.centerRight,child: ElevatedButton(onPressed: viewfeat,child: Text("ميزات اضافية",style: TextStyle(fontSize: 20,color: Colors.white),)))),),
          Container(margin: EdgeInsets.only(bottom: 80),
            child: Center(child:  ElevatedButton(onPressed: (){
              //Navigator.of(context).push(MaterialPageRoute(builder: (context){return Editing(data: marati,);}));
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("تعديل"),
                    content: Container(child: Row(children: [Expanded(
                      child: Container(margin: EdgeInsets.only(left: 10,right: 10),
                        child: Expanded(child:ElevatedButton(onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){return Editing(data: marati,);}));},
                          child: Text("تعديل بيانات "),)),
                      ),
                    ),Expanded(
                        child: Container(margin: EdgeInsets.only(left: 10,right: 10),child: Expanded(child:ElevatedButton(onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){return Editimage(data: marati,);}));},
                          child: Text("تعديل الصور "),)),
                        )),])),
                    actions: [
                      new ElevatedButton(onPressed: (){
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }, child: Text("cancel")),
                    ]);
              });
            }, child: Text("تعديل")),
            ),),
        ],),))
      ],),),
    ),);
  }

}