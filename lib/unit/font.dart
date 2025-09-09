import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KantumruyFont {
  // Kantumruy Pro font with different weights
  static TextStyle kantumruyPro({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return GoogleFonts.kantumruyPro(
      fontWeight: fontWeight ?? FontWeight.w400,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle ?? FontStyle.normal,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  // Convenience methods for different weights
  static TextStyle light({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w300,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle regular({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle medium({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle semiBold({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle bold({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  // Specific weight methods (100-700)
  static TextStyle w100({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w100,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle w200({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w200,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle w300({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w300,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle w400({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle w500({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle w600({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }

  static TextStyle w700({
    double? fontSize,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    double? height,
  }) {
    return kantumruyPro(
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      height: height,
    );
  }
}
