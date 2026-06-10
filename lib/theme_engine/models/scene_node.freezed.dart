// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SceneNode {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  bool get visible => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;
  Map<String, dynamic> get properties => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String? name,
            bool visible,
            double opacity,
            List<SceneNode> children,
            Map<String, dynamic> properties)
        group,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        paint,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        widget,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GroupNode value) group,
    required TResult Function(PaintNode value) paint,
    required TResult Function(WidgetNode value) widget,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GroupNode value)? group,
    TResult? Function(PaintNode value)? paint,
    TResult? Function(WidgetNode value)? widget,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GroupNode value)? group,
    TResult Function(PaintNode value)? paint,
    TResult Function(WidgetNode value)? widget,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SceneNodeCopyWith<SceneNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SceneNodeCopyWith<$Res> {
  factory $SceneNodeCopyWith(SceneNode value, $Res Function(SceneNode) then) =
      _$SceneNodeCopyWithImpl<$Res, SceneNode>;
  @useResult
  $Res call(
      {String id,
      String? name,
      bool visible,
      double opacity,
      Map<String, dynamic> properties});
}

/// @nodoc
class _$SceneNodeCopyWithImpl<$Res, $Val extends SceneNode>
    implements $SceneNodeCopyWith<$Res> {
  _$SceneNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? visible = null,
    Object? opacity = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupNodeImplCopyWith<$Res>
    implements $SceneNodeCopyWith<$Res> {
  factory _$$GroupNodeImplCopyWith(
          _$GroupNodeImpl value, $Res Function(_$GroupNodeImpl) then) =
      __$$GroupNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? name,
      bool visible,
      double opacity,
      List<SceneNode> children,
      Map<String, dynamic> properties});
}

/// @nodoc
class __$$GroupNodeImplCopyWithImpl<$Res>
    extends _$SceneNodeCopyWithImpl<$Res, _$GroupNodeImpl>
    implements _$$GroupNodeImplCopyWith<$Res> {
  __$$GroupNodeImplCopyWithImpl(
      _$GroupNodeImpl _value, $Res Function(_$GroupNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? visible = null,
    Object? opacity = null,
    Object? children = null,
    Object? properties = null,
  }) {
    return _then(_$GroupNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<SceneNode>,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$GroupNodeImpl implements GroupNode {
  const _$GroupNodeImpl(
      {required this.id,
      this.name,
      this.visible = true,
      this.opacity = 1.0,
      final List<SceneNode> children = const [],
      final Map<String, dynamic> properties = const {}})
      : _children = children,
        _properties = properties;

  @override
  final String id;
  @override
  final String? name;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey()
  final double opacity;
  final List<SceneNode> _children;
  @override
  @JsonKey()
  List<SceneNode> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  final Map<String, dynamic> _properties;
  @override
  @JsonKey()
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  String toString() {
    return 'SceneNode.group(id: $id, name: $name, visible: $visible, opacity: $opacity, children: $children, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      visible,
      opacity,
      const DeepCollectionEquality().hash(_children),
      const DeepCollectionEquality().hash(_properties));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupNodeImplCopyWith<_$GroupNodeImpl> get copyWith =>
      __$$GroupNodeImplCopyWithImpl<_$GroupNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String? name,
            bool visible,
            double opacity,
            List<SceneNode> children,
            Map<String, dynamic> properties)
        group,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        paint,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        widget,
  }) {
    return group(id, name, visible, opacity, children, properties);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
  }) {
    return group?.call(id, name, visible, opacity, children, properties);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
    required TResult orElse(),
  }) {
    if (group != null) {
      return group(id, name, visible, opacity, children, properties);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GroupNode value) group,
    required TResult Function(PaintNode value) paint,
    required TResult Function(WidgetNode value) widget,
  }) {
    return group(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GroupNode value)? group,
    TResult? Function(PaintNode value)? paint,
    TResult? Function(WidgetNode value)? widget,
  }) {
    return group?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GroupNode value)? group,
    TResult Function(PaintNode value)? paint,
    TResult Function(WidgetNode value)? widget,
    required TResult orElse(),
  }) {
    if (group != null) {
      return group(this);
    }
    return orElse();
  }
}

