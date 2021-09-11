import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mazrati/view.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Date extends StatefulWidget{
  var farmname;
  Date({this.farmname});
  @override
  State<StatefulWidget> createState() {
    return Statedate(
        farmname :farmname
         );
  }
}
class Statedate extends State<Date>{
  final ref = FirebaseDatabase.instance;
  var refrence;
  String value = "etaha";
  var farmname  ;
  List data=[];
  List data2=[];
  List etaha =[];
  List hajiz =[];
  List masaetaha =[];
  List sabahetaha =[];
  List allaetaha =[];
  List masahajiz =[];
  List sabahhajiz =[];
  List allahajiz =[];
  int s;
  int s2;
  String values;
  Statedate({this.farmname});
 List awqat =[];
  Future ss() async{
    var data ={"farmname" : farmname,"waqit":"etaha.toString()"};
    var url = "https://mazrati.000webhostapp.com/mazratietahaadd.php";
    var response = await http.post(Uri.parse(url),body: data);
    print(response.body);
  }
  Future senddata(var datatype) async{
    if(datatype == "etaha"){
      var url = "https://mazrati.000webhostapp.com/mazratietaha.php";
      var response = await http.get(Uri.parse(url));
      var body = jsonDecode(response.body);
      List g =[];
      for(int d =0; d<body.length;d++){
        if(body[d]["farmname"]==farmname){
          g.add(body[d]);
        }
      }
      if(g.length ==0){
        var data ={"farmname" : farmname,"waqit":etaha.toString().trim(),"masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
        "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaadd.php";
        var response = await http.post(Uri.parse(url),body: data);
        print(response.body);
      }
      else{
        var data ={"farmname" : farmname,"waqit":etaha.toString().trim(),"masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
    "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url),body: data);
      }
    }
    else{
      var url = "https://mazrati.000webhostapp.com/mazratihajiz.php";
      var response = await http.get(Uri.parse(url));
      var body = jsonDecode(response.body);
       List s =[];
       for(int d =0; d<body.length;d++){
         if(body[d]["farmname"]==farmname){
           s.add(body[d]);
         }
       }
      if(s.length==0){
        var data ={"farmname" : farmname,"waqit":hajiz.toString().trim()
          ,"masa":masahajiz.toString(),"sabah":sabahhajiz.toString(),
          "alla":allahajiz.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratihajizadd.php";
        var response = await http.post(Uri.parse(url),body: data);
        print(response.body);
      }
      else{
        var data ={"farmname" : farmname,"waqit":hajiz.toString().trim()
          ,"masa":masahajiz.toString(),"sabah":sabahhajiz.toString(),
          "alla":allahajiz.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratihajizedit.php";
        var response = await http.post(Uri.parse(url),body: data);
      }
    }
  }
  void getdata() async{
    etaha.clear();
    hajiz.clear();
    masahajiz.clear();
    masaetaha.clear();
    sabahhajiz.clear();
    sabahetaha.clear();
    allahajiz.clear();
    allaetaha.clear();
    var url = "https://mazrati.000webhostapp.com/mazratietaha.php";
    var response = await http.get(Uri.parse(url));
    var body = jsonDecode(response.body);
     data =body;
    for(int f =0; f<data.length ; f++){
      if(data[f]["farmname"] == farmname){
          s = f;
          List gg =
              data[f]["waqit"].toString().trim().substring(1, data[f]["waqit"]
                  .toString()
                  .length - 1).split(",");
          List mm = data[f]["masa"].toString().trim().substring(1,data[f]["masa"].toString().length-1).split(",");
          List ss = data[f]["sbah"].toString().trim().substring(1,data[f]["sbah"].toString().length-1).split(",");
          List aa = data[f]["alla"].toString().trim().substring(1,data[f]["alla"].toString().length-1).split(",");
          for(int i = 0; i < 30; i++){
              for (int y = 0; y < gg.length; y++) {
                if (gg[y].toString().trim() ==
                    DateTime.now().add(Duration(days: i)).toString()
                        .substring(0, 10)
                        .trim()) {
                   etaha.add(gg[y]);
                  masaetaha.add(mm[y]);
                  sabahetaha.add(ss[y]);
                  allaetaha.add(aa[y]);
                }
            }
          }
          setState(() {});

      }
    }
    var url2 = "https://mazrati.000webhostapp.com/mazratihajiz.php";
    var response2 = await http.get(Uri.parse(url2));
    var body2 = jsonDecode(response2.body);
     data2 =body2;
     print(data2);
    for(int f =0; f<data2.length ; f++){
      if(data2[f]["farmname"] == farmname){

        s2=f;
        List gg = data2[f]["waqit"].toString().trim().substring(1,data2[f]["waqit"].toString().length -1).split(",");
        List mm = data2[f]["masa"].toString().trim().substring(1,data2[f]["masa"].toString().length-1).split(",");
        List ss = data2[f]["sbah"].toString().trim().substring(1,data2[f]["sbah"].toString().length-1).split(",");
        List aa = data2[f]["alla"].toString().trim().substring(1,data2[f]["alla"].toString().length-1).split(",");
        for(int i = 0; i < 30; i++){
          for (int y = 0; y < gg.length; y++) {
            if (gg[y].toString().trim() ==
                DateTime.now().add(Duration(days: i)).toString()
                    .substring(0, 10)
                    .trim()) {
              hajiz.add(gg[y]);
              masahajiz.add(mm[y]);
              sabahhajiz.add(ss[y]);
              allahajiz.add(aa[y]);
            }
          }
        }

        setState(() {});
      }
    }
//print(etaha);
    print(hajiz[1]);
    print(sabahhajiz);
    print(masahajiz);
  }
  Future<bool> checkhajiz(int i) async{
    if(alla){
       showDialog(context: context, builder: (context) {
        return AlertDialog(title: new Text("error"),
            content: new Text(
                "لا يمكنك من اضافة هذا التاريخ لأنه قد تم حجزه بالفعل!"),
            actions: [
              new ElevatedButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("ok"))
            ]);
      });
       return false;
    }
    else if (masa ==true && sabah ==true) {
       showDialog(context: context, builder: (context) {
        return AlertDialog(title: new Text("error"),
            content: new Text(
                "لا يمكنك من اضافة هذا التاريخ لأنه قد تم حجزه بالفعل!"),
            actions: [
              new ElevatedButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("ok"))
            ]);
      });
      return false;
    }
    else if(masa){
      if(allahajiz[i].toString().trim() ==1.toString()){
         showDialog(context: context, builder: (context) {
          return AlertDialog(title: new Text("error"),
              content: new Text(
                  "لا يمكنك من اضافة هذا التاريخ لأنه قد تم حجزه بالفعل!"),
              actions: [
                new ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("ok"))
              ]);
        });
        return false;
      }
      else if(masahajiz[i].toString().trim() ==1.toString()){
        showDialog(context: context, builder: (context) {
          return AlertDialog(title: new Text("error"),
              content: new Text(
                  "لا يمكنك من اضافة هذا التاريخ لأنه قد تم حجزه بالفعل!"),
              actions: [
                new ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("ok"))
              ]);
        });
        return false  ;
      }
      else if(sabahhajiz[i].toString().trim() == 1.toString()){
        return true;
      }
    }
    else if(sabah){
      if(allahajiz[i].toString().trim() ==1.toString()){
        showDialog(context: context, builder: (context) {
          return AlertDialog(title: new Text("error"),
              content: new Text(
                  "لا يمكنك من اضافة هذا التاريخ لأنه قد تم حجزه بالفعل!"),
              actions: [
                new ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("ok"))
              ]);
        });
        return false;
      }
      else if(masahajiz[i].toString().trim() ==1.toString()){
        return true;
      }
      else if(sabahhajiz[i].toString().trim() == 1.toString()){
         showDialog(context: context, builder: (context) {
          return AlertDialog(title: new Text("error"),
              content: new Text(
                  "لا يمكنك من اضافة هذا التاريخ لأنه قد تم حجزه بالفعل!"),
              actions: [
                new ElevatedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("ok"))
              ]);
        });
        return false;
      }
    }
    if(false) {
      if (masahajiz[i].toString() == 1.toString()) {
        deletes("hajiz", i);
      }
      else if (allahajiz[i].toString() == 1.toString()) {
        allahajiz[i] = 0.toString();
        sabahhajiz[i] = 1.toString();
        var data = {"farmname": farmname, "waqit": hajiz.toString(),
          "masa": masahajiz.toString(), "sabah": sabahhajiz.toString(),
          "alla": allahajiz.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratihajizedit.php";
        var response = await http.post(Uri.parse(url), body: data);
      }
      else if (sabahhajiz.toString() == 1.toString()) {
        //dont do any thing
      }
      else if (grobi == "sabah") {
        if (masahajiz[i].toString() == 1.toString()) {
          //dont do any thing
        }
        else if (allahajiz[i].toString() == 1.toString()) {
          allahajiz[i] = 0.toString();
          masahajiz[i] = 1.toString();
          var data = {"farmname": farmname, "waqit": hajiz.toString(),
            "masa": masahajiz.toString(), "sabah": sabahhajiz.toString(),
            "alla": allahajiz.toString()};
          var url = "https://mazrati.000webhostapp.com/mazratihajizedit.php";
          var response = await http.post(Uri.parse(url), body: data);
        }
        else if (sabahhajiz[i].toString() == 1.toString()) {
          deletes("hajiz", i);
        }
      }
    }
  }
  void checketaha(int i)async{
    if(grobi=="alla"){
      deletes("etaha", i);
    }
    else if (grobi =="masa"){
      if(masaetaha[i].toString().trim() == 1.toString()&&sabahetaha[i].toString().trim() == 1.toString()&&allaetaha[i].toString().trim() == 1.toString()){
        allaetaha[i] =0.toString();
        sabahetaha[i] = 1.toString();
        masaetaha[i] =0.toString();
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
        return null;
      }
      else if (allaetaha[i].toString().trim() ==1.toString() &&masaetaha[i].toString().trim() ==1.toString()){
        deletes("etaha", i);
        return null;
      }
      else if(allaetaha[i].toString().trim() ==1.toString() &&sabahetaha[i].toString().trim() ==1.toString()){
        allaetaha[i] =0.toString();
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
        return null;
      }
      else if(masaetaha[i].toString().trim() ==1.toString() &&sabahetaha[i].toString().trim() ==1.toString()){
        masaetaha[i] =0.toString();
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
        return null;
      }
      else if(allaetaha[i].toString().trim() ==1.toString()){
       deletes("etaha", i);
       return null;
      }
      else if(masaetaha[i].toString().trim() ==1.toString()){
        deletes("etaha", i);
        return null;
      }
      else if(sabahetaha[i].toString().trim() ==1.toString()){
        return null;
      }
    }
    else if(grobi =="sabah"){
      if(masaetaha[i].toString().trim() == 1.toString()&&sabahetaha[i].toString().trim() == 1.toString()&&allaetaha[i].toString().trim() == 1.toString()){
        allaetaha[i] =0.toString();
        sabahetaha[i] = 0.toString();
        masaetaha[i] =1.toString();
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
        return null;
      }
      else if (allaetaha[i].toString().trim() ==1.toString() &&sabahetaha[i].toString().trim() ==1.toString()){
        deletes("etaha", i);
        return null;
      }
      else if(allaetaha[i].toString().trim() ==1.toString() &&masaetaha[i].toString().trim() ==1.toString()){
        allaetaha[i] =0.toString();
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
        return null;
      }
      else if(masaetaha[i].toString().trim() ==1.toString() &&sabahetaha[i].toString().trim() ==1.toString()){
        sabahetaha[i] =0.toString();
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
        return null;
      }
      else if(allaetaha[i].toString().trim() ==1.toString()){
        deletes("etaha", i);
        return null;
      }
      else if(sabahetaha[i].toString().trim() ==1.toString()){
        deletes("etaha", i);
        return null;
      }
      else if(masaetaha[i].toString().trim() ==1.toString()){
        return null;
      }
    }
  }
  void deletes(var datatype,int i) async{
    if(datatype =="etaha"){
      if(etaha.length ==1){
        etaha.clear();
        masaetaha.clear();
        sabahetaha.clear();
        allaetaha.clear();
        setState(() {});
        var data = {"farmname": farmname};
        var url = "https://mazrati.000webhostapp.com/mazratietahadelete.php";
        var response = await http.post(Uri.parse(url), body: data);
      }
      else {
        etaha.removeAt(i);
        masaetaha.removeAt(i);
        sabahetaha.removeAt(i);
        allaetaha.removeAt(i);
        setState(() {});
        var data = {"farmname": farmname, "waqit": etaha.toString(),
          "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
          "alla":allaetaha.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
        var response = await http.post(Uri.parse(url), body: data);
      }
    }
    else if(datatype =="hajiz"){
      if(hajiz.length ==1){
        hajiz.clear();
        masahajiz.clear();
        sabahhajiz.clear();
        allahajiz.clear();
        setState(() {});
        var data = {"farmname": farmname};
        var url = "https://mazrati.000webhostapp.com/mazratihajizdelete.php";
        var response = await http.post(Uri.parse(url), body: data);
      }
      else {
        hajiz.removeAt(i);
        masahajiz.removeAt(i);
        sabahhajiz.removeAt(i);
        allahajiz.removeAt(i);
        setState(() {});
        var data = {"farmname": farmname, "waqit": hajiz.toString(),
          "masa":masahajiz.toString(),"sabah":sabahhajiz.toString(),
          "alla":allahajiz.toString()};
        var url = "https://mazrati.000webhostapp.com/mazratihajizedit.php";
        var response = await http.post(Uri.parse(url), body: data);
      }
    }
  }
void delete(var datatype,int i){
    if(datatype =="etaha"){
      if(etaha.length ==1){
        etaha.clear();
        refrence.child("etaha").child(farmname.toString()).remove();
        setState(() {});
      }
      else{
        etaha.removeAt(i);
        refrence.child("etaha").child(farmname.toString()).remove();
        refrence.child("etaha").child(farmname.toString()).set(etaha.toString());
        setState(() {});
      }
    }
    else if(datatype =="hajiz"){
      if(hajiz.length ==1){
        hajiz.clear();
        refrence.child("hajiz").child(farmname.toString()).remove();
        setState(() {});
      }
      else{
        hajiz.removeAt(i);
        refrence.child("hajiz").child(farmname.toString()).remove();
        refrence.child("hajiz").child(farmname.toString()).set(hajiz.toString());
        setState(() {});
      }

    }
}
void detetaha(int i){
   showDialog(context: context, builder: (context) {
    return AlertDialog(title: new Text("الفترات"),
        content: new Container(height: MediaQuery.of(context).size.height *0.15,
            width: MediaQuery.of(context).size.height *0.2,child: Row(children: [Expanded(child:Container(child: ElevatedButton(
          child: Text("حذف "),onPressed: ()async{await deletes("etaha", i);
        Navigator.of(context).pop();},
        ),)),
          Expanded(child:Container()),
          Expanded(child:Container(child: Container(child: ElevatedButton(
            child: Text("تعديل الفترات"),onPressed: (){
            var value1 = false ;
            var value2 = false;
            var value3 = false;
            if (masaetaha[i].toString().trim() == 1.toString()) {
              value2 = true;
            }
            if (sabahetaha[i].toString().trim() ==1.toString()) {
              value1 =true;
            }
            if (allaetaha[i].toString().trim() ==1.toString()) {
              value3 =true;
            }
            var  vaso1 = value1;
            var vaso2 =value2;
            var vaso3 =value3;
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text("تعديل الفترة"),
                      content: Container(
                          height: MediaQuery.of(context).size.height*0.3,child: Column(children: [
                        CheckboxListTile(title: Container(alignment: Alignment.centerRight,child: Text("استخدام يومي",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value:value1 , onChanged: (va){setState(() {value1 = va;});}),
                        CheckboxListTile(title: Container(alignment: Alignment.centerRight,child: Text("سهرة",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: value2, onChanged: (va){setState(() {value2 = va;});}),
                        CheckboxListTile(title: Container(alignment: Alignment.centerRight,child: Text("يوم كامل مع مبيت",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: value3, onChanged: (va){setState(() {value3 = va;});}),
                      ])),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {Navigator.of(context).pop();},
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: ()async {
                            if(vaso3 == value3 && vaso2 ==value2 && vaso1 ==value1){
                              return null;
                            }
                            var able = true;
                            for(int s =0 ; s<hajiz.length ; s++){
                              if(etaha[i].toString().trim() == hajiz[s].toString().trim() ){
                                able =false;
                                return showDialog(context: context, builder: (context) {
                                  return AlertDialog(title: new Text("error"),
                                      content: new Text(
                                          "لا يمكنك تعديل هذه الفترة لأنه محجوزة!!"),
                                      actions: [
                                        new ElevatedButton(onPressed: () {
                                          Navigator.of(context).pop();
                                        }, child: Text("ok"))
                                      ]);
                                });
                              }
                            }
                            if(able){
     if (value2) {
     masaetaha[i] = 1.toString();
     }
     else{
     masaetaha[i] = 0.toString();
     }
     if (value1) {
     sabahetaha[i] = 1.toString();
     }
     else{
     sabahetaha[i] = 0.toString();
     }
     if (value3) {
     allaetaha[i] = 1.toString();
     }
     else{
     allaetaha[i] = 0.toString();
     }
                              var data = {"farmname": farmname, "waqit": etaha.toString(),
                                "masa":masaetaha.toString(),"sabah":sabahetaha.toString(),
                                "alla":allaetaha.toString()};
                              var url = "https://mazrati.000webhostapp.com/mazratietahaedit.php";
                              var response = await http.post(Uri.parse(url), body: data);
                              getdata();
                              Navigator.of(context).pop();
                          }},
                          child: Text("تعديل"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          ),),))],),),
        actions: [
          new ElevatedButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("cancel"))
        ]);
  });
}
void dethajiz(int i){
  showDialog(context: context, builder: (context) {
    return AlertDialog(title: new Text("الفترات"),
        content: new Container(height: MediaQuery.of(context).size.height *0.15,
            width: MediaQuery.of(context).size.height *0.2,child: Row(children: [Expanded(child:Container(child: ElevatedButton(
          child: Text("حذف "),onPressed: ()async {await deletes("hajiz", i);
          Navigator.of(context).pop();},
        ),)),
          Expanded(child:Container()),
          Expanded(child:Container(child: Container(child: ElevatedButton(
            child: Text("تعديل الفترات"),onPressed: (){
            var value1 = "saba" ;
            var value2 = "masa";
            var value3 = "alla";
            print(i);
            var  vaso1 = value1;
            var vaso2 =value2;
            var vaso3 =value3;
            var grobi;
            if(masahajiz[i].toString().trim() ==1.toString()){
              grobi = "masa";
            }
            if(sabahhajiz[i].toString().trim() == 1.toString()){
             grobi = "saba";}
            if(allahajiz[i].toString().trim() ==1.toString()){
              grobi = "alla";}
            var ddo =grobi;
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text("تعديل الفترة"),
                      content: Container(
                          height: MediaQuery.of(context).size.height*0.3,child: Column(children: [
                        RadioListTile(groupValue: grobi,title: Container(alignment: Alignment.centerRight,child: Text("استخدام يومي",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value:value1 , onChanged: (va){setState(() {grobi = va;});}),
                        RadioListTile(groupValue: grobi,title: Container(alignment: Alignment.centerRight,child: Text("سهرة",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: value2, onChanged: (va){setState(() {grobi = va;});}),
                        RadioListTile(groupValue: grobi,title: Container(alignment: Alignment.centerRight,child: Text("فترة كاملة أو مبيت",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: value3, onChanged: (va){setState(() {grobi = va;});}),
                      ])),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {Navigator.of(context).pop();},
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: ()async {
                            if(grobi ==ddo){
                              return null;
                            }
                            print(i);
                            List opo =[];
                            for(int f =0; f<hajiz.length;f++){
                              if(hajiz[i].toString().trim() !=hajiz[f].toString().trim()) {
                                opo.add(hajiz[f]);
                              }
                            }
                            for(int y =0 ; y<opo.length;y++){
                              if(hajiz[i].toString().trim() == opo[y].toString().trim()){
                                 showDialog(context: context, builder: (context) {
                                 return  AlertDialog(title: new Text("error"),
                                      content: new Text(
                                          "لا يمكنك تعديل هذا اليوم لأنه تم الحجز!ا"),
                                      actions: [
                                        new ElevatedButton(onPressed: () {
                                          Navigator.of(context).pop();
                                        }, child: Text("ok"))
                                      ]);
                                });
                                return null;
                              }
                            }
                            for(int s =0 ; s<etaha.length ; s++){
                              if(hajiz[i].toString().trim() == etaha[s].toString().trim()){

                                showDialog(context: context, builder: (context) {
                                  return  AlertDialog(title: new Text("error"),
                                      content: new Text(
                                          "لا يجوز التعديل على يوم الحجز الذي يمكن أن يتم أجاره في فترة مختلفة"),
                                      actions: [
                                        new ElevatedButton(onPressed: () {
                                          Navigator.of(context).pop();
                                        }, child: Text("ok"))
                                      ]);
                                });
                                return null;

                              }
                            }
                            if(grobi == "masa"){
                              masahajiz[i] = 1.toString();
                              sabahhajiz[i] = 0.toString();
                              allahajiz[i] = 0.toString();
                            }
                            if(grobi == "saba"){
                              masahajiz[i] = 0.toString();
                              sabahhajiz[i] = 1.toString();
                              allahajiz[i] = 0.toString();
                            }
                            if(grobi == "alla"){
                              masahajiz[i] = 0.toString();
                              sabahhajiz[i] = 0.toString();
                              allahajiz[i] = 1.toString();
                            }
                            var data = {"farmname": farmname, "waqit": hajiz.toString(),
                              "masa":masahajiz.toString(),"sabah":sabahhajiz.toString(),
                              "alla":allahajiz.toString()};
                            var url = "https://mazrati.000webhostapp.com/mazratihajizedit.php";
                            var response = await http.post(Uri.parse(url), body: data);
                            getdata();
                            Navigator.of(context).pop();
                          },
                          child: Text("تعديل"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          ),),))],),),
        actions: [
          new ElevatedButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("cancel"))
        ]);
  });
}
var masa = false;
  var sabah = false;
  var alla = false;
  var masah = "masa";
  var sabahh = "sabah";
  var allah = "alla";
  var grobi ;
  var vals= false;
  @override
  void initState() {
    refrence = ref.reference();
    print(farmname);
    getdata();
    super.initState();
  }
  var datevalue =DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(debugShowCheckedModeBanner: false,title: "mazrait",theme: ThemeData(accentColor: Colors.blueAccent),
      home: Scaffold(appBar: AppBar(leading:IconButton(icon: Icon(Icons.arrow_back,color: Colors.blueAccent,),onPressed: (){
        Navigator.of(context).pop();
      },),centerTitle: true,title: Text("اختيار التاريخ",style: TextStyle(color: Colors.blueAccent),),backgroundColor: Colors.white,),body:Container(color: Colors.white,child: ListView(children: [Container(child: Row(children: [
        Expanded(child: RadioListTile(groupValue:value, onChanged: (val){value =val;setState(() {});},title: Text("الوقت المحجوز",style: TextStyle(color: Colors.blueAccent,fontSize: 19,fontStyle: FontStyle.italic),),value: "hajiz",),),Expanded(child:RadioListTile(value:"etaha",groupValue: value ,onChanged: (val){value =val;setState(() {});},title: Text("الوقت المتاح للحجز",style: TextStyle(color: Colors.blueAccent,fontSize: 19,fontStyle: FontStyle.italic)),) )],),)
        ,Container(color: Colors.white,child: CalendarDatePicker(onDateChanged: (va){datevalue =va;},lastDate: DateTime.now().add(Duration(days: 30)),firstDate:DateTime.now(),initialDate: DateTime.now(),)),
   Container(alignment: Alignment.centerRight,child: CheckboxListTile(value:vals,onChanged: (va){setState(() {
     vals = va;
   });} ,title: Container(alignment: Alignment.centerRight,child: Text("اختيار الفترة المحجوزة",style: TextStyle(fontSize: 20,color: Colors.blueAccent,fontStyle: FontStyle.italic),))),),
    Container(child: vals ?Container(height: MediaQuery.of(context).size.height*0.3,child: Container(
      child:value =="hajiz"?
    Column(children: [
    RadioListTile(title: Container(alignment: Alignment.centerRight,child: Text("استخدام يومي",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value:sabahh,groupValue: grobi  , onChanged: (va){setState(() {grobi = va;});}),
    RadioListTile(title: Container(alignment: Alignment.centerRight,child: Text("سهرة",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: masah,groupValue: grobi  , onChanged: (va){setState(() {grobi = va;});}),
    RadioListTile(title: Container(alignment: Alignment.centerRight,child: Text("يوم كامل مع مبيت",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: allah,groupValue: grobi  , onChanged: (va){setState(() {grobi = va;});}),
    ],):Column(children: [
        CheckboxListTile(title: Container(alignment: Alignment.centerRight,child: Text("استخدام يومي",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value:sabah , onChanged: (va){setState(() {sabah = va;});}),
        CheckboxListTile(title: Container(alignment: Alignment.centerRight,child: Text("سهرة",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: masa, onChanged: (va){setState(() {masa = va;});}),
        CheckboxListTile(title: Container(alignment: Alignment.centerRight,child: Text("يوم كامل مع مبيت",style: TextStyle(fontSize: 20,color: Colors.blueAccent),)),value: alla, onChanged: (va){setState(() {alla = va;});}),
      ],),
    ),):Container(),)
    ,Container(color: Colors.white ,margin: EdgeInsets.only(top: 10,left: 10,right: 10),child: ElevatedButton(onPressed: ()async{
      //var able1 =true;
      //var able2 =true;
      List qim =[];
      if(masa){
        qim.add("فترة مسائية");
      }
      if(sabah){
        qim.add("فترة صباحية");
      }
      if(alla){
        qim.add("فترة كاملة");
      }
      if(grobi =="masa"){
        qim.add("فترة مسائية");
      }
      if(grobi =="sabah"){
        qim.add("فترة صباحية");
      }
      if(grobi == "alla"){
        qim.add("فترة كاملة");
      }
     // for(int i =0 ;i <qim.length;i++){
      //  for(int k =0;k<qim.length;k++){
      //    if(qim[i].toString() == "فترة كاملة"&& qim[k].toString() =="فترة صباحية"){
       //     able1 =false;
       //     return showDialog(context: context, builder: (context) {
       //       return AlertDialog(title: new Text("error"),
       //           content: new Text(
       //               "لا يمكنك اختيار فترة كاملة وفترة صباحية معا"),
       //           actions: [
       //             new ElevatedButton(onPressed: () {
       //               Navigator.of(context).pop();
       //             }, child: Text("ok"))
       //           ]);
       //     });
       //   }
        //  if(qim[i].toString() == "فترة كاملة"&& qim[k].toString() =="فترة مسائية"){
        //    able2 =false;
        //    return showDialog(context: context, builder: (context) {
        //      return AlertDialog(title: new Text("error"),
        //          content: new Text(
        //              "لا يمكنك اختيار فترة كاملة وفترة مسائية معا"),
        //          actions: [
        //            new ElevatedButton(onPressed: () {
        //              Navigator.of(context).pop();
        //            }, child: Text("ok"))
         //         ]);
         //   });
         // }
       // }
     // }
      if(qim.length != 0 && vals ==true) {
        if (value.toString() == "etaha") {
          var yes = true;
          var able = true;
          for (int i = 0; i < etaha.length; i++) {
            if (datevalue.toString().substring(0, 10).trim() == etaha[i].toString().trim()) {
              yes = false;
            }
          }
          if (yes) {
            for (int i = 0; i < hajiz.length; i++) {
              if (datevalue.toString().substring(0, 10) == hajiz[i].toString().trim()) {
              able = await checkhajiz(i);

              }
            }
            if (able) {
              etaha.add(datevalue.toString().substring(0, 10));
              if (masa) {
                masaetaha.add(1.toString());
              }
              else {
                masaetaha.add(0.toString());
              }
              if (sabah) {
                sabahetaha.add(1.toString());
              }
              else {
                sabahetaha.add(0.toString());
              }
              if (alla) {
                allaetaha.add(1.toString());
              }
              else {
                allaetaha.add(0.toString());
              }
              setState(() {});
              senddata("etaha");
            }
            else {
              return showDialog(context: context, builder: (context) {
                return AlertDialog(title: new Text("error"),
                    content: new Text(
                        "لا يمكنك من اضافة هذا التاريخ فهو موجود بالفعل!"),
                    actions: [
                      new ElevatedButton(onPressed: () {
                        Navigator.of(context).pop();
                      }, child: Text("ok"))
                    ]);
              });
            }
          }
          else{
            return showDialog(context: context, builder: (context) {
              return AlertDialog(title: new Text("error"),
                  content: new Text(
                      "لا يمكنك اضافة هذا اليوم لانه مضاف بالفعل!ا"),
                  actions: [
                    new ElevatedButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, child: Text("ok"))
                  ]);
            });
          }
        }
        else if (value.toString() == "hajiz") {
          var yes = true;
          var raqm;
          for (int i = 0; i < hajiz.length; i++) {
            if (hajiz[i].toString().trim() == datevalue.toString().substring(0, 10)) {
              yes = false;
              raqm = i;
            }
          }
          if (yes) {
            for (int i = 0; i < etaha.length; i++) {
              if (datevalue.toString().substring(0, 10) ==
                  etaha[i].toString().trim()) {
                await checketaha(i);
              }
            }
            hajiz.add(datevalue.toString().substring(0, 10));
            if (grobi == "masa") {
              masahajiz.add(1.toString());
              sabahhajiz.add(0.toString());
              allahajiz.add(0.toString());
            }
            if (grobi == "sabah") {
              masahajiz.add(0.toString());
              sabahhajiz.add(1.toString());
              allahajiz.add(0.toString());
            }
            if (grobi == "alla") {
              masahajiz.add(0.toString());
              sabahhajiz.add(0.toString());
              allahajiz.add(1.toString());
            }
            setState(() {});
            senddata("hajiz");
          }
          else {
            if (grobi == "masa") {
              if (masahajiz[raqm] == 1.toString()) {
                return null;
              }
              else if (sabahhajiz[raqm] == 1.toString()) {
                for (int i = 0; i < etaha.length; i++) {
                  if (datevalue.toString().substring(0, 10) ==
                      etaha[i].toString().trim()) {
                    await checketaha(i);
                  }
                }
                hajiz.add(datevalue.toString().substring(0, 10));
                if (grobi == "masa") {
                  masahajiz.add(1.toString());
                  sabahhajiz.add(0.toString());
                  allahajiz.add(0.toString());
                }
                if (grobi == "sabah") {
                  masahajiz.add(0.toString());
                  sabahhajiz.add(1.toString());
                  allahajiz.add(0.toString());
                }
                if (grobi == "alla") {
                  masahajiz.add(0.toString());
                  sabahhajiz.add(0.toString());
                  allahajiz.add(1.toString());
                }
                setState(() {});
                senddata("hajiz");
              }
              else if (allahajiz[raqm] == 1.toString()) {
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title: new Text("error"),
                      content: new Text(
                          "لا يمكنك حجز اليوم بنفس هذه الفترة لانه محجوز فيها"),
                      actions: [
                        new ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("ok"))
                      ]);
                });
              }
            }
            if (grobi == "sabah") {
              if (masahajiz[raqm] == 1.toString()) {
                for (int i = 0; i < etaha.length; i++) {
                  if (datevalue.toString().substring(0, 10) ==
                      etaha[i].toString().trim()) {
                    await checketaha(i);
                  }
                }
                hajiz.add(datevalue.toString().substring(0, 10));
                if (grobi == "masa") {
                  masahajiz.add(1.toString());
                  sabahhajiz.add(0.toString());
                  allahajiz.add(0.toString());
                }
                if (grobi == "sabah") {
                  masahajiz.add(0.toString());
                  sabahhajiz.add(1.toString());
                  allahajiz.add(0.toString());
                }
                if (grobi == "alla") {
                  masahajiz.add(0.toString());
                  sabahhajiz.add(0.toString());
                  allahajiz.add(1.toString());
                }
                setState(() {});
                senddata("hajiz");
              }
              else if (sabahhajiz[raqm] == 1.toString()) {
                return null;
              }
              else if (allahajiz[raqm] == 1.toString()) {
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title: new Text("error"),
                      content: new Text(
                          "لا يمكنك حجز اليوم بنفس هذه الفترة لانه محجوز فيها"),
                      actions: [
                        new ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("ok"))
                      ]);
                });
              }
            }
            if (grobi == "alla") {
              if (masahajiz[raqm] == 1.toString()) {
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title: new Text("error"),
                      content: new Text(
                          "لا يمكنك حجز اليوم بنفس هذه الفترة لانه محجوز فيها"),
                      actions: [
                        new ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("ok"))
                      ]);
                });
              }
              else if (sabahhajiz[raqm] == 1.toString()) {
                return showDialog(context: context, builder: (context) {
                  return AlertDialog(title: new Text("error"),
                      content: new Text(
                          "لا يمكنك حجز اليوم بنفس هذه الفترة لانه محجوز فيها"),
                      actions: [
                        new ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();
                        }, child: Text("ok"))
                      ]);
                });
              }
              else if (allahajiz[raqm] == 1.toString()) {
                return null;
              }
            }
          }
        }
      }
    else{
    return showDialog(context: context, builder: (context) {
    return AlertDialog(title: new Text("error"),
    content: new Text(
    "يجب اختيار على الاقل فترة واحدة مناسبة للحجز"),
    actions: [
    new ElevatedButton(onPressed: () {
    Navigator.of(context).pop();
    }, child: Text("ok"))
    ]);
    });
    }
    }, child: Text("اضافة",style: TextStyle(color: Colors.white,fontSize: 20))))
        ,Container(margin: EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0.1 ),height: MediaQuery.of(context).size.height*0.4,child: Row(children: [Expanded(child:Container(color: Colors.white ,child :Column(children: [Text("الأوقات المحجوزة",style: TextStyle(color: Colors.blueAccent,fontSize: 19)),Container(height:MediaQuery.of(context).size.height*0.34 ,width: MediaQuery.of(context).size.width*0.5,child: ListView.builder(itemCount: hajiz.length,itemBuilder: (context,i){return InkWell(child: ListTile(leading: IconButton(icon: Icon(Icons.announcement,color: Colors.blueAccent,),onPressed: (){dethajiz(i);},),title: Text( hajiz[i].toString().trim(),style: TextStyle(color: Colors.blueAccent,fontSize: 15))));}),)],) ))
          ,Expanded(child:Container(color: Colors.white,child :Column(children: [Text("الأوقات المتاحة للحجز",style: TextStyle(color: Colors.blueAccent,fontSize: 19)),Container(height:MediaQuery.of(context).size.height*0.34 ,width: MediaQuery.of(context).size.width*0.5,child: ListView.builder(itemCount: etaha.length,itemBuilder: (context,i){return InkWell(child:ListTile(leading: IconButton(icon: Icon(Icons.announcement,color: Colors.blueAccent,),onPressed:(){ detetaha(i);},),title:Text(etaha[i].toString().trim(),style: TextStyle(color: Colors.blueAccent,fontSize: 15))));}))],) ) )],),)],),),),
    );
  }
}