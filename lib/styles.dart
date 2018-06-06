import 'package:flutter/material.dart';

class SStyles {
  static const MaterialColor akaneColorSwatch = const MaterialColor(
    akaneColor,
    const <int, Color>{
      50: const Color(0xFFFFEBEE),
      100: const Color(0xFFFFCDD2),
      200: const Color(0xFFEF9A9A),
      300: const Color(0xFFE57373),
      400: const Color(0xFFEF5350),
      500: const Color(akaneColor),
      600: const Color(0xFFE53935),
      700: const Color(0xFFD32F2F),
      800: const Color(0xFFC62828),
      900: const Color(0xFFB71C1C),
    },
  );
  static const int akaneColor = 0xFFEA4242;
  static const MaterialColor dustColorSwatch = const MaterialColor(
    dustColor, 
    const <int, Color>{
      50: const Color(ceramicColor),
      300: const Color(dustColor),
      800: const Color(lightInkColor),
      900: const Color(inkColor),
    }
    );
  static const int ceramicColor = 0xFFF0F4F4;
  static const int dustColor = 0xFFA79599;
  static const int lightInkColor = 0xFF333132;
  static const int inkColor = 0xFF231F20;

  // Text Themes
  static const TextTheme mainTextTheme = const TextTheme(
    body1: const TextStyle(
      color: const Color(ceramicColor),
      fontFamily: 'DDIN'
    ),
    body2: const TextStyle(
      color: const Color(ceramicColor),
      fontFamily: 'DDIN',
      fontWeight: FontWeight.w600
    ),
    display4: const TextStyle(
      color: const Color(ceramicColor),
      fontFamily: 'DDIN_Cond',
      fontSize: 64.0,
    )
  );

}
