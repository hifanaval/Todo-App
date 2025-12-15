import 'package:flutter/material.dart';

const String primaryFontName = 'RethinkSans';
const double textHeight = 1.2;

class TextStyleClass {
  static TextStyle primaryFont700(double size, Color color) {
    return TextStyle(
      fontFamily: primaryFontName,
      fontWeight: FontWeight.w700,
      color: color,
      height: textHeight,
      fontSize: size,
    );
  }

  static TextStyle primaryFont600(double size, Color color) {
    return TextStyle(
      fontFamily: primaryFontName,
      fontWeight: FontWeight.w600,
      color: color,
      height: textHeight,
      fontSize: size,
    );
  }

  static TextStyle primaryFont500(double size, Color color) {
    return TextStyle(
      fontFamily: primaryFontName,
      fontWeight: FontWeight.w500,
      color: color,
      height: textHeight,
      fontSize: size,
    );
  }

  static TextStyle primaryFont400(double size, Color color) {
    return TextStyle(
      fontFamily: primaryFontName,
      fontWeight: FontWeight.w400,
      color: color,
      height: textHeight,
      fontSize: size,
    );
  }
}

