import 'package:flutter/material.dart';
import 'package:mazrati/section2.dart';
import 'package:mazrati/view.dart';

class delegate extends SearchDelegate<String>{
  List listsuggest =[];
  delegate({this.listsuggest});
  List listt =["ahmad","soso","kiki"];
  @override
  set query(String value) {
    // TODO: implement query
    super.query =value;
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(icon: Icon(Icons.clear,color: Colors.blueAccent,), onPressed: (){
      query ="";
    })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(icon: Icon(Icons.arrow_back,color: Colors.blueAccent,), onPressed: (){
      close(context,null);});
  }
  String urlget(var url){
    return "https://mazrati.000webhostapp.com/"+url;
  }
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    var newlist =[];
    for(int r =0; r< listsuggest.length ; r++){
      newlist.add(listsuggest[r]["farmname"]);
    }
    newlist = query.isEmpty ? newlist : newlist.where((p) => p.contains(query)).toList();
    List newlistsuggest =[];
    for(int e =0; e<listsuggest.length ;e++){
      for(int s =0 ; s<newlist.length ; s++){
        if(listsuggest[e]["farmname"].toString().trim() == newlist[s]){
          newlistsuggest.add(listsuggest[e]);
        }
      }
    }
    print(newlist);
    return Container(color: Colors.black12,
      child: ListView.builder(itemCount: newlistsuggest.length,itemBuilder: (context,i){
        return Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.05)
          ,width: MediaQuery.of(context).size.width,height :MediaQuery.of(context).size.height*0.45,decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.blueAccent),borderRadius: BorderRadius.circular(30)),
          child:InkWell(focusColor: Colors.yellowAccent,child: Container(child :InkWell(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){return Section2(farmname: newlistsuggest[i]["farmname"],);}));
          }, child: Column(children: [
            Container(margin: EdgeInsets.only(bottom: 10),width: MediaQuery.of(context).size.width ,height: 200 ,child:ClipRRect(borderRadius: BorderRadius.circular(20),child: Image(fit: BoxFit.fill,image: NetworkImage(urlget(newlistsuggest[i]["url1"])),)),)
            ,Container(height: 30,child: Row(children: [Expanded(flex: 2,child: Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.07),
              child: Text("ابتداء من "+"100 دينار",style: TextStyle(fontSize: 17,color: Colors.blueAccent),),)) ,Expanded(child: Container(child:  Text(newlistsuggest[i]["farmname"],style: TextStyle(fontStyle: FontStyle.italic,fontSize: 22,color: Colors.black54),),),)],)),
            Row(children: [Expanded(child: Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.1),width: 100,child: Text("تغير الأسعار حسب يوم الحجز",style: TextStyle(color: Colors.black54,fontSize: 15),),))
              ,Expanded(child: Container()),
              Expanded(child:Container(child: Row(children: [Icon(Icons.star),Icon(Icons.star,color: Colors.blueAccent),Icon(Icons.star,color: Colors.blueAccent),Icon(Icons.star,color: Colors.blueAccent,)],)))],)
          ],),
          ),)),
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    var newlist =[];
    for(int r =0; r< listsuggest.length ; r++){
      newlist.add(listsuggest[r]["farmname"]);
    }
     newlist = query.isEmpty ? newlist : newlist.where((p) => p.contains(query)).toList();
     List newlistsuggest =[];
     for(int e =0; e<listsuggest.length ;e++){
       for(int s =0 ; s<newlist.length ; s++){
         if(listsuggest[e]["farmname"].toString().trim() == newlist[s]){
           newlistsuggest.add(listsuggest[e]);
         }
       }
     }
    print(newlist);
    return Container(color: Colors.black12,
      child: ListView.builder(itemCount: newlistsuggest.length,itemBuilder: (context,i){
        return Container(margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.05)
            ,width: MediaQuery.of(context).size.width,height :MediaQuery.of(context).size.height*0.45,decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.blueAccent),borderRadius: BorderRadius.circular(30)),
          child:InkWell(focusColor: Colors.yellowAccent,child: Container(child :InkWell(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){return Section2(farmname: newlistsuggest[i]["farmname"],);}));
          }, child: Column(children: [
            Container(margin: EdgeInsets.only(bottom: 10),width: MediaQuery.of(context).size.width  ,height: 200 ,child:ClipRRect(borderRadius: BorderRadius.circular(20),child: Image(fit: BoxFit.fill,image: NetworkImage(urlget(newlistsuggest[i]["url1"])),)),)
            ,Container(height: 30,child: Row(children: [Expanded(flex: 2,child: Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.07),
              child: Text("ابتداء من "+"100 دينار",style: TextStyle(fontSize: 17,color: Colors.blueAccent),),)) ,Expanded(child: Container(child:  Text(newlistsuggest[i]["farmname"],style: TextStyle(fontStyle: FontStyle.italic,fontSize: 22,color: Colors.black54),),),)],)),
            Row(children: [Expanded(child: Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width *0.1),width: 100,child: Text("تغير الأسعار حسب يوم الحجز",style: TextStyle(color: Colors.black54,fontSize: 15),),))
              ,Expanded(child: Container()),
              Expanded(child:Container(child: Row(children: [Icon(Icons.star),Icon(Icons.star,color: Colors.blueAccent),Icon(Icons.star,color: Colors.blueAccent),Icon(Icons.star,color: Colors.blueAccent,)],)))],)
          ],),
          ),)),
        );
      }),
    );
  }
}