import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF00EEFF);
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color bootBackground = Color(0xFF111317);
  static const Color glassBorder = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color glassBg = Color.fromRGBO(20, 20, 20, 0.6);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Color.fromRGBO(255, 255, 255, 0.7);
}

class AppTextStyles {
  static TextStyle get display => GoogleFonts.spaceGrotesk();

  static TextStyle get navLink => display.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite70,
  );

  static TextStyle get heroTitle => display.copyWith(
    fontWeight: FontWeight.bold,
    height: 1.1,
    letterSpacing: -1.0,
    color: Colors.white,
  );

  static TextStyle get heroSubtitle => display.copyWith(
    fontSize: 24, // 2xl defaults
    fontWeight: FontWeight.w500,
    color: const Color.fromRGBO(255, 255, 255, 0.9),
  );

  static TextStyle get body => display.copyWith(
    color: const Color.fromRGBO(255, 255, 255, 0.6),
    fontWeight: FontWeight.w300,
    height: 1.6,
  );
}
