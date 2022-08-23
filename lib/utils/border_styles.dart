// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

import 'constant.dart';

const KnormalBorder = OutlineInputBorder(
  borderSide: BorderSide(
    width: 1,
    style: BorderStyle.solid,
    color: StandardColorLibrary.kColor2,
  ),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15),
    bottomRight: Radius.circular(15),
  ),
);
const KFocusedBorder = OutlineInputBorder(
  borderSide: BorderSide(
    width: 2,
    style: BorderStyle.solid,
    color: StandardColorLibrary.kColor2,
  ),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15),
    bottomRight: Radius.circular(15),
  ),
);
const KErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(
    width: 2,
    style: BorderStyle.solid,
    color: StandardColorLibrary.kColor1,
  ),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15),
    bottomRight: Radius.circular(15),
  ),
);

const kChatRoomBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
  borderSide: BorderSide(
    
  ),
);
