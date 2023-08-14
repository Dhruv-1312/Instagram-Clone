import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/resources/storage_methods.dart';
import 'package:insta/models/users.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User>getUserDeatails()async{
    User currentUser=_auth.currentUser!;
    
    DocumentSnapshot snap=await _firestore.collection("users").doc(currentUser.uid).get();
    
    return model.User.fromSnap(snap);
  }


  Future<String> createUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String r = "error";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

              String photoUrl = await StorgaeMethds()
            .uploadImageToStorage("profilePics", file, false);


          model.User user=model.User(
            username:username,
            uid:cred.user!.uid,
            email:email ,
            bio: bio,
            followers:[] ,
            following: [],
            password: password,
            photoUrl: photoUrl,
          );
          

        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJason());
        r="success";
      }
    } catch (e) {
      r = e.toString();
      print(r);
    }
    return r;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password); 
        res='success';
      }else{
        String res="please Enter all the fields";
      }
    } catch (e) {
      res=e.toString();
    }
    return res;
  }

  Future<String>SignOut()async{
    String res="Some error Occurred";
    try{
      await _auth.signOut();
    }catch(e){
      res=e.toString();
    }
    return res;
  }
}
