// ignore_for_file: unnecessary_const, constant_identifier_names

import 'package:flutter/material.dart';

class StandardColorLibrary {
  static const kColor1 = const Color(0xFFF6572A);
  static const kColor2 = const Color(0xFF28CA42);
  static const kColor3 = const Color(0xFF0D6EFD);
  static const kColor4 = const Color(0xFF1E1E1E);
  static const kColor5 = const Color(0xFFDC3545);
  static const kColor6 = const Color(0xFFF8F8F8);
  static const kColor7 = const Color(0xFFD63384);
  static const kColor8 = const Color(0xFF6F42C1);

  static hexStringToColour(String hexColour) {
    hexColour = hexColour.toUpperCase().replaceAll('#', '');
    if (hexColour.length == 6) {
      hexColour = 'FF$hexColour';
    }
    return Color(int.parse(hexColour, radix: 16));
  }
}
