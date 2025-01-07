import 'package:easy_form_builder/classes/helper.dart/localization.dart';

import 'validator.dart';

class RegexpValidator extends Validator {
  final String? message;
  final RegExp regExp;

  RegexpValidator(this.regExp, {this.message});

  @override
  String get errorMessage => message ?? localizationOptions.invalidFormat;

  @override
  bool isValid(value, Map<String, dynamic> paramValues) {
    var str = value as String?;

    if (str == null) {
      return true;
    }
    RegExp emailRegExp = regExp;

    return emailRegExp.hasMatch(str);
  }
}