abstract class GroupNode implements SceneNode {
  const factory GroupNode(
      {required final String id,
      final String? name,
      final bool visible,
      final double opacity,
      final List<SceneNode> children,
      final Map<String, dynamic> properties}) = _$GroupNodeImpl;

  @override
  String get id;
  @override
  String? get name;
  @override
  bool get visible;
  @override
  double get opacity;
  List<SceneNode> get children;
  @override
  Map<String, dynamic> get properties;
  @override
  @JsonKey(ignore: true)
  _$$GroupNodeImplCopyWith<_$GroupNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaintNodeImplCopyWith<$Res>
    implements $SceneNodeCopyWith<$Res> {
  factory _$$PaintNodeImplCopyWith(
          _$PaintNodeImpl value, $Res Function(_$PaintNodeImpl) then) =
      __$$PaintNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String? name,
      bool visible,
      double opacity,
      int zIndex,
      Transform transform,
      LayoutConstraint? constraints,
      String? color,
      GradientDefinition? gradient,
      double? strokeWidth,
      String? strokeColor,
      List<ShadowDefinition> shadows,
      Map<String, dynamic> properties});

  $TransformCopyWith<$Res> get transform;
  $LayoutConstraintCopyWith<$Res>? get constraints;
  $GradientDefinitionCopyWith<$Res>? get gradient;
}

