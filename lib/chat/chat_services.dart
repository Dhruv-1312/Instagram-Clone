import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/message.dart';

class Chatservices extends ChangeNotifier {
  Future<void> SendMessage(String receiverId, String messageText) async {
    final String currentUserid = FirebaseAuth.instance.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Message newmessage = Message(
        Senderid: currentUserid,
        message: messageText,
        receiverId: receiverId,
        timestamp: timestamp);

    List<String> ids = [currentUserid, receiverId];
    ids.sort();
    String ChatroomID = ids.join('_');

//Adding message to database
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(ChatroomID)
        .collection('Messages')
        .add(newmessage.toMap());

  }
  // get msg from db

   Stream<QuerySnapshot> getMessages(String userid, String otherID) {
      List<String> ids = [userid, otherID];
      ids.sort();

      String ChatroomID = ids.join('_');

      return FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc(ChatroomID)
          .collection('Messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    }
}
