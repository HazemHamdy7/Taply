// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationReportImpl _$$ValidationReportImplFromJson(
        Map<String, dynamic> json) =>
    _$ValidationReportImpl(
      isValid: json['isValid'] as bool? ?? true,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => ValidationIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => ValidationIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => ValidationIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      errorCount: (json['errorCount'] as num?)?.toInt() ?? 0,
      warningCount: (json['warningCount'] as num?)?.toInt() ?? 0,
      suggestionCount: (json['suggestionCount'] as num?)?.toInt() ?? 0,
      executionTime: json['executionTime'] == null
          ? null
          : Duration(microseconds: (json['executionTime'] as num).toInt()),
    );

Map<String, dynamic> _$$ValidationReportImplToJson(
        _$ValidationReportImpl instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'errors': instance.errors,
      'warnings': instance.warnings,
      'suggestions': instance.suggestions,
      'errorCount': instance.errorCount,
      'warningCount': instance.warningCount,
      'suggestionCount': instance.suggestionCount,
      'executionTime': instance.executionTime?.inMicroseconds,
    };
