/// Validates a field value.
class FieldValidator {
  final bool Function(String value) validate;

  const FieldValidator({required this.validate});

  bool isValid(String value) => validate(value);

  static final FieldValidator email = FieldValidator(
    validate: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v),
  );

  static final FieldValidator phone = FieldValidator(
    validate: (v) => RegExp(r'^[\d\s\+\-\(\)]{7,15}$').hasMatch(v),
  );

  static final FieldValidator url = FieldValidator(
    validate: (v) => RegExp(r'^https?://\S+$').hasMatch(v),
  );

  static final FieldValidator nonEmpty = FieldValidator(
    validate: (v) => v.trim().isNotEmpty,
  );

  static FieldValidator minLength(int min) =>
      FieldValidator(validate: (v) => v.length >= min);

  static FieldValidator maxLength(int max) =>
      FieldValidator(validate: (v) => v.length <= max);

  static FieldValidator regex(String pattern) =>
      FieldValidator(validate: (v) => RegExp(pattern).hasMatch(v));
}
