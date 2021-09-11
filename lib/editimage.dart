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
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Editimage extends StatefulWidget{
  var data;
  Editimage({this.data});
  @override
  State<StatefulWidget> createState() {
    return Stateadd(data : data);
  }
}
class Stateadd extends State<Editimage> with SingleTickerProviderStateMixin{
  Stateadd({this.newlat,this.data});
  var data;
  List urledit =[];
  Map<dynamic,dynamic> datadel={
    "url1" : false,
    "url2" : false,
    "url3" : false,
    "url4" : false,
    "url5" : false,
    "url6" : false,
    "url7" : false,
    "url8" : false,
    "image1":null,
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
  TabController tabController ;
  void picedit(int i) async{
    var imagemain =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imagemain !=null){
      var url = "https://mazrati.000webhostapp.com/mazratideleteimage.php";
      var response = await http.post(Uri.parse(url), body: {"imagename":data[0]["url"+(i+2).toString()]});
      datadel["image"+(i+2).toString()] = File(imagemain.path);
      tabController.animateTo(1,duration: Duration(milliseconds: 1));
      String basee = base64Encode(datadel["image"+(i+2).toString()].readAsBytesSync());
      var url2 = "https://mazrati.000webhostapp.com/mazratiaddimage.php";
      var response2 = await http.post(Uri.parse(url2), body: {"imagename":(i+2).toString()+data[0]["farmname"]+"+"+File(imagemain.path).path.split("/").last,"imagebase":basee});
      var url3 = "https://mazrati.000webhostapp.com/mazratiimageedit.php";
      var response3 = await http.post(Uri.parse(url3), body: {"urlnum":"url"+(i+2).toString(),"imagename":(i+2).toString()+data[0]["farmname"]+"+"+File(imagemain.path).path.split("/").last,"farmname":data[0]["farmname"]});
      urledit[i] = (i+2).toString()+data[0]["farmname"];
      tabController.animateTo(0,duration: Duration(milliseconds: 1));
      datadel["url"+(i+2).toString()] = true;
      setState(() {});
    }
  }



  File omge;
  void uplo(File omo)async{
    String basee = base64Encode(omo.readAsBytesSync());
    var url = "https://mazrati.000webhostapp.com/mazratideleteimage.php";
    var response = await http.post(Uri.parse(url), body: {"imagename":urlmain});
    var url2 = "https://mazrati.000webhostapp.com/mazratiaddimage.php";
    var response2 = await http.post(Uri.parse(url2), body: {"imagename":"1"+data[0]["farmname"]+"+"+omo.path.split("/").last,"imagebase":basee});
    var url3 = "https://mazrati.000webhostapp.com/mazratiimageedit.php";
    var response3 = await http.post(Uri.parse(url3), body: {"urlnum": "url1","imagename":"1"+data[0]["farmname"]+"+"+omo.path.split("/").last,"farmname":data[0]["farmname"]});
  }
  void editmain() async{
    var imagemain =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imagemain !=null){
      datadel["image1"] = File(imagemain.path);
      datadel["url1"] =true;
      setState(() {});
      var url = "https://mazrati.000webhostapp.com/mazratideleteimage.php";
      var response = await http.post(Uri.parse(url), body: {"imagename":urlmain});
      tabController.animateTo(1);
      String basee = base64Encode(datadel["image1"].readAsBytesSync());
      var url2 = "https://mazrati.000webhostapp.com/mazratiaddimage.php";
      var response2 = await http.post(Uri.parse(url2), body: {"imagename":"1"+data[0]["farmname"]+"+"+File(imagemain.path).path.split("/").last,"imagebase":basee});
      var url3 = "https://mazrati.000webhostapp.com/mazratiimageedit.php";
      var response3 = await http.post(Uri.parse(url3), body: {"urlnum": "url1","imagename":"1"+data[0]["farmname"]+"+"+File(imagemain.path).path.split("/").last,"farmname":data[0]["farmname"]});
      tabController.animateTo(0);
    }
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
    urlmain = data[0]["url1"];
    print(urlmain);
    for(int s =0; s<7;s++){
      urledit.add(data[0]["url"+(s+2).toString()]);
    }
    init();
    super.initState();
    tabController = new TabController(vsync: this, length:2);
  }
  var slected = "عمان";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mazrati"),),
        body: TabBarView(physics: NeverScrollableScrollPhysics(),controller: tabController,children:[Center(child: Container(child: ListView(children: [
          Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.blue)), child: Text("اختر صورا من أجل مزرعتك",style: TextStyle(fontSize: 20),))),
          Center(child: Text("الصورة الاساسية"),)
          ,Center(child:Container(child : datadel["url1"]==true?Container(
            height: MediaQuery.of(context).size.height*0.5,child: Column(children: [Container(
              height: MediaQuery.of(context).size.height*0.40,child: Image(image: FileImage(datadel["image1"]),)),ElevatedButton(onPressed: (){editmain();}, child:Text("Edit"))],),)
              :Container(
            height: MediaQuery.of(context).size.height*0.5,child: Column(children : [Container(
              height: MediaQuery.of(context).size.height*0.40,child: Image(fit: BoxFit.fill,image: NetworkImage(urlget(urlmain)),)),ElevatedButton(onPressed: (){editmain();}, child:Text("Edit"))] ),),))
        // ,Container(child: Container(child : datadel==true?Container(child: Text("changed",style: TextStyle(fontSize: 40),)):Container()),)
          ,Center(child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue)),width: MediaQuery.of(context).size.width,height: 300,child: ListView.builder(itemCount: urledit.length,itemBuilder: (context,i){
            return Container(child: Container(child:datadel["url"+(i+2).toString()] ==true?  Container(child: Container(width: 200,height:400 ,child: Column(children: [Container(width: 200,height:200,child: Image(image: FileImage(datadel["image"+(i+2).toString()]))),ElevatedButton(onPressed: (){picedit(i);}, child:Text("Edit"))],),))
                :Container(child: Container(width: 200,height:400 ,child: Column(children:[ Container(width: 200,height:200,child: Image(image: NetworkImage(urlget(urledit[i])))),ElevatedButton(onPressed: (){picedit(i);}, child:Text("Edit"))]),))));
          },scrollDirection: Axis.horizontal),),),
          ElevatedButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Viewfarm(farmname:data[0]["farmname"],);}));
          }, child:Text("okay"))
        ]))),Center(child: Container(margin: EdgeInsets.all(40),child: Column(children: [Center(child: Text("يتم الان تحميل الصورة!")),Center(child: Text("0/"+"1" )),
            Container(child:  Container(width: 50,height: 50,child: CircularProgressIndicator(),) ,)], ),),)

        ]
        ));

  }
}