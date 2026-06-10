// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validation_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidationReport _$ValidationReportFromJson(Map<String, dynamic> json) {
  return _ValidationReport.fromJson(json);
}

/// @nodoc
mixin _$ValidationReport {
  bool get isValid => throw _privateConstructorUsedError;
  List<ValidationIssue> get errors => throw _privateConstructorUsedError;
  List<ValidationIssue> get warnings => throw _privateConstructorUsedError;
  List<ValidationIssue> get suggestions => throw _privateConstructorUsedError;
  int get errorCount => throw _privateConstructorUsedError;
  int get warningCount => throw _privateConstructorUsedError;
  int get suggestionCount => throw _privateConstructorUsedError;
  Duration? get executionTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ValidationReportCopyWith<ValidationReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationReportCopyWith<$Res> {
  factory $ValidationReportCopyWith(
          ValidationReport value, $Res Function(ValidationReport) then) =
      _$ValidationReportCopyWithImpl<$Res, ValidationReport>;
  @useResult
  $Res call(
      {bool isValid,
      List<ValidationIssue> errors,
      List<ValidationIssue> warnings,
      List<ValidationIssue> suggestions,
      int errorCount,
      int warningCount,
      int suggestionCount,
      Duration? executionTime});
}

/// @nodoc
class _$ValidationReportCopyWithImpl<$Res, $Val extends ValidationReport>
    implements $ValidationReportCopyWith<$Res> {
  _$ValidationReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = null,
    Object? warnings = null,
    Object? suggestions = null,
    Object? errorCount = null,
    Object? warningCount = null,
    Object? suggestionCount = null,
    Object? executionTime = freezed,
  }) {
    return _then(_value.copyWith(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
      errorCount: null == errorCount
          ? _value.errorCount
          : errorCount // ignore: cast_nullable_to_non_nullable
              as int,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      suggestionCount: null == suggestionCount
          ? _value.suggestionCount
          : suggestionCount // ignore: cast_nullable_to_non_nullable
              as int,
      executionTime: freezed == executionTime
          ? _value.executionTime
          : executionTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationReportImplCopyWith<$Res>
    implements $ValidationReportCopyWith<$Res> {
  factory _$$ValidationReportImplCopyWith(_$ValidationReportImpl value,
          $Res Function(_$ValidationReportImpl) then) =
      __$$ValidationReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isValid,
      List<ValidationIssue> errors,
      List<ValidationIssue> warnings,
      List<ValidationIssue> suggestions,
      int errorCount,
      int warningCount,
      int suggestionCount,
      Duration? executionTime});
}

/// @nodoc
class __$$ValidationReportImplCopyWithImpl<$Res>
    extends _$ValidationReportCopyWithImpl<$Res, _$ValidationReportImpl>
    implements _$$ValidationReportImplCopyWith<$Res> {
  __$$ValidationReportImplCopyWithImpl(_$ValidationReportImpl _value,
      $Res Function(_$ValidationReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = null,
    Object? warnings = null,
    Object? suggestions = null,
    Object? errorCount = null,
    Object? warningCount = null,
    Object? suggestionCount = null,
    Object? executionTime = freezed,
  }) {
    return _then(_$ValidationReportImpl(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<ValidationIssue>,
      errorCount: null == errorCount
          ? _value.errorCount
          : errorCount // ignore: cast_nullable_to_non_nullable
              as int,
      warningCount: null == warningCount
          ? _value.warningCount
          : warningCount // ignore: cast_nullable_to_non_nullable
              as int,
      suggestionCount: null == suggestionCount
          ? _value.suggestionCount
          : suggestionCount // ignore: cast_nullable_to_non_nullable
              as int,
      executionTime: freezed == executionTime
          ? _value.executionTime
          : executionTime // ignore: cast_nullable_to_non_nullable
              as Duration?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidationReportImpl extends _ValidationReport {
  const _$ValidationReportImpl(
      {this.isValid = true,
      final List<ValidationIssue> errors = const [],
      final List<ValidationIssue> warnings = const [],
      final List<ValidationIssue> suggestions = const [],
      this.errorCount = 0,
      this.warningCount = 0,
      this.suggestionCount = 0,
      this.executionTime})
      : _errors = errors,
        _warnings = warnings,
        _suggestions = suggestions,
        super._();

  factory _$ValidationReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidationReportImplFromJson(json);

  @override
  @JsonKey()
  final bool isValid;
  final List<ValidationIssue> _errors;
  @override
  @JsonKey()
  List<ValidationIssue> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  final List<ValidationIssue> _warnings;
  @override
  @JsonKey()
  List<ValidationIssue> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  final List<ValidationIssue> _suggestions;
  @override
  @JsonKey()
  List<ValidationIssue> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  @JsonKey()
  final int errorCount;
  @override
  @JsonKey()
  final int warningCount;
  @override
  @JsonKey()
  final int suggestionCount;
  @override
  final Duration? executionTime;

  @override
  String toString() {
    return 'ValidationReport(isValid: $isValid, errors: $errors, warnings: $warnings, suggestions: $suggestions, errorCount: $errorCount, warningCount: $warningCount, suggestionCount: $suggestionCount, executionTime: $executionTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationReportImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.errorCount, errorCount) ||
                other.errorCount == errorCount) &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.suggestionCount, suggestionCount) ||
                other.suggestionCount == suggestionCount) &&
            (identical(other.executionTime, executionTime) ||
                other.executionTime == executionTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isValid,
      const DeepCollectionEquality().hash(_errors),
      const DeepCollectionEquality().hash(_warnings),
      const DeepCollectionEquality().hash(_suggestions),
      errorCount,
      warningCount,
      suggestionCount,
      executionTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationReportImplCopyWith<_$ValidationReportImpl> get copyWith =>
      __$$ValidationReportImplCopyWithImpl<_$ValidationReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidationReportImplToJson(
      this,
    );
  }
}

abstract class _ValidationReport extends ValidationReport {
  const factory _ValidationReport(
      {final bool isValid,
      final List<ValidationIssue> errors,
      final List<ValidationIssue> warnings,
      final List<ValidationIssue> suggestions,
      final int errorCount,
      final int warningCount,
      final int suggestionCount,
      final Duration? executionTime}) = _$ValidationReportImpl;
  const _ValidationReport._() : super._();

  factory _ValidationReport.fromJson(Map<String, dynamic> json) =
      _$ValidationReportImpl.fromJson;

  @override
  bool get isValid;
  @override
  List<ValidationIssue> get errors;
  @override
  List<ValidationIssue> get warnings;
  @override
  List<ValidationIssue> get suggestions;
  @override
  int get errorCount;
  @override
  int get warningCount;
  @override
  int get suggestionCount;
  @override
  Duration? get executionTime;
  @override
  @JsonKey(ignore: true)
  _$$ValidationReportImplCopyWith<_$ValidationReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
