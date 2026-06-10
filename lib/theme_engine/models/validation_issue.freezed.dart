// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validation_issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidationIssue _$ValidationIssueFromJson(Map<String, dynamic> json) {
  return _ValidationIssue.fromJson(json);
}

/// @nodoc
mixin _$ValidationIssue {
  String get code => throw _privateConstructorUsedError;
  ValidationSeverity get severity => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get jsonPath => throw _privateConstructorUsedError;
  String? get field => throw _privateConstructorUsedError;
  String? get expected => throw _privateConstructorUsedError;
  String? get actual => throw _privateConstructorUsedError;
  String? get documentationUrl => throw _privateConstructorUsedError;
  String? get autoFixHint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ValidationIssueCopyWith<ValidationIssue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationIssueCopyWith<$Res> {
  factory $ValidationIssueCopyWith(
          ValidationIssue value, $Res Function(ValidationIssue) then) =
      _$ValidationIssueCopyWithImpl<$Res, ValidationIssue>;
  @useResult
  $Res call(
      {String code,
      ValidationSeverity severity,
      String message,
      String jsonPath,
      String? field,
      String? expected,
      String? actual,
      String? documentationUrl,
      String? autoFixHint});
}

/// @nodoc
class _$ValidationIssueCopyWithImpl<$Res, $Val extends ValidationIssue>
    implements $ValidationIssueCopyWith<$Res> {
  _$ValidationIssueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? severity = null,
    Object? message = null,
    Object? jsonPath = null,
    Object? field = freezed,
    Object? expected = freezed,
    Object? actual = freezed,
    Object? documentationUrl = freezed,
    Object? autoFixHint = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ValidationSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      jsonPath: null == jsonPath
          ? _value.jsonPath
          : jsonPath // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      expected: freezed == expected
          ? _value.expected
          : expected // ignore: cast_nullable_to_non_nullable
              as String?,
      actual: freezed == actual
          ? _value.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as String?,
      documentationUrl: freezed == documentationUrl
          ? _value.documentationUrl
          : documentationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      autoFixHint: freezed == autoFixHint
          ? _value.autoFixHint
          : autoFixHint // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationIssueImplCopyWith<$Res>
    implements $ValidationIssueCopyWith<$Res> {
  factory _$$ValidationIssueImplCopyWith(_$ValidationIssueImpl value,
          $Res Function(_$ValidationIssueImpl) then) =
      __$$ValidationIssueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      ValidationSeverity severity,
      String message,
      String jsonPath,
      String? field,
      String? expected,
      String? actual,
      String? documentationUrl,
      String? autoFixHint});
}

/// @nodoc
class __$$ValidationIssueImplCopyWithImpl<$Res>
    extends _$ValidationIssueCopyWithImpl<$Res, _$ValidationIssueImpl>
    implements _$$ValidationIssueImplCopyWith<$Res> {
  __$$ValidationIssueImplCopyWithImpl(
      _$ValidationIssueImpl _value, $Res Function(_$ValidationIssueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? severity = null,
    Object? message = null,
    Object? jsonPath = null,
    Object? field = freezed,
    Object? expected = freezed,
    Object? actual = freezed,
    Object? documentationUrl = freezed,
    Object? autoFixHint = freezed,
  }) {
    return _then(_$ValidationIssueImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ValidationSeverity,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      jsonPath: null == jsonPath
          ? _value.jsonPath
          : jsonPath // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      expected: freezed == expected
          ? _value.expected
          : expected // ignore: cast_nullable_to_non_nullable
              as String?,
      actual: freezed == actual
          ? _value.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as String?,
      documentationUrl: freezed == documentationUrl
          ? _value.documentationUrl
          : documentationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      autoFixHint: freezed == autoFixHint
          ? _value.autoFixHint
          : autoFixHint // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidationIssueImpl implements _ValidationIssue {
  const _$ValidationIssueImpl(
      {required this.code,
      required this.severity,
      required this.message,
      required this.jsonPath,
      this.field,
      this.expected,
      this.actual,
      this.documentationUrl,
      this.autoFixHint});

  factory _$ValidationIssueImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidationIssueImplFromJson(json);

  @override
  final String code;
  @override
  final ValidationSeverity severity;
  @override
  final String message;
  @override
  final String jsonPath;
  @override
  final String? field;
  @override
  final String? expected;
  @override
  final String? actual;
  @override
  final String? documentationUrl;
  @override
  final String? autoFixHint;

  @override
  String toString() {
    return 'ValidationIssue(code: $code, severity: $severity, message: $message, jsonPath: $jsonPath, field: $field, expected: $expected, actual: $actual, documentationUrl: $documentationUrl, autoFixHint: $autoFixHint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationIssueImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.jsonPath, jsonPath) ||
                other.jsonPath == jsonPath) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.expected, expected) ||
                other.expected == expected) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.documentationUrl, documentationUrl) ||
                other.documentationUrl == documentationUrl) &&
            (identical(other.autoFixHint, autoFixHint) ||
                other.autoFixHint == autoFixHint));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, severity, message,
      jsonPath, field, expected, actual, documentationUrl, autoFixHint);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationIssueImplCopyWith<_$ValidationIssueImpl> get copyWith =>
      __$$ValidationIssueImplCopyWithImpl<_$ValidationIssueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidationIssueImplToJson(
      this,
    );
  }
}

abstract class _ValidationIssue implements ValidationIssue {
  const factory _ValidationIssue(
      {required final String code,
      required final ValidationSeverity severity,
      required final String message,
      required final String jsonPath,
      final String? field,
      final String? expected,
      final String? actual,
      final String? documentationUrl,
      final String? autoFixHint}) = _$ValidationIssueImpl;

  factory _ValidationIssue.fromJson(Map<String, dynamic> json) =
      _$ValidationIssueImpl.fromJson;

  @override
  String get code;
  @override
  ValidationSeverity get severity;
  @override
  String get message;
  @override
  String get jsonPath;
  @override
  String? get field;
  @override
  String? get expected;
  @override
  String? get actual;
  @override
  String? get documentationUrl;
  @override
  String? get autoFixHint;
  @override
  @JsonKey(ignore: true)
  _$$ValidationIssueImplCopyWith<_$ValidationIssueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
