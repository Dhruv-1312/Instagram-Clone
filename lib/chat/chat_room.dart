import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/chat/chat_page.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/screen/feed_screen.dart';
import 'package:insta/utils/colors.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          child: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MobileScreenLayout(),
              ),
            ),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        backgroundColor: mobileBackgroundColor,
        title: const Text('ChatRoom'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Chatpage(
                    receiverId: snapshot.data!.docs[index]['uid'],
                  ),
                )),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(snapshot.data!.docs[index]['photoUrl']),
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['username'],
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
