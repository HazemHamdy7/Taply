// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_scene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeSceneImpl _$$ThemeSceneImplFromJson(Map<String, dynamic> json) =>
    _$ThemeSceneImpl(
      id: json['id'] as String? ?? 'main',
      label: json['label'] as String?,
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((e) => const SceneNodeConverter()
                  .fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ThemeSceneImplToJson(_$ThemeSceneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'nodes': instance.nodes.map(const SceneNodeConverter().toJson).toList(),
    };