/// @nodoc
class __$$PaintNodeImplCopyWithImpl<$Res>
    extends _$SceneNodeCopyWithImpl<$Res, _$PaintNodeImpl>
    implements _$$PaintNodeImplCopyWith<$Res> {
  __$$PaintNodeImplCopyWithImpl(
      _$PaintNodeImpl _value, $Res Function(_$PaintNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? visible = null,
    Object? opacity = null,
    Object? zIndex = null,
    Object? transform = null,
    Object? constraints = freezed,
    Object? color = freezed,
    Object? gradient = freezed,
    Object? strokeWidth = freezed,
    Object? strokeColor = freezed,
    Object? shadows = null,
    Object? properties = null,
  }) {
    return _then(_$PaintNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _value.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      transform: null == transform
          ? _value.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as Transform,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as LayoutConstraint?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      gradient: freezed == gradient
          ? _value.gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as GradientDefinition?,
      strokeWidth: freezed == strokeWidth
          ? _value.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double?,
      strokeColor: freezed == strokeColor
          ? _value.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as String?,
      shadows: null == shadows
          ? _value._shadows
          : shadows // ignore: cast_nullable_to_non_nullable
              as List<ShadowDefinition>,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TransformCopyWith<$Res> get transform {
    return $TransformCopyWith<$Res>(_value.transform, (value) {
      return _then(_value.copyWith(transform: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LayoutConstraintCopyWith<$Res>? get constraints {
    if (_value.constraints == null) {
      return null;
    }

    return $LayoutConstraintCopyWith<$Res>(_value.constraints!, (value) {
      return _then(_value.copyWith(constraints: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GradientDefinitionCopyWith<$Res>? get gradient {
    if (_value.gradient == null) {
      return null;
    }

    return $GradientDefinitionCopyWith<$Res>(_value.gradient!, (value) {
      return _then(_value.copyWith(gradient: value));
    });
  }
}

/// @nodoc

class _$PaintNodeImpl implements PaintNode {
  const _$PaintNodeImpl(
      {required this.id,
      required this.type,
      this.name,
      this.visible = true,
      this.opacity = 1.0,
      this.zIndex = 0,
      this.transform = const Transform(),
      this.constraints,
      this.color,
      this.gradient,
      this.strokeWidth,
      this.strokeColor,
      final List<ShadowDefinition> shadows = const [],
      final Map<String, dynamic> properties = const {}})
      : _shadows = shadows,
        _properties = properties;

  @override
  final String id;
  @override
  final String type;
  @override
  final String? name;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final Transform transform;
  @override
  final LayoutConstraint? constraints;
  @override
  final String? color;
  @override
  final GradientDefinition? gradient;
  @override
  final double? strokeWidth;
  @override
  final String? strokeColor;
  final List<ShadowDefinition> _shadows;
  @override
  @JsonKey()
  List<ShadowDefinition> get shadows {
    if (_shadows is EqualUnmodifiableListView) return _shadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shadows);
  }

  final Map<String, dynamic> _properties;
  @override
  @JsonKey()
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  String toString() {
    return 'SceneNode.paint(id: $id, type: $type, name: $name, visible: $visible, opacity: $opacity, zIndex: $zIndex, transform: $transform, constraints: $constraints, color: $color, gradient: $gradient, strokeWidth: $strokeWidth, strokeColor: $strokeColor, shadows: $shadows, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaintNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.transform, transform) ||
                other.transform == transform) &&
            (identical(other.constraints, constraints) ||
                other.constraints == constraints) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.gradient, gradient) ||
                other.gradient == gradient) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            const DeepCollectionEquality().equals(other._shadows, _shadows) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      visible,
      opacity,
      zIndex,
      transform,
      constraints,
      color,
      gradient,
      strokeWidth,
      strokeColor,
      const DeepCollectionEquality().hash(_shadows),
      const DeepCollectionEquality().hash(_properties));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaintNodeImplCopyWith<_$PaintNodeImpl> get copyWith =>
      __$$PaintNodeImplCopyWithImpl<_$PaintNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String? name,
            bool visible,
            double opacity,
            List<SceneNode> children,
            Map<String, dynamic> properties)
        group,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        paint,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        widget,
  }) {
    return paint(
        id,
        type,
        name,
        visible,
        opacity,
        zIndex,
        transform,
        constraints,
        color,
        gradient,
        strokeWidth,
        strokeColor,
        shadows,
        properties);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
  }) {
    return paint?.call(
        id,
        type,
        name,
        visible,
        opacity,
        zIndex,
        transform,
        constraints,
        color,
        gradient,
        strokeWidth,
        strokeColor,
        shadows,
        properties);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
    required TResult orElse(),
  }) {
    if (paint != null) {
      return paint(
          id,
          type,
          name,
          visible,
          opacity,
          zIndex,
          transform,
          constraints,
          color,
          gradient,
          strokeWidth,
          strokeColor,
          shadows,
          properties);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GroupNode value) group,
    required TResult Function(PaintNode value) paint,
    required TResult Function(WidgetNode value) widget,
  }) {
    return paint(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GroupNode value)? group,
    TResult? Function(PaintNode value)? paint,
    TResult? Function(WidgetNode value)? widget,
  }) {
    return paint?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GroupNode value)? group,
    TResult Function(PaintNode value)? paint,
    TResult Function(WidgetNode value)? widget,
    required TResult orElse(),
  }) {
    if (paint != null) {
      return paint(this);
    }
    return orElse();
  }
}

abstract class PaintNode implements SceneNode {
  const factory PaintNode(
      {required final String id,
      required final String type,
      final String? name,
      final bool visible,
      final double opacity,
      final int zIndex,
      final Transform transform,
      final LayoutConstraint? constraints,
      final String? color,
      final GradientDefinition? gradient,
      final double? strokeWidth,
      final String? strokeColor,
      final List<ShadowDefinition> shadows,
      final Map<String, dynamic> properties}) = _$PaintNodeImpl;

  @override
  String get id;
  String get type;
  @override
  String? get name;
  @override
  bool get visible;
  @override
  double get opacity;
  int get zIndex;
  Transform get transform;
  LayoutConstraint? get constraints;
  String? get color;
  GradientDefinition? get gradient;
  double? get strokeWidth;
  String? get strokeColor;
  List<ShadowDefinition> get shadows;
  @override
  Map<String, dynamic> get properties;
  @override
  @JsonKey(ignore: true)
  _$$PaintNodeImplCopyWith<_$PaintNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WidgetNodeImplCopyWith<$Res>
    implements $SceneNodeCopyWith<$Res> {
  factory _$$WidgetNodeImplCopyWith(
          _$WidgetNodeImpl value, $Res Function(_$WidgetNodeImpl) then) =
      __$$WidgetNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String? name,
      bool visible,
      double opacity,
      int zIndex,
      Transform transform,
      LayoutConstraint? constraints,
      String? field,
      double? fontSize,
      String? color,
      String? fontWeight,
      double? maxLines,
      double? size,
      String? shape,
      List<ShadowDefinition> shadows,
      Map<String, dynamic> properties});

  $TransformCopyWith<$Res> get transform;
  $LayoutConstraintCopyWith<$Res>? get constraints;
}

