// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_constraint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LayoutConstraintImpl _$$LayoutConstraintImplFromJson(
        Map<String, dynamic> json) =>
    _$LayoutConstraintImpl(
      minWidth: (json['minWidth'] as num?)?.toDouble(),
      maxWidth: (json['maxWidth'] as num?)?.toDouble(),
      minHeight: (json['minHeight'] as num?)?.toDouble(),
      maxHeight: (json['maxHeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$LayoutConstraintImplToJson(
        _$LayoutConstraintImpl instance) =>
    <String, dynamic>{
      'minWidth': instance.minWidth,
      'maxWidth': instance.maxWidth,
      'minHeight': instance.minHeight,
      'maxHeight': instance.maxHeight,
    };
