import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postid;
  final  datepublished;
  final String postUrl;
  final String profimage;
  final  likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postid,
    required this.datepublished,
    required this.postUrl,
    required this.profimage,
    required this.likes,
  });

  Map<String, dynamic> toJason() => {
        'description':description,
        'uid':uid,
        'username':username,
        'postid':postid,
        'datepublished':datepublished,
        'postUrl':postUrl,
        'profimage':profimage,
        'likes':likes, 
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postid: snapshot['postid'],
      datepublished: snapshot['datepublished'],
      postUrl: snapshot['postUrl'],
      profimage: snapshot['profimage'],
      likes: snapshot['likes'],
    );
  }
}
