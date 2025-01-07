import 'package:flutter/material.dart';

import 'validator/validator.dart';

class DfParam {
  DfCfgParam cfg;
  dynamic value;

  DfParam(this.cfg, this.value);

  get isEmptyOrNullString => (value as String?)?.isEmpty ?? true;

  static Map<String, dynamic> removeEmpties(Map<String, dynamic> param) {
    Map<String, dynamic> result = {};
    for (var e in param.entries) {
      if (e.value is! DfParam) {
        result[e.key] = e.value;
      } else {
        DfParam p = e as DfParam;
        if (p.value != p.cfg.defaultValue) {
          result[e.key] = e.value;
        }
      }
    }

    return result;
  }
}

class DfCfgParam {
  String id;
  String title;
  String? comment;
  Type type;

  /// set to true if field is a date with time
  bool includeTimeInDateTime;

  /// field is read only
  bool readOnly = false;

  /// optional function field is displayed if returned value is true
  Function? isDisplayable;

  /// field use wildcard
  bool isPassword;

  /// default value for the field
  dynamic defaultValue;

  /// icon for the field
  Icon? icon;

  /// deliver values for dropdownlist
  DfSource? dataSource;

  /// define for textfield max number of line
  int maxTextFieldLine;

  /// allow display enlaged field (for example for comment)
  int? usedColumn;

  List<Validator>? validators;

  DfCfgParam(
      {required this.id,
      required this.type,
      this.title = "",
      this.includeTimeInDateTime = false,
      this.isPassword = false,
      this.icon,
      this.defaultValue,
      this.readOnly = false,
      this.comment,
      this.dataSource,
      this.usedColumn,
      this.isDisplayable,
      this.maxTextFieldLine = 1,
      this.validators});

  castValue(dynamic val) {
    switch (type) {
      case const (double):
        return double.tryParse(val
            .toString()); //for some case double become int force so val to double
      case const (int):
        return int.tryParse(val.toString());
      case const (num):
        return num.tryParse(val.toString());
      default:
        return val;
    }
  }

  // String get toJson {
  //   return jsonEncode(this, toEncodable: (value) {
  //     switch (value.runtimeType) {
  //       case Color:
  //         return value.toString();
  //       case DateTime:
  //         return value == null ? null : (value as DateTime).toIso8601String();
  //       default:
  //         return json.encode(value);
  //     }
  //   });
  // }
}

class DfSource {
  String id;
  String title;
  String? comment;
  bool fontFamilyMode;

  Map<dynamic, dynamic> keysValues;
  List<dynamic> values;

  DfSource(
      {this.title = "",
      required this.id,
      this.comment,
      Map<dynamic, dynamic>? values,
      List<dynamic>? valuesList,
      this.fontFamilyMode = false})
      : keysValues = values ?? {},
        values = valuesList ?? [];
}
