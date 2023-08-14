import 'package:flutter/material.dart';
import 'package:insta/models/users.dart' as models;
import 'package:insta/providers/user_provider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    models.User user = Provider.of<UserProvider>(context).getUser;
    return Center(
      child: Text(
        user.username,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
