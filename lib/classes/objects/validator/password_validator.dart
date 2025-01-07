import 'package:easy_form_builder/classes/helper.dart/localization.dart';

import 'validator.dart';

class PasswordValidator extends Validator {
  final String? message;

  ///
  /// Password validator
  ///
  PasswordValidator({this.message});

  @override
  String get errorMessage => message ?? localizationOptions.invalidPassword;

  @override
  bool isValid(value, Map<String, dynamic> paramValues) {
    var password = value as String?;

    if (password == null) {
      return true;
    }
    RegExp emailRegExp = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[$&+,:;=?@#|'<>.^*()%!-]).{8,}$");

    return emailRegExp.hasMatch(password);
  }
}
