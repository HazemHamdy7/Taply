// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breakpoint_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreakpointSetImpl _$$BreakpointSetImplFromJson(Map<String, dynamic> json) =>
    _$BreakpointSetImpl(
      breakpoints: (json['breakpoints'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$BreakpointSetImplToJson(_$BreakpointSetImpl instance) =>
    <String, dynamic>{
      'breakpoints': instance.breakpoints,
    };
