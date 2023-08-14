import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Color backgroundColor;
  final Function()? function;
  Color borderColor;
  final text;
  final Color textcolor;

  FollowButton(
      {super.key,
      required this.backgroundColor,
      this.function,
      required this.borderColor,
      required this.text,
      required this.textcolor});
  bool isfollowing = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
          width:250,
          height:27,
        ),
      ),
    );
  }
}
