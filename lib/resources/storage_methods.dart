import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
class StorgaeMethds {
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth auth=FirebaseAuth.instance;

Future<String>uploadImageToStorage(String childNAme,Uint8List file,bool ispost)async{

 Reference ref= _storage.ref().child(childNAme).child(auth.currentUser!.uid);
  if(ispost){
    String id=Uuid().v1();
    ref=ref.child(id);
  }
  UploadTask upload=ref.putData(file);

  TaskSnapshot snap=await upload;
  String downloadURL= await snap.ref.getDownloadURL();
  return downloadURL;

  }
  
}