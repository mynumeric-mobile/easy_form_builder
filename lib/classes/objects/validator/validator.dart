// Objective: Create a validator class to validate input values.
abstract class Validator {
  bool isValid(value, Map<String, dynamic> paramValues);

  String get errorMessage;
}
