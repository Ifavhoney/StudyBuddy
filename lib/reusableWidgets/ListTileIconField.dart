import 'package:flutter/material.dart';

/*Combination of ListTile and Icon */
class ListTileIconField extends StatelessWidget {
  final Icon leadingIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  final Function function;

  const ListTileIconField(
      {this.leadingIcon,
      this.hintText,
      this.keyboardType,
      this.controller,
      this.isPassword = false,
      this.function});
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon,
      title: TextFormField(
          obscureText: isPassword == false ? false : isPassword,
          keyboardType: keyboardType,
          decoration:
              InputDecoration(hintText: hintText, fillColor: Colors.white),
          controller: this.controller,
          validator: function),
    );
  }
}
