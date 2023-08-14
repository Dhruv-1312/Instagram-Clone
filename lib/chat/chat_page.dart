import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta/chat/ChatBubble.dart';
import 'package:insta/chat/chat_room.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/text_feild.dart';
import 'chat_services.dart';

class Chatpage extends StatefulWidget {
  final String receiverId;
  const Chatpage({super.key, required this.receiverId});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  var userdata = {};
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    receiverdata();
  }

  receiverdata() async {
    setState(() {
      isloading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverId)
          .get();
      userdata = snap.data()!;
    } catch (e) {
      ShowSnackBar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  final TextEditingController msgControl = TextEditingController();
  final Chatservices _chatservices = Chatservices();

  void SendMessage() async {
    if (msgControl.text.isNotEmpty) {
      await _chatservices.SendMessage(widget.receiverId, msgControl.text);
    }
    msgControl.clear();
  }

  Widget _buildmessageinput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20),
      child: Row(
        children: [
          Expanded(
            child: TextFieldInput(
                textEditingController: msgControl,
                hintext: 'Type your message',
                textInputType: TextInputType.text),
          ),
          IconButton(
            alignment: Alignment.centerRight,
            onPressed: SendMessage,
            icon: Icon(
              Icons.send,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildmessageitem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Color color=(data['Senderid']== FirebaseAuth.instance.currentUser!.uid)?Colors.green:Colors.grey;

    var alignment = (data['Senderid'] == FirebaseAuth.instance.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft);

    return Container(
      padding:const  EdgeInsets.only(right: 12,left: 12),
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            (data['Senderid'] == FirebaseAuth.instance.currentUser!.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        mainAxisAlignment:
            (data['Senderid'] == FirebaseAuth.instance.currentUser!.uid)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          const SizedBox(height: 5,),
          ChatBubble(message: data['message'],colr:color,)
        ],
      ),
    );
  }

  Widget _buildmessageList() {
    return StreamBuilder(
      stream: _chatservices.getMessages(
          widget.receiverId, FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildmessageitem(document))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userdata['username']),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChatRoom(),
                  ),
                ),
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: Column(children: [
              Expanded(child: _buildmessageList()),
              _buildmessageinput(),

              const SizedBox(height: 22,)
            ]),
          );
  }
}
