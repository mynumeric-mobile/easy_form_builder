import 'package:easy_form_builder/classes/helper.dart/localization.dart';

import 'validator.dart';

class TextLengthValidator extends Validator {
  final int requiredLength;
  final String? message;

  ///
  /// Text length validator
  ///
  TextLengthValidator(this.requiredLength, {this.message});

  @override
  String get errorMessage => message ?? localizationOptions.invalidCharacterNumber;

  @override
  bool isValid(value, Map<String, dynamic> paramValues) {
    var str = value as String?;

    if (str == null) {
      return false;
    }

    return str.length == requiredLength;
  }
}
