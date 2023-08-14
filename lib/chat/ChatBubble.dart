import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color colr;
  const ChatBubble({super.key, required this.message,required this.colr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: colr),
      child: Text(
        message,
        style: const TextStyle(fontSize: 16,color: Colors.white),
      ),
    );
  }
}
