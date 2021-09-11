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
import 'package:http/http.dart' as http;
import 'package:mazrati/location.dart';
import 'package:mazrati/main_mazrati.dart';
import 'package:mazrati/mainpage.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class Adding extends StatefulWidget{
  var choosinglat;
  var username ="ahmads";
  var farmname ;
  List photos;
  File main;
  Adding({this.choosinglat,this.farmname,this.main,this.photos,this.username//,this.username,this.farmname
  });
  @override
  State<StatefulWidget> createState() {
   return Stateadd(newlat: choosinglat,username : username,farmname :farmname,photos:photos,main:main);
  }
}
class Stateadd extends State<Adding> with SingleTickerProviderStateMixin{
  var username ;
  var farmname ;
  File main;
  List photos;
  Stateadd({this.newlat,this.username,this.farmname,this.main,this.photos});
  final ref = FirebaseDatabase.instance;
  var refrence;
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
  Set<Marker> _marker = {};
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
  List urllist =[];
  File mainphoto;
  var pmam = "Am";
  var pmam2 = "Am";
  var pmam3 = "Am";
  var pmam4 = "Am";
 var time1= 0;
  Widget time(){
    return Text('$time1');
  }
  void time1r(){

  }
  Future addimage(File image,var imagename)async{
    String base = base64Encode(image.readAsBytesSync());
    var data = {"imagename":imagename+farmname+"+"+image.path.split("/").last,"imagebase":base};
    var url = "https://mazrati.000webhostapp.com/mazratiaddimage.php";
    var response = await http.post(Uri.parse(url), body: data);
    numofphotoup++;
    urllist.add(imagename+farmname+"+"+image.path.split("/").last);
    setState(() {});
  }
  Future add2() async{
    tabController.animateTo(6,duration: Duration(milliseconds: 1));
   await addimage(mainphoto, "1");
   for(int i =0 ; i<7;i++){
     await addimage(listphoto[i], (i+2).toString());
   }
   Map<dynamic,dynamic> data ={ "farmname" : farmname,
     "url1" : urllist[0],
     "url2" : urllist[1],
     "url3":  urllist[2] ,
     "url4": urllist[3],
     "url5": urllist[4],
     "url6": urllist[5],
     "url7": urllist[6],
     "url8": urllist[7],
     "place" : slected.toString(),
     "latlng" : newlat.toString(),
     "money" : money.text,
     "day1" : day1.text + pmam.toString(),
     "day2" : day2.text + pmam2.toString(),
     "day3" : day3.text + pmam3.toString(),
     "day4" : day4.text + pmam4.toString(),
     "nazil" : nazil.text,
     "msaha" : msaha.text,
     "numofpath": numofpath.text,
     "hajem" : hajm.text,
     "omiq" : omig.text,
     "descrip" :wasif.text,
     "mizat" : mizat.toString(),
     "phone" : phone.text.toString(),
     "phone1" :phone1.text.toString()
   };
   var url = "https://mazrati.000webhostapp.com/mazratiaddmazra2.php";
   var response = await http.post(Uri.parse(url), body: data);

  }
  Future add() async{
      for(int i =0 ; i < listphoto.length ;i++){
        if(i ==0){
            task =  FirebaseApi.upload(mainphoto,i,Farmname.text);
            setState(() {});
          final db =await  task.whenComplete(() => {});
          final url = await   db.ref.getDownloadURL();
          urllist.add(url);
          numofphotoup ++;
          setState(() {});
          task =  FirebaseApi.upload(listphoto[i],i+1,Farmname.text);
        setState(() {});
          final db2 = await task.whenComplete(() => {});
          final url2 = await   db.ref.getDownloadURL();
          urllist.add(url2);
            numofphotoup ++;
          setState(() {});
        }
        else{
          task =  FirebaseApi.upload(listphoto[i],i+1,Farmname.text);
          setState(() {});
          final db = await  task.whenComplete(() => {});
          final url = await   db.ref.getDownloadURL();
          urllist.add(url);
          numofphotoup ++;
          setState(() {});
          if(listphoto.length + 1 == numofphotoup){
            Map<dynamic,dynamic> data ={ "farmname" : Farmname.text,
              "url1" : urllist[0].toString(),
              "url2" : urllist[1].toString(),
              "url3": urllist[2].toString(),
              "place" : slected.toString(),
              "latlng" : newlat.toString(),
              "day1" : day1.text + pmam.toString(),
              "day2" : day1.text + pmam2.toString(),
              "day3" : day1.text + pmam3.toString(),
              "day4" : day1.text + pmam4.toString(),
              "nazil" : nazil.text,
              "msaha" : msaha.text,
              "numofpath": numofpath.text,
              "hajem" : hajm.text,
              "omiq" : omig.text,
              "descrip" :wasif.text,
              "mizat" : mizat.toString(),
              "phone" : phone.text.toString()
            };
            refrence.child("farms").child("username").set(data);
          }
        }

  }}
  void pic_photo() async{
    var image1 = await ImagePicker().pickMultiImage();
    if(image1 !=null){
      if(image1.length >7-listphoto.length || image1.length>7){
        return showDialog(context: context, builder: (context) {
          return AlertDialog(title: new Text("error"),
              content: new Text("لا يمكنك ادخال اكثر من 7 صور لذلك أعد المحاولة وتجنب اختيار اكثر من 7 صور"),
              actions: [new ElevatedButton(onPressed: (){
                  setState(() {
                    Navigator.of(context).pop();
                  });
                }, child: Text("ok")),
              ]);
        });
      }
      else {
        setState(() {
          image1.forEach((element) {
              listphoto.add(File(element.path));
              numphoto++;
          });
        });
      }
    }
  }
  void picmain() async{
    var imagemain =await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imagemain !=null){
      setState(() {
        mainphoto = File(imagemain.path);
      });
    }
  }
  void init() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    refrence = ref.reference();
  }
  TabController tabController ;
  @override
  void initState() {
    print(farmname);
    print(username);
    tabController = new TabController(vsync: this, length:7);
    if( main !=null&&photos.length >0){
      mainphoto = main;
      listphoto = photos;
      print(newlat);
      tabController.animateTo(3);
      print(username);
      print(farmname);
    }
    Farmname.text =farmname;
    init();
    super.initState();
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
       appBar: AppBar(title: Text("Mazre3na"),),
       body: TabBarView(physics: NeverScrollableScrollPhysics(),controller: tabController,children:[
         Form(key: keyfarmname,
           child: Center(child: Container(height: 250,child: Column(children :[Text("Mazre3na",style: TextStyle(fontSize: 50,fontStyle: FontStyle.italic,color: Colors.blueAccent),),
             Container(padding: EdgeInsets.only(left: 20),decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                 border: Border.all(color: Colors.blue)),
                 margin: EdgeInsets.all(10),
                 child: TextFormField(enabled: false,style: TextStyle(fontSize: 20),validator: farmnameval,controller: Farmname,
                   decoration: InputDecoration(prefixIcon: Icon(Icons.house_outlined),hintText: "Farm Name",border: InputBorder.none),)),
             ElevatedButton(onPressed: (){
             tabController.animateTo(1);

             }, child: Text("Next"))] ))),
         ), Center(child: Container(child: ListView(children: [
           Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.blue)), child: Text("اختر صورا من أجل مزرعتك",style: TextStyle(fontSize: 20),))),
         ElevatedButton(onPressed: (){picmain();}, child: Text("choose main photo")),
           Container(child:mainphoto !=null ? Container(decoration: BoxDecoration(border: Border.all(color: Colors.blue)),height: 200,width:MediaQuery.of(context).size.width,
                 child: Image(image: FileImage(mainphoto),)):null
           )
        ,ElevatedButton(onPressed: (){pic_photo();}, child: Text("choose else photos")),
           Container(child:listphoto.length ==0 ?null : Container(height: 250,width: MediaQuery.of(context).size.width,
               child: ListView.builder(scrollDirection: Axis.horizontal ,itemCount: listphoto.length,itemBuilder: (context,i){
                 return Container(width:150 ,decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent,width: 3)),
                   child: InkWell(child : Image(image: FileImage(listphoto[i]),),onTap: (){
                     return showDialog(context: context, builder: (context) {
                       return AlertDialog(title: new Text("delete"),
                           content: new Text("هل تريد حذف الصورة!"),
                           actions: [
                             new ElevatedButton(onPressed: (){
                               setState(() {
                                 listphoto.removeAt(i);
                                 numphoto --;
                                 Navigator.of(context).pop();
                               });
                             }, child: Text("ok")),

                             new ElevatedButton(onPressed: (){
                               setState(() {
                                 Navigator.of(context).pop();
                               });
                             }, child: Text("cancel")),
                           ]);
                     });
                   },),
                 );
               }),
             ),
           ),Center(child: Text(numphoto.toString() +"/7")),
           Container(margin: EdgeInsets.only(left: 10,right: 10),
             child: Row(children:[ Expanded(
               child: ElevatedButton(onPressed: (){tabController.animateTo(0);
               }, child: Text("Previuos")),
             ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
               if(mainphoto !=null){
                 if(listphoto.length ==7){
                  tabController.animateTo(2);
                 }else{
                   return showDialog(context: context, builder: (context) {
                     return AlertDialog(title: new Text("Warning"),
                         content: new Text("لا يمكنك الاكمال اذا لم تختر 7 صور فرعية للمزرعة!!"),
                         actions: [
                           new ElevatedButton(onPressed: (){
                             Navigator.of(context).pop();
                           }, child: Text("okay"))
                         ]);
                   });
                 }
               }
               else{
                 return showDialog(context: context, builder: (context) {
                   return AlertDialog(title: new Text("Warning"),
                       content: new Text("لا يمكنك الاكمال اذا لم تدخل الصورة الأساسية!!"),
                       actions: [
                         new ElevatedButton(onPressed: (){
                         Navigator.of(context).pop();
                           }, child: Text("okay"))
                       ]);
                 });
               }
               }, child: Text("Next")),
             )],),
           ),],),),)
         , Center(child: ListView(children: [
           Center(
             child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                 border: Border.all(color: Colors.blue)), child: Text("اختر الموقع المناسب لمزرعتك",style: TextStyle(fontSize: 20),)),
           ),Container(margin: EdgeInsets.all(20),padding: EdgeInsets.only(left: 20),
             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.blueAccent)),
             child: DropdownButton(
               items: location.map((e) => DropdownMenuItem(child: Text('$e'),value: e,)).toList(),onChanged: (val){
               setState(() {
                 slected =val;
               });
             },value: slected,),
           ), Container(margin: EdgeInsets.all(20),
             child: ElevatedButton(onPressed: (){
               Navigator.of(context).push(MaterialPageRoute(builder:(context){
                 return Location(slected: slected,latlng: LatLng(latlng[location.indexOf(slected)*2],latlng[location.indexOf(slected)*2 +1]),farmname: farmname,main: mainphoto,photos: listphoto,username:username);
              }));
             }, child: Text("اختر موقعك على الخريطة")),
           ),Container(margin: EdgeInsets.only(left: 10,right: 10),
             child: Row(children:[ Expanded(
               child: ElevatedButton(onPressed: (){tabController.animateTo(1);
               }, child: Text("Previuos")),
             ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
             if(newlat !=null){
             tabController.animateTo(3);
             }else{
               return showDialog(context: context, builder: (context) {
                 return AlertDialog(title: new Text("Warning"),
                     content: new Text("لا يمكنك الاكمال اذا لم تختر الموقع على الخريطة"),
                     actions: [
                       new ElevatedButton(onPressed: (){
                         Navigator.of(context).pop();
                       }, child: Text("okay"))
                     ]);
               });
             }
             }, child: Text("Next")),
             )],),
           )
         ],),),Form(key: keyday,child: Center(child: Container(margin: EdgeInsets.all(20),child: ListView(children: [
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
               }); },))] )),Row(children:[ Expanded(
         child: ElevatedButton(onPressed: (){tabController.animateTo(2);
     }, child: Text("Previuos")),
    ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
    if(keyday.currentState.validate()){
    tabController.animateTo(4);
    }
    }, child: Text("Next")),
    )],)
         ],),),)),Form(key: keydetail,child: Center(child:Container(margin: EdgeInsets.all(20),child: ListView(children: [ Center(
           child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
               border: Border.all(color: Colors.blue)), child: Text("مواصفات المزرعة",style: TextStyle(fontSize: 20),)),
         ),TextFormField(controller: money,validator: deatailval,keyboardType: TextInputType.number,decoration: InputDecoration(icon: Icon(Icons.monetization_on),hintText: ("السعر البدئي بالدينار")),)
           , TextFormField(controller: nazil,validator: deatailval,decoration: InputDecoration(icon: Icon(Icons.people),hintText: ("النزيل المفضل")),),
           TextFormField(controller: msaha,validator: deatailval,keyboardType: TextInputType.number,decoration: InputDecoration(icon: Icon(Icons.house),hintText: ("مساحة المزرعة")),),
           TextFormField(controller: numofpath,validator: deatailval,keyboardType: TextInputType.number,decoration: InputDecoration(icon: Icon(Icons.wc),hintText: ("عدد الحمامات")),),
           TextFormField(controller: hajm,validator: deatailval,keyboardType: TextInputType.number,decoration: InputDecoration(icon: Icon(Icons.pool),hintText: ("مساحة المسبح")),),
           TextFormField(controller: omig,validator: deatailval,keyboardType: TextInputType.number,decoration: InputDecoration(icon: Icon(Icons.pool_sharp),hintText: ("عمق المسبح")),),
           TextFormField(controller: wasif,validator: deatailval,decoration: InputDecoration(icon: Icon(Icons.description),labelText: "وصف"),maxLines: 4,maxLength: 300,minLines: 2,),
           Row(children:[ Expanded(
             child: ElevatedButton(onPressed: (){tabController.animateTo(3);
             }, child: Text("Previuos")),
           ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
             if(keydetail.currentState.validate()){
               tabController.animateTo(5);
             }
           }, child: Text("Next")),
           )],)],),) ,),),Form(key: phonekey,
             child: Center(child: Container(margin: EdgeInsets.all(20),child: ListView(children: [
                Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
         border: Border.all(color: Colors.blue)), child: Text("ميزات",style: TextStyle(fontSize: 20),)))
          , MultiSelectDialogField(
               items: features.map((e) => MultiSelectItem(e,e)).toList(),
               listType: MultiSelectListType.LIST,
               onConfirm: (values) {
                 mizat = values.toString();
               },
             ),  Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                 border: Border.all(color: Colors.blue)), child: Text("التواصل من داخل الأردن للحجز",style: TextStyle(fontSize: 20),))),
               TextFormField(controller: phone,validator: validateMobile,keyboardType: TextInputType.phone,decoration: InputDecoration(icon: Icon(Icons.phone),hintText: ("رقم التواصل")),),
               Center(child: Container(padding: EdgeInsets.all(15),margin: EdgeInsets.only(bottom: 20,top: 40),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                   border: Border.all(color: Colors.blue)), child: Text("التواصل من خارج الأردن للحجز",style: TextStyle(fontSize: 20),))),
               TextFormField(controller: phone1,validator: validateMobile,keyboardType: TextInputType.phone,decoration: InputDecoration(icon: Icon(Icons.phone),hintText: ("رقم التواصل")),),
               Container( margin: EdgeInsets.only(top: 30),
                 child: Row(children:[ Expanded(
                   child: ElevatedButton(onPressed: (){tabController.animateTo(4);
                   }, child: Text("Previuos")),
                 ), Expanded(child: Container(),),Expanded(child: ElevatedButton(onPressed: (){
                   if(phonekey.currentState.validate()){
                     return showDialog(context: context, builder: (context) {
                       return AlertDialog(title: new Text("Warning"),
                           content: new Text("هل أنت متأكد من اضافة المزرع"),
                           actions: [
                             new ElevatedButton(onPressed: (){
                               Navigator.of(context).pop();
                               add2();
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
           ),Scaffold(appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0.0,),
             body: Center(child: Container(width: MediaQuery.of(context).size.width*0.5,height : MediaQuery.of(context).size.width*0.5,decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),margin: EdgeInsets.all(40),child: Column(children: [Center(child: Text("يتم الان اعداد جميع المعلومات!")),Center(child: Text("$numofphotoup/"+(listphoto.length+1).toString() )),
         Container(child:numofphotoup == listphoto.length +1 ? Container() : Container(width: 50,height: 50,child: CircularProgressIndicator(),) ,),
         Container(child:numofphotoup == listphoto.length +1 ? ElevatedButton(onPressed: (){
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return Main_Maz();}));
         }, child: Text("done")):Container())], ),),),
           )

    ]
     ),
       );

  }
}


