// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeStateImpl _$$ThemeStateImplFromJson(Map<String, dynamic> json) =>
    _$ThemeStateImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => const SceneNodeConverter()
                  .fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ThemeStateImplToJson(_$ThemeStateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'nodes': instance.nodes.map(const SceneNodeConverter().toJson).toList(),
    };
