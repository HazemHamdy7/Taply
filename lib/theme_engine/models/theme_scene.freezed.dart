// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_scene.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThemeScene _$ThemeSceneFromJson(Map<String, dynamic> json) {
  return _ThemeScene.fromJson(json);
}

/// @nodoc
mixin _$ThemeScene {
  String get id => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  @SceneNodeConverter()
  List<SceneNode> get nodes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeSceneCopyWith<ThemeScene> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeSceneCopyWith<$Res> {
  factory $ThemeSceneCopyWith(
          ThemeScene value, $Res Function(ThemeScene) then) =
      _$ThemeSceneCopyWithImpl<$Res, ThemeScene>;
  @useResult
  $Res call(
      {String id, String? label, @SceneNodeConverter() List<SceneNode> nodes});
}

/// @nodoc
class _$ThemeSceneCopyWithImpl<$Res, $Val extends ThemeScene>
    implements $ThemeSceneCopyWith<$Res> {
  _$ThemeSceneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = freezed,
    Object? nodes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<SceneNode>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeSceneImplCopyWith<$Res>
    implements $ThemeSceneCopyWith<$Res> {
  factory _$$ThemeSceneImplCopyWith(
          _$ThemeSceneImpl value, $Res Function(_$ThemeSceneImpl) then) =
      __$$ThemeSceneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String? label, @SceneNodeConverter() List<SceneNode> nodes});
}

/// @nodoc
class __$$ThemeSceneImplCopyWithImpl<$Res>
    extends _$ThemeSceneCopyWithImpl<$Res, _$ThemeSceneImpl>
    implements _$$ThemeSceneImplCopyWith<$Res> {
  __$$ThemeSceneImplCopyWithImpl(
      _$ThemeSceneImpl _value, $Res Function(_$ThemeSceneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = freezed,
    Object? nodes = null,
  }) {
    return _then(_$ThemeSceneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<SceneNode>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeSceneImpl implements _ThemeScene {
  const _$ThemeSceneImpl(
      {this.id = 'main',
      this.label,
      @SceneNodeConverter() final List<SceneNode> nodes = const []})
      : _nodes = nodes;

  factory _$ThemeSceneImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeSceneImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String? label;
  final List<SceneNode> _nodes;
  @override
  @JsonKey()
  @SceneNodeConverter()
  List<SceneNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  @override
  String toString() {
    return 'ThemeScene(id: $id, label: $label, nodes: $nodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeSceneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, label, const DeepCollectionEquality().hash(_nodes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeSceneImplCopyWith<_$ThemeSceneImpl> get copyWith =>
      __$$ThemeSceneImplCopyWithImpl<_$ThemeSceneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeSceneImplToJson(
      this,
    );
  }
}

abstract class _ThemeScene implements ThemeScene {
  const factory _ThemeScene(
      {final String id,
      final String? label,
      @SceneNodeConverter() final List<SceneNode> nodes}) = _$ThemeSceneImpl;

  factory _ThemeScene.fromJson(Map<String, dynamic> json) =
      _$ThemeSceneImpl.fromJson;

  @override
  String get id;
  @override
  String? get label;
  @override
  @SceneNodeConverter()
  List<SceneNode> get nodes;
  @override
  @JsonKey(ignore: true)
  _$$ThemeSceneImplCopyWith<_$ThemeSceneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
