import 'package:flutter/material.dart';
import 'package:insta/resources/auth.dart';
import 'package:insta/models/users.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods=AuthMethods();
  User get getUser=>_user?? User(username: '', uid: '', email: '', bio: '', followers: [], following: [], password: '', photoUrl: '');

  Future<void> refreshUser()async{
    User user=await _authMethods.getUserDeatails();
    _user =user;
    
    notifyListeners();
  }
}