import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String Senderid;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.Senderid,
      required this.message,
      required this.receiverId,
      required this.timestamp});

      //convert to map

      Map<String,dynamic> toMap(){
        return{
          'Senderid':Senderid,
          'message':message,
          'receiverId':receiverId,
          'timestamp':timestamp,
        };
      }
}
