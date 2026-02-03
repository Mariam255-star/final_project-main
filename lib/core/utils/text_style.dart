import 'package:flutter/material.dart';

class TextStyles {
  static const String defaultFont = 'YourFontName';

  static TextStyle titleLarge({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle titleMedium({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle titleSmall({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle subtitle({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle bodyLarge({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle body({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle caption({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle captionSmall({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle button({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: fontFamily,
    );
  }

  static TextStyle buttonSmall({
    Color? color,
    String fontFamily = defaultFont,
  }) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      fontFamily: fontFamily,
    );
  }
}
