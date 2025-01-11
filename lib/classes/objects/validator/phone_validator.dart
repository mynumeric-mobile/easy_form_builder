import 'package:easy_form_builder/classes/helper/localization.dart';

import 'validator.dart';

class PhoneValidator extends Validator {
  final String? message;

  ///
  /// Phone validator
  ///
  PhoneValidator({this.message});

  @override
  String get errorMessage => message ?? localizationOptions.invalidPhone;

  @override
  bool isValid(value, Map<String, dynamic> paramValues) {
    var phone = value as String?;

    if (phone == null || phone == "") {
      return true;
    }
    RegExp emailRegExp =
        RegExp(r"^(?:(?:\+|00)33[\s.-]{0,3}(?:\(0\)[\s.-]{0,3})?|0)[1-9](?:(?:[\s.-]?\d{2}){4}|\d{2}(?:[\s.-]?\d{3}){2})$");

    return emailRegExp.hasMatch(phone);
  }
}
