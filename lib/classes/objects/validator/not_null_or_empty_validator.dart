import 'package:easy_form_builder/classes/helper.dart/localization.dart';

import 'validator.dart';

class NotNullOrEmptyValidator extends Validator {
  final String? message;

  NotNullOrEmptyValidator({this.message});

  @override
  String get errorMessage => message ?? localizationOptions.emptyField;

  @override
  bool isValid(value, Map<String, dynamic> paramValues) {
    return value != null && (value! is String && value.isNotEmpty);
  }
}
