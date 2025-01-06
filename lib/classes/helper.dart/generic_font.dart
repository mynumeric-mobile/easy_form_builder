import 'package:dynamic_fonts/dynamic_fonts.dart';
import 'package:flutter/material.dart';

class GenericFontHelper {
  static TextStyle getDynamicStyle({fontFamily, double? fontSize, fontWeight, fontStyle, color}) {
    var ts = TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color, fontStyle: fontStyle);
    return fontFamily[0] == "*"
        ? DynamicFonts.asMap().containsKey(fontFamily.substring(1))
            ? DynamicFonts.getFont(fontFamily.substring(1), textStyle: ts)
            : ts
        : ts.copyWith(fontFamily: fontFamily);
  }
}

class GenericFont extends DynamicFontsFile {
  GenericFont(this.downloadUrl, this.variant, String expectedFileHash, int expectedLength)
      : super(expectedFileHash, expectedLength);

  final DynamicFontsVariant variant;
  final String downloadUrl;

  @override
  String get url => downloadUrl;
}
