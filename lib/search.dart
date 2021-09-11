import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:mazrati/section1.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'delegate.dart';

class Searchpage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Statesearch();
  }
}
class Statesearch extends State<Searchpage>{
  final ref = FirebaseDatabase.instance;
  var refrence;
  List dataa =[];
  List search1 =[];
  List search2 =[];
  List search3 =[];
  List search4 =[];
  List features =["كراج","حديقة","مكيف","قرب لخدمات","بلكونة","حارس","سخان شمسي","تدفئة","موقد غاز","مفارش أسرة","ثلاجة","ميكروويف","غلاية","غسالة اوتوماتيكية"
    ,"ادوات تنظيف","جاكوزي","تراس", "بلكونة" ,"موقد خارجي","موقد داخلي", "بركة اطفال","بركة سباحة","منطقة شواء","عدة شواء","مواقف خارجية","مواقف داخلية","انترنت لاسلك,","سماعات بلوتوث",
    "سرير أريكة","كاميرات مراقبة" ,"سخان مياه","تلفاز" ,"ادوات مطبخ","تلفاز","طفاية حريق" ,"منطقة العاب اطفال" ,"طاولة بلياردو","مطبخ","مطبخ صغير","اسعافات اولية" ,"مولد طاقة في حالات طوارئ" ,
    "فلل متلاصقة""حدائقواسعة","زرب" ,"طاولة فوسبول","طاولة تنس", "ملعب كرة قدم"];
  List mizat=[];
  var text1 =DateTime.now().toString().substring(0,10);
  var text21 =DateTime.now().toString().substring(0,10);
  var text22 =DateTime.now().add(Duration(days: 1)).toString().substring(0,10);
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  var check =false;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
       text21 = _range.split("-")[0];
       text22 =_range.split("-")[1];
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
  bool  check1 = false;
  List modn=[];
  String value="yawmi";
  var datevalue;
  void getdataserch1s() async{
    var url2 = "https://mazrati.000webhostapp.com/mazrati2.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
    List data2 = body2;
    for(int j= 0 ;j<data2.length;j++){
      for(int r =0 ; r<modn.length ; r++){
        if(data2[j]["place"].toString() == modn[r]){
          search1.add(data2[j]);
        }
      }
    }
  }
  void getdatasersh1()async{
    await refrence.child("farms").once().then((DataSnapshot data){
      if(data.value !=null){
        Map<dynamic,dynamic> datas =data.value;
        datas.forEach((key, value) {
          for(int r =0 ; r<modn.length ; r++){
            if(value["place"].toString() == modn[r]){
              search1.add(value);
            }
          }
        });
      }
    });
  }
  String reversetexts(String text){
    return text.split("/")[2].trim() +"-"+ text.split("/")[1].trim()+"-"+text.split("/")[0].trim();
  }
  bool func(List times ,List values ){
    var change =true;
    var dif =false;
    for(int s1 =0 ; s1 < times.length ;s1++){
      if(change){
        change =false;
        for(int s2 =0 ; s2 <values.length ; s2++){
          if(times[s1].toString().trim() == values[s2].toString().trim()){
            change =true;
            if(s1 == times.length-1&& change ==true){
              dif =true;
            }
            break ;
          }
        }
      }else{
        break;
      }
    }
    return dif;
  }
  bool funcmizat(List mizat ,List values){
    var change =true;
    var dif =false;
    for(int s1 =0 ; s1 < mizat.length ;s1++){
      if(change){
        change =false;
        for(int s2 =0 ; s2 <values.length ; s2++){
          if(mizat[s1].toString().trim() == values[s2].toString().trim()){
            change =true;
            if(s1 == mizat.length-1&& change ==true){
              dif =true;
            }
            break ;
          }
        }
      }else{
        break;
      }
    }
    return dif;
  }
  void getdataserch2s(bool modn) async{
    var url2 = "https://mazrati.000webhostapp.com/mazratietaha.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
    List data2 = body2;
    print(data2);
    if(value =="mabit"){
      List times =[];
      var ys =true;
      int s =0;
      while(ys){
        if(DateTime.parse(reversetexts(text21)).add(Duration(days: s)).toString().substring(0,10) !=reversetexts(text22)){
          DateTime dat =DateTime.parse(reversetexts(text21)).add(Duration(days: s));
          times.add(dat.toString().substring(0,10));
        }
        else{
          times.add(reversetexts(text22));
          ys=false;
        }
        s++;
      }
      print("value :" + times.toString());
      for(int m=0 ; m<data2.length;m++){
        if(modn){
          for(int a =0; a< search1.length ; a++){
            if(data2[m]["farmname"] == search1[a]["farmname"].toString().trim()){
              List valuese = data2[m]["waqit"].toString().substring(1,data2[m]["waqit"].toString().toString().length-1).split(",");
              List aa = data2[m]["alla"].toString().substring(1,data2[m]["alla"].toString().toString().length-1).split(",");
              List values =[];
              for(int j=0;j<valuese.length;j++){
                if(aa[j].toString().trim() == 1.toString()){
                  values.add(valuese[j]);
                }
              }
              if(func(times, values) ==true){
                search2.add(search1[a]);
              }
            }
          }
        }
        else{
          for(int z =0 ; z<dataa.length ; z++) {
            if (dataa[z]["farmname"].toString().trim() ==data2[m]["farmname"]) {
              List valuese = data2[m]["waqit"].toString().substring(1, data2[m]["waqit"].toString()
                  .toString()
                  .length - 1).split(",");
              List aa = data2[m]["alla"].toString().substring(1,data2[m]["alla"].toString().toString().length-1).split(",");
              List values =[];
              for(int j=0;j<valuese.length;j++){
                if(aa[j].toString().trim() == 1.toString()){
                  values.add(valuese[j]);
                }
              }
              if (func(times, values) == true) {
                search2.add(dataa[z]);
              }
            }
          }
        }
      }
    }
    else if(value == "yawmi") {
      for(int m=0;m<data2.length;m++){
        if(modn){
          for(int a =0; a< search1.length ; a++){
            if(data2[m]["farmname"].toString().trim() == search1[a]["farmname"].toString().trim()){
              List valuese =  data2[m]["waqit"].toString().substring(1,data2[m]["waqit"].toString().toString().length-1).split(",");
              List aa = data2[m]["sbah"].toString().substring(1,data2[m]["sbah"].toString().toString().length-1).split(",");
              List values =[];
              for(int j=0;j<valuese.length;j++){
                if(aa[j].toString().trim() == 1.toString()){
                  values.add(valuese[j]);
                }
              }
              for(int y=0;y < values.length ; y++){
                if(text1.trim() == values[y].toString().trim()){
                  search2.add(search1[a]);
                  break;
                }}}
          }
        }
        else{
          for(int a =0; a< dataa.length ; a++){
            if(data2[m]["farmname"].toString().trim() == dataa[a]["farmname"].toString().trim()){
              List valuese =  data2[m]["waqit"].toString().substring(1,data2[m]["waqit"].toString().toString().length-1).split(",");
              List aa = data2[m]["sbah"].toString().substring(1,data2[m]["sbah"].toString().toString().length-1).split(",");
              List values =[];
              for(int j=0;j<valuese.length;j++){
                print(aa[j]);
                if(aa[j].toString().trim() == 1.toString()){
                  values.add(valuese[j]);
                }
              }
              for(int y=0;y < values.length ; y++){
                if(text1.trim() == values[y].toString().trim()){
                  search2.add(dataa[a]);
                  break;
                }}}
          }
        }
      }
    }
    else if (value == "sahra"){
      for(int m=0;m<data2.length;m++){
        if(modn){
          for(int a =0; a< search1.length ; a++){
            if(data2[m]["farmname"].toString().trim() == search1[a]["farmname"].toString().trim()){
              List valuese =  data2[m]["waqit"].toString().substring(1,data2[m]["waqit"].toString().toString().length-1).split(",");
              List aa = data2[m]["masa"].toString().substring(1,data2[m]["masa"].toString().toString().length-1).split(",");
              List values =[];
              for(int j=0;j<valuese.length;j++){
                if(aa[j].toString().trim() == 1.toString()){
                  values.add(valuese[j]);
                }
              }
              for(int y=0;y < values.length ; y++){
                if(text1.trim() == values[y].toString().trim()){
                  search2.add(search1[a]);
                  break;
                }}}
          }
        }
        else{
          for(int a =0; a< dataa.length ; a++){
            if(data2[m]["farmname"].toString().trim() == dataa[a]["farmname"].toString().trim()){
              List valuese =  data2[m]["waqit"].toString().substring(1,data2[m]["waqit"].toString().toString().length-1).split(",");
              List aa = data2[m]["masa"].toString().substring(1,data2[m]["masa"].toString().toString().length-1).split(",");
              List values =[];
              for(int j=0;j<valuese.length;j++){
                if(aa[j].toString().trim() == 1.toString()){
                  values.add(valuese[j]);
                }
              }
              for(int y=0;y < values.length ; y++){
                if(text1.trim() == values[y].toString().trim()){
                  search2.add(dataa[a]);
                  break;
                }}}
          }
        }
      }
    }
  }
  void getdatasersh2(bool modn)async{
    await refrence.child("etaha").once().then((DataSnapshot data){
      if(data.value !=null){
        Map<dynamic,dynamic> datas =data.value;
        if(value =="mabit"){
          List times =[];
          var ys =true;
          int s =0;
          while(ys){
            if(DateTime.parse(reversetexts(text21)).add(Duration(days: s)).toString().substring(0,10) !=reversetexts(text22)){
              DateTime dat =DateTime.parse(reversetexts(text21)).add(Duration(days: s));
              times.add(dat.toString().substring(0,10));
            }
            else{
              times.add(reversetexts(text22));
              ys=false;
            }
            s++;
          }
          print("value :" + times.toString());
          datas.forEach((key, value) {
            if(modn){
             for(int a =0; a< search1.length ; a++){
               if(key.toString().trim() == search1[a]["farmname"].toString().trim()){
                 List values =  value.toString().substring(1,value.toString().length-1).split(",");
                 if(func(times, values) ==true){
                   search2.add(search1[a]);
                 }
               }
             }
            }
            else{
              for(int z =0 ; z<dataa.length ; z++) {
                if (dataa[z]["farmname"].toString().trim() == key.toString().trim()) {
                  List values = value.toString().substring(1, value
                      .toString()
                      .length - 1).split(",");
                  if (func(times, values) == true) {
                    search2.add(dataa[z]);
                  }
                }
              }
            }
          });
        }
        else{
          datas.forEach((key, value) {
            if(modn){
              for(int a =0; a< search1.length ; a++){
                if(key.toString().trim() == search1[a]["farmname"].toString().trim()){
            List values =  value.toString().substring(1,value.toString().length-1).split(",");
            for(int y=0;y < values.length ; y++){
              if(text1.trim() == values[y].toString().trim()){
                search2.add(search1[a]);
                break;
              }}}
            }
            }
            else{
              for(int a =0; a< dataa.length ; a++){
                if(key.toString().trim() == dataa[a]["farmname"].toString().trim()){
                  List values =  value.toString().substring(1,value.toString().length-1).split(",");
                  for(int y=0;y < values.length ; y++){
                    if(text1.trim() == values[y].toString().trim()){
                      search2.add(dataa[a]);
                      break;
                    }}}
              }
            }
          });
        }
      }
    });

  }
  void mizati(){
    if(search2.length !=0){
      for(int w =0 ;w<search2.length ; w++){
        List values = search2[w]["mizat"].toString().substring(1,search2[w]["mizat"].toString().length-1).split(",");
        if(funcmizat(mizat, values) ==true){
          search3.add(search2[w]);
        }
      }
    }
    else{
      if(search1.length ==0){
        for(int w =0 ;w<dataa .length ; w++){
          List values = dataa[w]["mizat"].toString().substring(1,dataa[w]["mizat"].toString().length-1).split(",");
          if(funcmizat(mizat, values) ==true){
            search3.add(dataa[w]);
          }
        }
      }
      else{
        for(int w =0 ;w<search1.length ; w++){
          List values = search1[w]["mizat"].toString().substring(1,search1[w]["mizat"].toString().length-1).split(",");
          if(funcmizat(mizat, values) ==true){
            search3.add(search1[w]);
          }
        }
      }
    }
  }
  void search() async{
    showDialog(barrierDismissible: false,context: context, builder: (context) {
      return AlertDialog(title: Text("يتم الان التحميل"),
        content: new Container(width: 50,height: 50,child:CircularProgressIndicator()),);
    });
    search1.clear();
    search2.clear();
    search3.clear();
    search4.clear();
  if(modn.length==0){
    dataa.clear();
    var url2 = "https://mazrati.000webhostapp.com/mazrati2.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
    List data2 = body2;
    for(int k =0;k<data2.length;k++){
      dataa.add(data2[k]);
    }
   // await refrence.child("farms").once().then((DataSnapshot data) {
    //  if (data.value != null) {
      //  Map<dynamic, dynamic> datas = data.value;
        //datas.forEach((key, value) {
          //dataa.add(value);
        //});
      //}
    //});
   if(check){
    await getdataserch2s(false);
     if(search2.length ==0){
       search4 =[];
     }
     else{
       if(mizat.length ==0){
         search4 = search2;
       }
       else{
        await mizati();
         if(search3.length ==0){
           search4 =[];
         }
         else{
           search4 =search3;
         }
       }

     }
   }
   else{
if(mizat.length ==0){
  search4 =dataa;
}
else{
 await mizati();
  if(search3.length ==0){
    search4 =[];
  }
  else{
    search4 = search3;
  }
}}
  }//hala1
  else{
  await getdataserch1s();
   if(search1.length ==0){
     search4 = [];
   }
   else{
     if(check){
      await getdataserch2s(true);
       if(search2.length ==0){
         search4 =[];
       }
       else{
         if(mizat.length ==0){
           search4 =search2;
         }
         else{
           await mizati();
            if(search3.length ==0){
              search4 =[];
            }
            else{
              search4 = search3;
            }
         }
       }
     }
     else{
       if(mizat.length ==0){
         search4 = search1;
       }
       else{
        await mizati();
         if(search3.length ==0){
           search4 =[];
         }
         else{
           search4 = search3;
         }
       }
     }
   }
  }
  Navigator.of(context).pop();
    showSearch(context: context, delegate: delegate(listsuggest : search4));
  }
  void jarb(){

    print(text1);
    List times =[];
    var ys =true;
    int s =0;
    while(ys){
      if(DateTime.parse(reversetexts(text21)).add(Duration(days: s)).toString().substring(0,10) !=reversetexts(text22)){
        DateTime dat =DateTime.parse(reversetexts(text21)).add(Duration(days: s));
        times.add(dat.toString().substring(0,10));
      }
      else{
        times.add(reversetexts(text22));
        ys=false;
      }
      s++;
    }
    print(times.toString());
  }
  @override
  void initState() {
    refrence = ref.reference();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(debugShowCheckedModeBanner: false,title: "search",
      theme: ThemeData(accentColor: Colors.lightBlueAccent ),
      home: Scaffold(backgroundColor: Colors.blueAccent,appBar: AppBar(backgroundColor: Colors.white,leading: IconButton(icon :Icon( Icons.arrow_back,color:Colors.blueAccent,),onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
          return Section1();
        }));
      },),title: Text("تخصيص البحث",style: TextStyle(color: Colors.blueAccent),),centerTitle: true,),body: ListView(children:[
        Container(margin: EdgeInsets.only(top: 20,right: 20),alignment: Alignment.centerRight,child: Text("المدينة",style: TextStyle(fontSize: 25,color: Colors.white),),),
        Container(margin: EdgeInsets.only(left:20,right: 20),alignment: Alignment.centerRight,child:
        MultiSelectDialogField(
          buttonIcon: Icon(Icons.add,color: Colors.white,)
          ,buttonText: Text("اختر المدن",style: TextStyle(fontSize: 20,color: Colors.white),),
          items: ["عمان","جرش","سلط","بحر لميت", " مأدبا","المفرق","بيرين"].map((e) => MultiSelectItem(e,e)).toList(),
          listType: MultiSelectListType.LIST,
          onConfirm: (values) {
            modn = values;
          },
        )), Container(margin: EdgeInsets.only(left: 20,right: 20),
    child: MultiSelectDialogField(
    buttonIcon: Icon(Icons.add,color: Colors.white,),
    buttonText: Text("الميزات",style: TextStyle(fontSize: 20,color: Colors.white),),
    title: Text("الميزات",style: TextStyle(fontSize: 20,color: Colors.blueAccent),),
    items: features.map((e) => MultiSelectItem(e,e)).toList(),
    listType: MultiSelectListType.LIST,
    onConfirm: (values) {
    mizat = values;
    },
    ),
    ),
        Container(margin: EdgeInsets.only(left: 15,right: 7),child:  CheckboxListTile(activeColor: Colors.white,title: Text("اضافة تاريخ",style: TextStyle(fontSize: 20,color: Colors.white),),value: check,onChanged: (val){setState(() {
          check =val;
        });},),)
        ,Container(margin: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.white)),child:check ? Row(children: [Expanded(child: Container(height: 70,child:value =="mabit"?Column(children: [Text("تاريخ الانتهاء",style: TextStyle(color: Colors.white,fontSize: 20)),Text('$text22',style: TextStyle(color: Colors.white,fontSize: 20))],): Column(children: [Text("تاريخ الانتهاء",style: TextStyle(color: Colors.white,fontSize: 20)),Text("$text1",style: TextStyle(color: Colors.white,fontSize: 20))],)),flex: 4,),
          Expanded(child: Icon(Icons.arrow_back_ios,color: Colors.white,)),Expanded(flex: 4,child: Container(height: 70,child:value =="mabit"? Column(children: [Text("تاريخ الحجز",style: TextStyle(color: Colors.white,fontSize: 20)),Text('$text21',style: TextStyle(color: Colors.white,fontSize: 20))],): Column(children: [Text("تاريخ الحجز",style: TextStyle(color: Colors.white,fontSize: 20)),Text('$text1',style: TextStyle(color: Colors.white,fontSize: 20))],)), )],):Container(),),
        Container( margin: EdgeInsets.all(10),child:check ? Row(children: [
          Expanded(child: RadioListTile(tileColor: Colors.blueAccent,groupValue:value, onChanged: (val){value =val;setState(() {});},title: Text("استخدام يومي",style: TextStyle(color: Colors.white,fontSize: 15)),value: "yawmi",),),Expanded(child:RadioListTile(tileColor: Colors.blueAccent,value:"mabit",groupValue: value ,onChanged: (val){value =val;setState(() {});},title: Text("مبيت",style: TextStyle(color: Colors.white,fontSize: 15)),) )
          ,Expanded(child: RadioListTile(tileColor: Colors.blueAccent,groupValue:value, onChanged: (val){value =val;setState(() {});},title: Text("سهرة",style: TextStyle(color: Colors.white,fontSize: 15)),value: "sahra",),)],):Container(),)
,Container(
  child: check?Container(margin: EdgeInsets.all(10),decoration: BoxDecoration(color: Colors.white),child: value == "mabit"?
          SfDateRangePicker(onSelectionChanged: _onSelectionChanged,
            selectionMode: DateRangePickerSelectionMode.range,
            initialSelectedRange: PickerDateRange(
                DateTime.now(),
                DateTime.now().add(const Duration(days: 1))),
          ):CalendarDatePicker(onDateChanged: (va){datevalue =va;text1 = datevalue.toString().substring(0,10);setState(() {});},lastDate: DateTime.now().add(Duration(days: 30)),firstDate:DateTime.now(),initialDate: DateTime.parse(text1),)):Container()
),Container(margin: EdgeInsets.all(10),color: Colors.black12,width: 100,
        child: TextButton(onPressed:(){search();
             }, child: Text("search",style: TextStyle(color: Colors.white),)),
      )],),),
    );
  }

  void getalldata()async {
    dataa.clear();
    await refrence.child("farms").once().then((DataSnapshot data) {
      if (data.value != null) {
        Map<dynamic, dynamic> datas = data.value;
        datas.forEach((key, value) {
          dataa.add(value);
        });
      }
    });
    print(dataa);
  }
}