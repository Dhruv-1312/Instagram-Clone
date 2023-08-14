import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  bool ispass;
  final String hintext;
  final TextInputType textInputType;
  TextFieldInput(
      {super.key,
      required this.textEditingController,
      this.ispass=false,
      required this.hintext,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context),borderRadius: BorderRadius.circular(12));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintext,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}
