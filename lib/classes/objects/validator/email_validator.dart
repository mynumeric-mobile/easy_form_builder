import 'package:easy_form_builder/classes/helper/localization.dart';

import 'validator.dart';

class EmailValidator extends Validator {
  final String? message;

  EmailValidator({this.message});

  @override
  String get errorMessage => message ?? localizationOptions.invalidEmail;

  @override
  bool isValid(value, Map<String, dynamic> paramValues) {
    var email = value as String?;

    if (email == null || email == "") {
      return true;
    }
    RegExp emailRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    return emailRegExp.hasMatch(email);
  }
}
