import 'package:chat_app/utils/border_styles.dart';
import 'package:chat_app/utils/constant.dart';
import 'package:chat_app/utils/extras.dart';
import 'package:flutter/material.dart';

reusableTextField1(String display, TextEditingController mainController,
    bool isPassword, IconData icondata, TextInputType keyboard) {
  return Container(
    margin: const EdgeInsets.symmetric(
      vertical: 10,
    ),
    child: TextField(
      autofocus: false,
      autocorrect: false,
      obscureText: isPassword,
      style: const TextStyle(color: StandardColorLibrary.kColor6),
      decoration: InputDecoration(
        label: textFeldStyle(display, icondata, StandardColorLibrary.kColor2),
        border: KnormalBorder,
        enabledBorder: KnormalBorder,
        focusedBorder: KFocusedBorder,
        errorBorder: KErrorBorder,
        focusedErrorBorder: KFocusedBorder,
      ),
      keyboardType: keyboard,
      controller: mainController,
    ),
  );
}
