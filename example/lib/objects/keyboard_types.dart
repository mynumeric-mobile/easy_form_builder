import 'dart:io';

import 'package:flutter/material.dart';

/// alphabet: all letters, return, backspace, shift, space.
/// numeric: 0-9, return, backspace.
/// alphaEmail: all letters, 0-9, [. - _ @], @gmail.com.
enum KeyboardTypes { alphabet, numeric, alphaEmail }

extension KeyboardTypesExtension on KeyboardTypes {
  List<List> get keyboard {
    switch (this) {
      case KeyboardTypes.alphabet:
        List<List<dynamic>> rows = [];
        rows.add(KeyboardHelper.alphaRows);
        rows.add([":", "SPACE", "."]);
        return rows;
      case KeyboardTypes.numeric:
        return [
          ["1", "2", "3"],
          ["4", "5", "6"],
          ["7", "8", "9"],
          ["BACKSPACE", "0", "RETURN"],
        ];
      case KeyboardTypes.alphaEmail:
        List<List<dynamic>> rows = [
          ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        ];

        for (List<dynamic> r in KeyboardHelper.alphaRows) {
          rows.add(r);
        }

        rows.add([".", "~", "!", "%", "^", "&", "*", "=", "+", "{", "}", "'", "?", "-"]);
        rows.add(["@", "SPACE", "_"]);
        return rows;
    }
  }
}

class KeyboardHelper {
  static List<dynamic> get alphaRows => Platform.localeName.toLowerCase().startsWith("fr")
      ? [
          ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "BACKSPACE"],
          ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "RETURN"],
          ["SHIFT", "w", "x", "c", "v", "b", "n", ",", "SHIFT"],
        ]
      : [
          ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "BACKSPACE"],
          ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ç", "RETURN"],
          ["SHIFT", "z", "x", "c", "v", "b", "n", "m", "SHIFT"],
        ];
}
