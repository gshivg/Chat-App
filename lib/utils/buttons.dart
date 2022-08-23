// ignore_for_file: camel_case_types, must_be_immutable, sized_box_for_whitespace

import 'package:chat_app_asper/utils/constant.dart';
import 'package:flutter/material.dart';

class button1 extends StatefulWidget {
  button1(
      {Key? key,
      this.onTap,
      required this.cont2,
      required this.display,
      this.colour1 = StandardColorLibrary.kColor1,
      this.colour2 = StandardColorLibrary.kColor3})
      : super(key: key);
  Function? onTap;
  BuildContext? cont2;
  String display;
  Color colour1 = StandardColorLibrary.kColor1;
  Color colour2 = StandardColorLibrary.kColor3;
  @override
  State<button1> createState() => _button1State();
}

class _button1State extends State<button1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      child: ElevatedButton(
        onPressed: (() {
          widget.onTap;
        }),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return widget.colour1;
            }
            return widget.colour2;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        ),
        child: Text(
          widget.display,
          style: const TextStyle(
            color: StandardColorLibrary.kColor6,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class button2 extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;
  final double forWidth;
  const button2({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
    required this.forWidth,
  }) : super(key: key);
  @override
  State<button2> createState() => _button2State();
}

class _button2State extends State<button2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: widget.forWidth,
      child: ElevatedButton(
        onPressed: widget.onClicked,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return StandardColorLibrary.kColor1;
            }
            return StandardColorLibrary.kColor3;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 28,
              color: StandardColorLibrary.kColor2,
            ),
            const SizedBox(width: 16),
            Text(
              widget.text,
              style: const TextStyle(
                color: StandardColorLibrary.kColor6,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
