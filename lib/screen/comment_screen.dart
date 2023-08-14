import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart' as model;
import 'package:insta/providers/user_provider.dart';
import 'package:insta/resources/firestor_methods.dart';
import 'package:insta/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:insta/utils/colors.dart';

import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final postid;
  const CommentScreen({super.key, required this.postid});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentControl = TextEditingController();

  void PostComment(String uid, String profimage, String name) async {
    try {
      String res = await FirestoreMethods()
          .Comment(uid, widget.postid, commentControl.text, profimage, name);
      if (res != 'success') {
        ShowSnackBar(res, context);
      }
      setState(() {
        commentControl.text="";
      });
    } catch (e) {
      ShowSnackBar(e, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .doc(widget.postid)
            .collection('Comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommenCard(
              snap:snapshot.data!.docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child:Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child:Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 8,
              ),
              Expanded(
                child:Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentControl,
                    decoration: InputDecoration(
                      hintText: 'Comment on the post',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    PostComment(user.uid, user.photoUrl, user.username),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
