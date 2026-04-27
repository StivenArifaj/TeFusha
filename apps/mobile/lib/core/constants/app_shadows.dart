import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x4DE8002D),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, -4),
    ),
  ];
}
