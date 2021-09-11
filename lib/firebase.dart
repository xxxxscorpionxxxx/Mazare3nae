import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
class FirebaseApi{
  static UploadTask upload(File file ,int i,var Farmname){
 try{
   final Ref = FirebaseStorage.instance.ref(("$Farmname/$i"+".jpg"));
    Ref.delete();
  return Ref.putFile(file);
 }on FirebaseException  catch (e){
   print("error"+e.message);
 }
  }
}