

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazrati/adding.dart';

class Location extends StatefulWidget{
  Location({this.slected,this.latlng,this.farmname,this.main,this.photos,this.username});
  var slected ;
  var username;
  LatLng latlng;
  var farmname;
  File main;
  List photos;
  @override
  State<StatefulWidget> createState() {

    return staty(data:slected,latLng: latlng,farmname: farmname,photos: photos,main: main,username:username);

  }
}
class staty extends State<Location>{
  staty({this.data,this.latLng,this.farmname,this.main,this.photos,this.username});
  var data;
  var newLat;
  var username;
  var farmname;
  File main;
  List photos;
  LatLng latLng ;
    Set<Marker> _marker = {};
    @override
  void initState() {
    print(farmname);
    print(photos.length);
    print(main.path);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Location"),),
      body: Container(child:
      Column(children: [Container(padding: EdgeInsets.only(left: 10,right: 10)
          ,decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent,width: 7)),child: Text('$data',style: TextStyle(fontSize: 25),)),Container( height:MediaQuery.of(context).size.height * 0.6,child:
     GoogleMap(initialCameraPosition:CameraPosition(target:latLng,zoom: 10) ,markers:_marker
       ,onTap: (latLn){
       _marker.clear();
       _marker.add(Marker(markerId: MarkerId("d"),position: latLn) );
       newLat = latLn;
       setState(() {
       });
     },)),
ElevatedButton(onPressed: (){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(title: new Text("Warning"),
        content: new Text("هل أنت متأكد من الموقع الذي اخترته"),
        actions: [
          new ElevatedButton(onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return Adding(choosinglat :newLat,main: main,photos: photos,farmname: farmname,username: username,);
            }));
          }, child: Text("okay"))
        ]);
  });
  }, child: Text("choose")),
      ],),)
    );
  }


}