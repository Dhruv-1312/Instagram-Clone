import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/screen/add_post_screen.dart';
import 'package:insta/screen/feed_screen.dart';
import 'package:insta/screen/notification.dart';
import 'package:insta/screen/search_screen.dart';
import 'package:insta/screen/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const NotificationScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