/// @nodoc
class __$$WidgetNodeImplCopyWithImpl<$Res>
    extends _$SceneNodeCopyWithImpl<$Res, _$WidgetNodeImpl>
    implements _$$WidgetNodeImplCopyWith<$Res> {
  __$$WidgetNodeImplCopyWithImpl(
      _$WidgetNodeImpl _value, $Res Function(_$WidgetNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? visible = null,
    Object? opacity = null,
    Object? zIndex = null,
    Object? transform = null,
    Object? constraints = freezed,
    Object? field = freezed,
    Object? fontSize = freezed,
    Object? color = freezed,
    Object? fontWeight = freezed,
    Object? maxLines = freezed,
    Object? size = freezed,
    Object? shape = freezed,
    Object? shadows = null,
    Object? properties = null,
  }) {
    return _then(_$WidgetNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      visible: null == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as bool,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _value.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      transform: null == transform
          ? _value.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as Transform,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as LayoutConstraint?,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
      fontSize: freezed == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      fontWeight: freezed == fontWeight
          ? _value.fontWeight
          : fontWeight // ignore: cast_nullable_to_non_nullable
              as String?,
      maxLines: freezed == maxLines
          ? _value.maxLines
          : maxLines // ignore: cast_nullable_to_non_nullable
              as double?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double?,
      shape: freezed == shape
          ? _value.shape
          : shape // ignore: cast_nullable_to_non_nullable
              as String?,
      shadows: null == shadows
          ? _value._shadows
          : shadows // ignore: cast_nullable_to_non_nullable
              as List<ShadowDefinition>,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TransformCopyWith<$Res> get transform {
    return $TransformCopyWith<$Res>(_value.transform, (value) {
      return _then(_value.copyWith(transform: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LayoutConstraintCopyWith<$Res>? get constraints {
    if (_value.constraints == null) {
      return null;
    }

    return $LayoutConstraintCopyWith<$Res>(_value.constraints!, (value) {
      return _then(_value.copyWith(constraints: value));
    });
  }
}

/// @nodoc

class _$WidgetNodeImpl implements WidgetNode {
  const _$WidgetNodeImpl(
      {required this.id,
      required this.type,
      this.name,
      this.visible = true,
      this.opacity = 1.0,
      this.zIndex = 0,
      this.transform = const Transform(),
      this.constraints,
      this.field,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.maxLines,
      this.size,
      this.shape,
      final List<ShadowDefinition> shadows = const [],
      final Map<String, dynamic> properties = const {}})
      : _shadows = shadows,
        _properties = properties;

  @override
  final String id;
  @override
  final String type;
  @override
  final String? name;
  @override
  @JsonKey()
  final bool visible;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final Transform transform;
  @override
  final LayoutConstraint? constraints;
  @override
  final String? field;
  @override
  final double? fontSize;
  @override
  final String? color;
  @override
  final String? fontWeight;
  @override
  final double? maxLines;
  @override
  final double? size;
  @override
  final String? shape;
  final List<ShadowDefinition> _shadows;
  @override
  @JsonKey()
  List<ShadowDefinition> get shadows {
    if (_shadows is EqualUnmodifiableListView) return _shadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shadows);
  }

  final Map<String, dynamic> _properties;
  @override
  @JsonKey()
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  String toString() {
    return 'SceneNode.widget(id: $id, type: $type, name: $name, visible: $visible, opacity: $opacity, zIndex: $zIndex, transform: $transform, constraints: $constraints, field: $field, fontSize: $fontSize, color: $color, fontWeight: $fontWeight, maxLines: $maxLines, size: $size, shape: $shape, shadows: $shadows, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.transform, transform) ||
                other.transform == transform) &&
            (identical(other.constraints, constraints) ||
                other.constraints == constraints) &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.fontWeight, fontWeight) ||
                other.fontWeight == fontWeight) &&
            (identical(other.maxLines, maxLines) ||
                other.maxLines == maxLines) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.shape, shape) || other.shape == shape) &&
            const DeepCollectionEquality().equals(other._shadows, _shadows) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      visible,
      opacity,
      zIndex,
      transform,
      constraints,
      field,
      fontSize,
      color,
      fontWeight,
      maxLines,
      size,
      shape,
      const DeepCollectionEquality().hash(_shadows),
      const DeepCollectionEquality().hash(_properties));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetNodeImplCopyWith<_$WidgetNodeImpl> get copyWith =>
      __$$WidgetNodeImplCopyWithImpl<_$WidgetNodeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            String? name,
            bool visible,
            double opacity,
            List<SceneNode> children,
            Map<String, dynamic> properties)
        group,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        paint,
    required TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)
        widget,
  }) {
    return widget(
        id,
        type,
        name,
        visible,
        opacity,
        zIndex,
        transform,
        constraints,
        field,
        fontSize,
        color,
        fontWeight,
        maxLines,
        size,
        shape,
        shadows,
        properties);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult? Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
  }) {
    return widget?.call(
        id,
        type,
        name,
        visible,
        opacity,
        zIndex,
        transform,
        constraints,
        field,
        fontSize,
        color,
        fontWeight,
        maxLines,
        size,
        shape,
        shadows,
        properties);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String? name, bool visible, double opacity,
            List<SceneNode> children, Map<String, dynamic> properties)?
        group,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? color,
            GradientDefinition? gradient,
            double? strokeWidth,
            String? strokeColor,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        paint,
    TResult Function(
            String id,
            String type,
            String? name,
            bool visible,
            double opacity,
            int zIndex,
            Transform transform,
            LayoutConstraint? constraints,
            String? field,
            double? fontSize,
            String? color,
            String? fontWeight,
            double? maxLines,
            double? size,
            String? shape,
            List<ShadowDefinition> shadows,
            Map<String, dynamic> properties)?
        widget,
    required TResult orElse(),
  }) {
    if (widget != null) {
      return widget(
          id,
          type,
          name,
          visible,
          opacity,
          zIndex,
          transform,
          constraints,
          field,
          fontSize,
          color,
          fontWeight,
          maxLines,
          size,
          shape,
          shadows,
          properties);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GroupNode value) group,
    required TResult Function(PaintNode value) paint,
    required TResult Function(WidgetNode value) widget,
  }) {
    return widget(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GroupNode value)? group,
    TResult? Function(PaintNode value)? paint,
    TResult? Function(WidgetNode value)? widget,
  }) {
    return widget?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GroupNode value)? group,
    TResult Function(PaintNode value)? paint,
    TResult Function(WidgetNode value)? widget,
    required TResult orElse(),
  }) {
    if (widget != null) {
      return widget(this);
    }
    return orElse();
  }
}

abstract class WidgetNode implements SceneNode {
  const factory WidgetNode(
      {required final String id,
      required final String type,
      final String? name,
      final bool visible,
      final double opacity,
      final int zIndex,
      final Transform transform,
      final LayoutConstraint? constraints,
      final String? field,
      final double? fontSize,
      final String? color,
      final String? fontWeight,
      final double? maxLines,
      final double? size,
      final String? shape,
      final List<ShadowDefinition> shadows,
      final Map<String, dynamic> properties}) = _$WidgetNodeImpl;

  @override
  String get id;
  String get type;
  @override
  String? get name;
  @override
  bool get visible;
  @override
  double get opacity;
  int get zIndex;
  Transform get transform;
  LayoutConstraint? get constraints;
  String? get field;
  double? get fontSize;
  String? get color;
  String? get fontWeight;
  double? get maxLines;
  double? get size;
  String? get shape;
  List<ShadowDefinition> get shadows;
  @override
  Map<String, dynamic> get properties;
  @override
  @JsonKey(ignore: true)
  _$$WidgetNodeImplCopyWith<_$WidgetNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
