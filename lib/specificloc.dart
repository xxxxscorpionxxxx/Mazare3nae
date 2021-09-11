import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mazrati/adding.dart';
class specLocation extends StatefulWidget{
  specLocation({this.slected,this.latlng});
  var slected;
  var latlng;
  @override
  State<StatefulWidget> createState() {

    return staty(data: slected,latLng: latlng);

  }
}
class staty extends State<specLocation>{
  String latLng ;
  staty({this.data,this.latLng});
  var data;
  LatLng lato;
  Set<Marker> _marker = {};
  var lat;
  var lng;
  @override
  void initState() {
    print(latLng);
    var newlat  =latLng.toString().substring(7,latLng.toString().length-1).trim().split(",");
    lat =double.parse(newlat[0]);
    lng =double.parse(newlat[1]);
    lato = LatLng(lat, lng);
    _marker.add(Marker(markerId: MarkerId("2"),position:lato ));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Location"),),
        body: Container(child:
        Column(children: [Container(alignment: Alignment.center
            ,decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent,width: 7)),
            child:Row(children: [Expanded(child : Container(margin: EdgeInsets.only(right: 20),alignment: Alignment.centerRight,child: Text('$data',style: TextStyle(fontSize: 25),)),flex: 2,),Expanded(child: Text(":المكان ",style: TextStyle(color: Colors.blueAccent,fontSize: 25)))])),
          Container( height:MediaQuery.of(context).size.height * 0.6,child:
        GoogleMap(mapType: MapType.normal,initialCameraPosition:CameraPosition(target:lato,zoom: 15) ,markers:_marker,))
        ],),)
    );
  }


}