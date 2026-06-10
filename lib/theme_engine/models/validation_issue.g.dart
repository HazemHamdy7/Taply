// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationIssueImpl _$$ValidationIssueImplFromJson(
        Map<String, dynamic> json) =>
    _$ValidationIssueImpl(
      code: json['code'] as String,
      severity: $enumDecode(_$ValidationSeverityEnumMap, json['severity']),
      message: json['message'] as String,
      jsonPath: json['jsonPath'] as String,
      field: json['field'] as String?,
      expected: json['expected'] as String?,
      actual: json['actual'] as String?,
      documentationUrl: json['documentationUrl'] as String?,
      autoFixHint: json['autoFixHint'] as String?,
    );

Map<String, dynamic> _$$ValidationIssueImplToJson(
        _$ValidationIssueImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'severity': _$ValidationSeverityEnumMap[instance.severity]!,
      'message': instance.message,
      'jsonPath': instance.jsonPath,
      'field': instance.field,
      'expected': instance.expected,
      'actual': instance.actual,
      'documentationUrl': instance.documentationUrl,
      'autoFixHint': instance.autoFixHint,
    };

const _$ValidationSeverityEnumMap = {
  ValidationSeverity.info: 'info',
  ValidationSeverity.warning: 'warning',
  ValidationSeverity.error: 'error',
  ValidationSeverity.fatal: 'fatal',
};
