import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/posts.dart';
import 'package:insta/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profimage) async {
    String res = "some error occured";
    String postid = Uuid().v1();
    try {
      //uploaded post to storage
      String postUrl =
          await StorgaeMethds().uploadImageToStorage('Posts', file, true);
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postid: postid,
          datepublished: DateTime.now(),
          postUrl: postUrl,
          profimage: profimage,
          likes: []);

      //uploading to firebase;
      _firestore.collection('Posts').doc(postid).set(post.toJason());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> updateLikes(
    String uid,
    String postid,
    List likes,
  ) async {
    String res;
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('Posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('Posts').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      res = e.toString();
      print(res);
    }
  }

  Future<String> Comment(String uid, String postid, String Comment,
      String profimage, String name) async {
    String res = 'Some error occurred';
    try {
      String Commentid = Uuid().v1();
      if (Comment.isNotEmpty) {
        _firestore
            .collection('Posts')
            .doc(postid)
            .collection('Comments')
            .doc(Commentid)
            .set({
          'uid': uid,
          'postid': postid,
          'Comment': Comment,
          'profimage': profimage,
          'name': name,
          'datepublished': DateTime.now(),
          'commentId': Commentid,
          'likes': [],
        });
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> commentLikes(
      String uid, String postid, String commentId, List likes) async {
    String res;
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(postid)
            .collection('Comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Posts')
            .doc(postid)
            .collection('Comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      res = e.toString();
      print(res);
    }
  }

  Future<void> followUser(String uid, String followId) async {
    String res;
    try {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      List following = snap.data()!['following'];
      if (following.contains(followId)) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
        await FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      }else{
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        await FirebaseFirestore.instance.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      res = e.toString();
      print(res);
    }
  }

  //deleting post
  Future<void>deletepost(String postid)async{
      try{
       await _firestore.collection('Posts').doc(postid).delete();
      }catch(e){
        print(e.toString());
      }
  }


}
