import 'package:chat_app_asper/utils/constant.dart';
import 'package:flutter/material.dart';

Row messageBubble(String msg, bool me) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: me ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
              color: me
                  ? StandardColorLibrary.kColor1
                  : StandardColorLibrary.kColor8,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              msg,
              style: const TextStyle(
                color: StandardColorLibrary.kColor6,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
