import 'package:chat_app/utils/constant.dart';
import 'package:flutter/material.dart';

textFeldStyle(String text, IconData iconData, Color colour) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        iconData,
        color: colour,
      ),
      const SizedBox(
        width: 15,
      ),
      Text(
        text,
        style: TextStyle(
          color: colour,
        ),
      ),
    ],
  );
}

textStyleRow(String text1, String text2, Color colour) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text2,
        style: TextStyle(
          color: colour,
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      Text(
        text2,
        style: TextStyle(
          color: colour,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

text3() {
  return Text(
    'You will receive an SMS on your phone number\nfor verfication. Standard rates may apply.',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: StandardColorLibrary.kColor2.withOpacity(0.5),
    ),
  );
}
