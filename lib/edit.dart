import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazrati/firebase.dart';
import 'package:mazrati/location.dart';
import 'package:mazrati/mainpage.dart';
import 'package:http/http.dart'as http;
import 'package:mazrati/view.dart';
import 'package:mazrati/view2.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Editing extends StatefulWidget{
  var choosinglat;
  var data;
  Editing({this.choosinglat,this.data});
  @override
  State<StatefulWidget> createState() {
    return Stateadd(newlat: choosinglat,data : data);
  }
}
class Stateadd extends State<Editing> with SingleTickerProviderStateMixin{
  Stateadd({this.newlat,this.data});
  var data ;
  var farmname ="ahmad";
  Map<dynamic,dynamic> mapdata ={};
  var numofphotoedit =7;
  List urledit =[];
  var ubdated ;
  Map<dynamic,dynamic> datadel={
    "url2" : false,
    "url3" : false,
    "url4" : false,
    "url5" : false,
    "url6" : false,
    "url7" : false,
    "url8" : false,
        "image2" : null,
        "image3" : null,
        "image4" : null,
        "image5" : null,
        "image6" : null,
        "image7" : null,
        "image8" : null
  };
  bool url1 =false;
  final ref = FirebaseDatabase.instance;
  final refstor = FirebaseStorage.instance;
  var refrence;
  var refrencestor;
  static String farmnameval(String name){
    if(name.trim().isEmpty){
      return "لا يمكن أن يكون فارغ";
    }
    if(name.length <5){
      return  "لا يمكن أن يكون أقل من خمسة أحرف";
    }
    return null;
  }
  List marati =[];
  //Statev({this.farmname});
  void getdata() async{
      initdays();
      initmwasafat();
      initlast();
    setState(() {});
  }
  GlobalKey<FormState> keyfarmname = new GlobalKey<FormState>();
  var numofphotoup = 0;
  GlobalKey<FormState> keyday = new GlobalKey<FormState>();
  static String dayval(String val){
    if(val.trim().isEmpty){
      return "لا يمكنك ابقاءها فارغة!!";
    }
    else{
      return null;
    }
  }
  static String dayval1(String val){
    if(val.trim().isEmpty){
      return "لا يمكنك ابقاءها فارغة!!";
    }
    if(int.parse(val.trim()) > 12){
      return "لا يمكنك اختيار أكبر من رقم 12";
    }
    else{
      return null;
    }
  }
  GlobalKey<FormState> phonekey = new GlobalKey<FormState>();
  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'لا يمكنك ترك الرقم فارغ!';
    }
    else if (!regExp.hasMatch(value)) {
      return 'هذا الرقم غير صالح!';
    }
    return null;
  }
  String mizat;
  TextEditingController phone =new TextEditingController();
  TextEditingController phone1 =new TextEditingController();
  TextEditingController day1 =new TextEditingController();
  TextEditingController day2 =new TextEditingController();
  TextEditingController day3 =new TextEditingController();
  TextEditingController day4 =new TextEditingController();
  GlobalKey<FormState> keydetail = new GlobalKey<FormState>();
  static String deatailval(String val){
    if(val.trim().isEmpty){
      return "لا يمكنك ابقاءها فارغة!!";
    }
    else{
      return null;
    }
  }
  TextEditingController money =new TextEditingController();
  TextEditingController nazil =new TextEditingController();
  TextEditingController msaha =new TextEditingController();
  TextEditingController numofpath =new TextEditingController();
  TextEditingController hajm =new TextEditingController();
  TextEditingController omig =new TextEditingController();
  TextEditingController wasif =new TextEditingController();
  LatLng newlat;
  var task;
  var task2;
  TextEditingController Farmname = new TextEditingController();
  List features =["كراج","حديقة","مكيف","قرب لخدمات","بلكونة","حارس","سخان شمسي","تدفئة","موقد غاز","مفارش أسرة","ثلاجة","ميكروويف","غلاية","غسالة اوتوماتيكية"
    ,"ادوات تنظيف","جاكوزي","تراس", "بلكونة" ,"موقد خارجي","موقد داخلي", "بركة اطفال","بركة سباحة","منطقة شواء","عدة شواء","مواقف خارجية","مواقف داخلية","انترنت لاسلك,","سماعات بلوتوث",
    "سرير أريكة","كاميرات مراقبة" ,"سخان مياه","تلفاز" ,"ادوات مطبخ","تلفاز","طفاية حريق" ,"منطقة العاب اطفال" ,"طاولة بلياردو","مطبخ","مطبخ صغير","اسعافات اولية" ,"مولد طاقة في حالات طوارئ" ,
    "فلل متلاصقة""حدائقواسعة","زرب" ,"طاولة فوسبول","طاولة تنس", "ملعب كرة قدم"];
  int numphoto =0 ;
  int choose = 0;
  List listphoto =[];
  List latlng = [31.94971924939516, 35.90639370930733,32.28524276110467
    , 35.89164055708651,32.038431193139175
    , 35.720483044863435,31.568657342569814, 35.47077857275352,31.717261115462858, 35.790973479586796,
    32.33898426955392, 36.21423313327929,32.09752319271084, 35.95602978247593];
  List location = ["عمان","جرش","سلط","بحر لميت", " مأدبا","المفرق","بيرين"];
  Timer timer;
  var data2;
  var initialvalue=[];
  List urllist =[];
  File mainphoto;
  var pmam = "Am";
  var pmam2 = "Am";
  var pmam3 = "Am";
  var pmam4 = "Am";
  var urlmain;
  var time1= 0;
  Widget time(){
    return Text('$time1');
  }
  void time1r(){

  }TabController tabController ;
  void initdays(){
    String day11 = data[0]["day1"];
    day1.text = day11.substring(0,day11.length -2);
    pmam = day11.substring(day11.length-2,day11.length);
    String day22 = data[0]["day2"];
    day2.text = day22.substring(0,day22.length -2);
    pmam2 = day22.substring(day22.length-2,day22.length);
    String day33 = data[0]["day3"];
    day3.text = day33.substring(0,day33.length -2);
    pmam3 = day33.substring(day33.length-2,day33.length);
    String day44 = data[0]["day4"];
    day4.text = day44.substring(0,day44.length -2);
    pmam4 = day44.substring(day44.length-2,day44.length);
  }
  void editdays() {
    refrence.child("farms").child("username").child("day1").set(
        day1.text + pmam);
    refrence.child("farms").child("username").child("day2").set(
        day2.text + pmam2);
    refrence.child("farms").child("username").child("day3").set(
        day3.text + pmam3);
    refrence.child("farms").child("username").child("day4").set(
        day4.text + pmam4);
  }
  void initmwasafat(){
    money.text = data[0]["money"];
    nazil.text = data[0]["nazil"];
    wasif.text = data[0]["descrip"];
  }
  void editwasif(){
    refrence.child("farms").child("username").child("nazil").set(
        nazil.text);
    refrence.child("farms").child("username").child("descrip").set(
        wasif.text);
  }
  void initlast(){
    phone.text = data[0]["phone"];
    phone1.text = data[0]["phone1"];
    String strin = data[0]["mizat"];
    print(strin);
    String  newstrin = strin.substring(1,strin.length -1).trim();
    print(newstrin);
    List stro = newstrin.split(",");
    print(stro);
    for(int f=0;f<stro.length;f++){
      initialvalue.add(stro[f].toString().trim());
    }
    setState(() {});
  }
  File imagemaine;
  void editmain() async{
    var imagemain =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imagemain !=null){
      imagemaine = File(imagemain.path);
      tabController.animateTo(4,duration: Duration(milliseconds: 1));
      String basee = base64Encode(imagemaine.readAsBytesSync());
      var url = "https://mazrati.000webhostapp.com/mazratideleteimage.php";
      var response = await http.post(Uri.parse(url), body: {"imagename":urlmain});
      var url2 = "https://mazrati.000webhostapp.com/mazratiaddimage.php";
      var response2 = await http.post(Uri.parse(url2), body: {"imagename":"1"+data[0]["farmname"]+"+"+imagemaine.path.split("/").last,"imagebase":basee});
      var url3 = "https://mazrati.000webhostapp.com/mazratiimageedit.php";
      print(farmname);
      var response3 = await http.post(Uri.parse(url3), body: {"urlnum": "url1","imagename":"1"+data[0]["farmname"]+"+"+File(imagemain.path).path.split("/").last,"farmname":data[0]["farmname"]});
      tabController.animateTo(0,duration: Duration(milliseconds: 1));
      url1 =true;
      setState(() {});
    }
  }
  void editall()async{
    Map<dynamic,dynamic> datas={
      "farmname" : data[0]["farmname"],
      "day1" : day1.text + pmam.toString(),
      "day2" : day1.text + pmam2.toString(),
      "day3" : day1.text + pmam3.toString(),
      "day4" : day1.text + pmam4.toString(),
      "nazil" : nazil.text,
      "descrip" :wasif.text,
      "money" : money.text,
      "mizat" : mizat.toString(),
      "phone" : phone.text.toString(),
      "phone1" : phone1.text.toString()

    };
    print(mizat.toString());
    var ablo = true;
    var url2 = "https://mazrati.000webhostapp.com/mazrati2.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
    List data2 = body2;
    for(int y =0;y<data2.length;y++){
      if(data2[y]["farmname"] == data[0]["farmname"]){
        ablo =false;
        var url = "https://mazrati.000webhostapp.com/mazratidataedit.php";
        var response = await http.post(Uri.parse(url), body:datas);
      }
    }
    if(ablo==true){
      var url = "https://mazrati.000webhostapp.com/mazratidataedit2.php";
      var response = await http.post(Uri.parse(url), body:datas);
    }

  }
  void editlast(){
    if(mizat ==null){
      refrence.child("farms").child("username").child("mizat").set(initialvalue.toString());
    }
    else{
      refrence.child("farms").child("username").child("mizat").set(mizat);
    }
    refrence.child("farms").child("username").child("phone").set(phone.text);
  }
  String urlget(var url){
    return "https://mazrati.000webhostapp.com/"+url;
  }
  void init() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    refrence = ref.reference();
   // getdata();
  }
  @override
  void initState() {
    getdata();
    urlmain = data[0]["url1"];
    print(urlmain);
    for(int s =0; s<7;s++){
      urledit.add(data[0]["url"+(s+2).toString()]);
    }
    init();
    super.initState();
    tabController = new TabController(vsync: this, length:3);
  }
  Widget builds(UploadTask uploadTask) {
    return StreamBuilder<TaskSnapshot>(stream: uploadTask.snapshotEvents
        ,builder:(context ,snapshot){
          if(snapshot.hasData){
            var datas = snapshot.data.bytesTransferred/snapshot.data.totalBytes;
            return Text('$datas');
          }
          else{
            return Container();
          }
        } );
  }

  var slected = "عمان";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mazrati"),),
      body: TabBarView(physics: NeverScrollableScrollPhysics(),controller: tabController,children:[
        Form(key: keyday,child: Center(child: Container(margin: EdgeInsets.all(20),child: ListView(children: [
          Center(
            child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(top: 20),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue)), child: Text("الاستخدام اليومي",style: TextStyle(fontSize: 20),)),
          ),Container(margin: EdgeInsets.only(left: 20,right: 20),
            child: Row(children : [Expanded(flex: 2,child: TextFormField(validator: dayval1,controller:day1 ,decoration: InputDecoration(labelText: "توقيت الاستلام"),maxLength: 2,keyboardType: TextInputType.number,)),
              Expanded(child: DropdownButton(items: ["Pm","Am"].map((e) => DropdownMenuItem(child: Text('$e'),value: e,)).toList(),
                value: pmam,onChanged: (val){setState(() {
                  pmam = val;
                }); },))] ),
          ),Container( margin: EdgeInsets.only(left: 20,right: 20),child : Row(children : [Expanded(flex: 2,child: TextFormField(validator: dayval1,controller:day2 ,decoration: InputDecoration(labelText: "توقيت التسليم"),maxLength: 2,keyboardType: TextInputType.number,)),
            Expanded(child: DropdownButton(items: ["Pm","Am"].map((e) => DropdownMenuItem(child: Text('$e'),value: e,)).toList(),
              value: pmam2,onChanged: (val){setState(() {
                pmam2 = val;
              }); },))] ))
          ,Center(
            child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(top: 20),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue)), child: Text("المبيت",style: TextStyle(fontSize: 20),)),
          ),Container(margin: EdgeInsets.only(left: 20,right: 20),
            child: Row(children : [Expanded(flex: 2,child: TextFormField(validator: dayval1,controller:day3 ,decoration: InputDecoration(labelText: "توقيت الاستلام"),maxLength: 2,keyboardType: TextInputType.number,)),
              Expanded(child: DropdownButton(items: ["Pm","Am"].map((e) => DropdownMenuItem(child: Text('$e'),value: e,)).toList(),
                value: pmam3,onChanged: (val){setState(() {
                  pmam3 = val;
                }); },))] ),
          ),Container(margin: EdgeInsets.only(left: 20,right: 20),child : Row(children : [Expanded(flex: 2,child: TextFormField(validator: dayval1,controller:day4 ,decoration: InputDecoration(labelText: "توقيت التسليم"),maxLength: 2,keyboardType: TextInputType.number,)),
            Expanded(child: DropdownButton(items: ["Pm","Am"].map((e) => DropdownMenuItem(child: Text('$e'),value: e,)).toList(),
              value: pmam4,onChanged: (val){setState(() {
                pmam4 = val;
              }); },))] )),Row(children:[ Center(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
            if(keyday.currentState.validate()){
              tabController.animateTo(1);
            }
          }, child: Text("Next")),
          )],)
        ],),),)),Form(key: keydetail,child: Center(child:Container(margin: EdgeInsets.all(20),child: ListView(children: [ Center(
          child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue)), child: Text("مواصفات المزرعة",style: TextStyle(fontSize: 20),)),
        ),TextFormField(controller: money,validator: deatailval,keyboardType: TextInputType.number,decoration: InputDecoration(icon: Icon(Icons.monetization_on),hintText: ("السعر بالدينار")),),
          TextFormField(controller: nazil,validator: deatailval,decoration: InputDecoration(icon: Icon(Icons.people),hintText: ("النزيل المفضل")),),
          TextFormField(controller: wasif,validator: deatailval,decoration: InputDecoration(icon: Icon(Icons.description),labelText: "وصف"),maxLines: 4,maxLength: 300,minLines: 2,),
          Row(children:[ Expanded(
            child: ElevatedButton(onPressed: (){tabController.animateTo(0);
            }, child: Text("previous")),
          ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
            if(keydetail.currentState.validate()){
              tabController.animateTo(2);
            }
          }, child: Text("Next")),
          )],)],),) ,),),Form(key: phonekey,
          child: Center(child: Container(margin: EdgeInsets.all(20),child: ListView(children: [
            Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue)), child: Text("ميزات",style: TextStyle(fontSize: 20),)))
            , MultiSelectDialogField(
              items: features.map((e) => MultiSelectItem(e,e)).toList(),
              listType: MultiSelectListType.LIST,initialValue: initialvalue,
              onConfirm: (values) {
                mizat = values.toString();
              },
            ),  Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue)), child: Text("رقم التواصل من داخل الأردن",style: TextStyle(fontSize: 20),))),
            TextFormField(controller: phone,validator: validateMobile,keyboardType: TextInputType.phone,decoration: InputDecoration(icon: Icon(Icons.phone),hintText: ("رقم التواصل")),),
            Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue)), child: Text("رقم التواصل من خارج اللأردن",style: TextStyle(fontSize: 20),))),
            TextFormField(controller: phone1,validator: validateMobile,keyboardType: TextInputType.phone,decoration: InputDecoration(icon: Icon(Icons.phone),hintText: ("رقم التواصل")),),
            Container( margin: EdgeInsets.only(top: 30),
              child: Row(children:[ Expanded(
                child: ElevatedButton(onPressed:(){tabController.animateTo(1);
                }, child: Text("previous")),
              ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
                if(phonekey.currentState.validate()){
                  return showDialog(context: context, builder: (context) {
                    return AlertDialog(title: new Text("Warning"),
                        content: new Text("هل أنت متأكد من التعديلات"),
                        actions: [
                          new ElevatedButton(onPressed: ()async{
                           await editall();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Viewfarm2(farmname:data[0]["farmname"],);}));
                          }, child: Text("okay"))
                          ,new ElevatedButton(onPressed: (){
                            Navigator.of(context).pop();
                          }, child: Text("cancel"))
                        ]);
                  });
                }
              }, child: Text("finish")),
              )],),
            )],),),),
        )
      ]
      ));

  }
}
