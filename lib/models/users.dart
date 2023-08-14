import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final password;
  final String photoUrl;

  const User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.password,
    required this.photoUrl,
  });

  Map<String, dynamic> toJason() => {
        'username': username,
        'uid': uid,
        'email': email,
        'bio': bio,
        'following': following,
        'followers': followers,
        'password': password,
        'photoUrl': photoUrl,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      following: snapshot['following'],
      followers: snapshot['followers'],
      password: snapshot['password'],
      photoUrl: snapshot['photoUrl'],
    );
  }
}
