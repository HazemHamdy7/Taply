// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_variables.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VariableDefinition _$VariableDefinitionFromJson(Map<String, dynamic> json) {
  return _VariableDefinition.fromJson(json);
}

/// @nodoc
mixin _$VariableDefinition {
  String get name => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VariableDefinitionCopyWith<VariableDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariableDefinitionCopyWith<$Res> {
  factory $VariableDefinitionCopyWith(
          VariableDefinition value, $Res Function(VariableDefinition) then) =
      _$VariableDefinitionCopyWithImpl<$Res, VariableDefinition>;
  @useResult
  $Res call({String name, dynamic value, String? type, String? description});
}

/// @nodoc
class _$VariableDefinitionCopyWithImpl<$Res, $Val extends VariableDefinition>
    implements $VariableDefinitionCopyWith<$Res> {
  _$VariableDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = freezed,
    Object? type = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VariableDefinitionImplCopyWith<$Res>
    implements $VariableDefinitionCopyWith<$Res> {
  factory _$$VariableDefinitionImplCopyWith(_$VariableDefinitionImpl value,
          $Res Function(_$VariableDefinitionImpl) then) =
      __$$VariableDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, dynamic value, String? type, String? description});
}

/// @nodoc
class __$$VariableDefinitionImplCopyWithImpl<$Res>
    extends _$VariableDefinitionCopyWithImpl<$Res, _$VariableDefinitionImpl>
    implements _$$VariableDefinitionImplCopyWith<$Res> {
  __$$VariableDefinitionImplCopyWithImpl(_$VariableDefinitionImpl _value,
      $Res Function(_$VariableDefinitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = freezed,
    Object? type = freezed,
    Object? description = freezed,
  }) {
    return _then(_$VariableDefinitionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VariableDefinitionImpl implements _VariableDefinition {
  const _$VariableDefinitionImpl(
      {required this.name, this.value, this.type, this.description});

  factory _$VariableDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariableDefinitionImplFromJson(json);

  @override
  final String name;
  @override
  final dynamic value;
  @override
  final String? type;
  @override
  final String? description;

  @override
  String toString() {
    return 'VariableDefinition(name: $name, value: $value, type: $type, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariableDefinitionImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(value), type, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VariableDefinitionImplCopyWith<_$VariableDefinitionImpl> get copyWith =>
      __$$VariableDefinitionImplCopyWithImpl<_$VariableDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariableDefinitionImplToJson(
      this,
    );
  }
}

abstract class _VariableDefinition implements VariableDefinition {
  const factory _VariableDefinition(
      {required final String name,
      final dynamic value,
      final String? type,
      final String? description}) = _$VariableDefinitionImpl;

  factory _VariableDefinition.fromJson(Map<String, dynamic> json) =
      _$VariableDefinitionImpl.fromJson;

  @override
  String get name;
  @override
  dynamic get value;
  @override
  String? get type;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$VariableDefinitionImplCopyWith<_$VariableDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThemeVariables _$ThemeVariablesFromJson(Map<String, dynamic> json) {
  return _ThemeVariables.fromJson(json);
}

/// @nodoc
mixin _$ThemeVariables {
  ColorPalette get colors => throw _privateConstructorUsedError;
  TypographySet get typography => throw _privateConstructorUsedError;
  SpacingSet get spacing => throw _privateConstructorUsedError;
  RadiusSet get radius => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;
  List<ShadowDefinition> get shadows => throw _privateConstructorUsedError;
  List<ThemeAnimation> get animations => throw _privateConstructorUsedError;
  Map<String, VariableDefinition> get custom =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeVariablesCopyWith<ThemeVariables> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeVariablesCopyWith<$Res> {
  factory $ThemeVariablesCopyWith(
          ThemeVariables value, $Res Function(ThemeVariables) then) =
      _$ThemeVariablesCopyWithImpl<$Res, ThemeVariables>;
  @useResult
  $Res call(
      {ColorPalette colors,
      TypographySet typography,
      SpacingSet spacing,
      RadiusSet radius,
      double opacity,
      List<ShadowDefinition> shadows,
      List<ThemeAnimation> animations,
      Map<String, VariableDefinition> custom});

  $ColorPaletteCopyWith<$Res> get colors;
  $TypographySetCopyWith<$Res> get typography;
  $SpacingSetCopyWith<$Res> get spacing;
  $RadiusSetCopyWith<$Res> get radius;
}

/// @nodoc
class _$ThemeVariablesCopyWithImpl<$Res, $Val extends ThemeVariables>
    implements $ThemeVariablesCopyWith<$Res> {
  _$ThemeVariablesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? typography = null,
    Object? spacing = null,
    Object? radius = null,
    Object? opacity = null,
    Object? shadows = null,
    Object? animations = null,
    Object? custom = null,
  }) {
    return _then(_value.copyWith(
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as ColorPalette,
      typography: null == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as TypographySet,
      spacing: null == spacing
          ? _value.spacing
          : spacing // ignore: cast_nullable_to_non_nullable
              as SpacingSet,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as RadiusSet,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      shadows: null == shadows
          ? _value.shadows
          : shadows // ignore: cast_nullable_to_non_nullable
              as List<ShadowDefinition>,
      animations: null == animations
          ? _value.animations
          : animations // ignore: cast_nullable_to_non_nullable
              as List<ThemeAnimation>,
      custom: null == custom
          ? _value.custom
          : custom // ignore: cast_nullable_to_non_nullable
              as Map<String, VariableDefinition>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ColorPaletteCopyWith<$Res> get colors {
    return $ColorPaletteCopyWith<$Res>(_value.colors, (value) {
      return _then(_value.copyWith(colors: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TypographySetCopyWith<$Res> get typography {
    return $TypographySetCopyWith<$Res>(_value.typography, (value) {
      return _then(_value.copyWith(typography: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SpacingSetCopyWith<$Res> get spacing {
    return $SpacingSetCopyWith<$Res>(_value.spacing, (value) {
      return _then(_value.copyWith(spacing: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RadiusSetCopyWith<$Res> get radius {
    return $RadiusSetCopyWith<$Res>(_value.radius, (value) {
      return _then(_value.copyWith(radius: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ThemeVariablesImplCopyWith<$Res>
    implements $ThemeVariablesCopyWith<$Res> {
  factory _$$ThemeVariablesImplCopyWith(_$ThemeVariablesImpl value,
          $Res Function(_$ThemeVariablesImpl) then) =
      __$$ThemeVariablesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ColorPalette colors,
      TypographySet typography,
      SpacingSet spacing,
      RadiusSet radius,
      double opacity,
      List<ShadowDefinition> shadows,
      List<ThemeAnimation> animations,
      Map<String, VariableDefinition> custom});

  @override
  $ColorPaletteCopyWith<$Res> get colors;
  @override
  $TypographySetCopyWith<$Res> get typography;
  @override
  $SpacingSetCopyWith<$Res> get spacing;
  @override
  $RadiusSetCopyWith<$Res> get radius;
}

/// @nodoc
class __$$ThemeVariablesImplCopyWithImpl<$Res>
    extends _$ThemeVariablesCopyWithImpl<$Res, _$ThemeVariablesImpl>
    implements _$$ThemeVariablesImplCopyWith<$Res> {
  __$$ThemeVariablesImplCopyWithImpl(
      _$ThemeVariablesImpl _value, $Res Function(_$ThemeVariablesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? typography = null,
    Object? spacing = null,
    Object? radius = null,
    Object? opacity = null,
    Object? shadows = null,
    Object? animations = null,
    Object? custom = null,
  }) {
    return _then(_$ThemeVariablesImpl(
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as ColorPalette,
      typography: null == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as TypographySet,
      spacing: null == spacing
          ? _value.spacing
          : spacing // ignore: cast_nullable_to_non_nullable
              as SpacingSet,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as RadiusSet,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      shadows: null == shadows
          ? _value._shadows
          : shadows // ignore: cast_nullable_to_non_nullable
              as List<ShadowDefinition>,
      animations: null == animations
          ? _value._animations
          : animations // ignore: cast_nullable_to_non_nullable
              as List<ThemeAnimation>,
      custom: null == custom
          ? _value._custom
          : custom // ignore: cast_nullable_to_non_nullable
              as Map<String, VariableDefinition>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeVariablesImpl implements _ThemeVariables {
  const _$ThemeVariablesImpl(
      {this.colors = const ColorPalette(),
      this.typography = const TypographySet(),
      this.spacing = const SpacingSet(),
      this.radius = const RadiusSet(),
      this.opacity = 1.0,
      final List<ShadowDefinition> shadows = const [],
      final List<ThemeAnimation> animations = const [],
      final Map<String, VariableDefinition> custom = const {}})
      : _shadows = shadows,
        _animations = animations,
        _custom = custom;

  factory _$ThemeVariablesImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeVariablesImplFromJson(json);

  @override
  @JsonKey()
  final ColorPalette colors;
  @override
  @JsonKey()
  final TypographySet typography;
  @override
  @JsonKey()
  final SpacingSet spacing;
  @override
  @JsonKey()
  final RadiusSet radius;
  @override
  @JsonKey()
  final double opacity;
  final List<ShadowDefinition> _shadows;
  @override
  @JsonKey()
  List<ShadowDefinition> get shadows {
    if (_shadows is EqualUnmodifiableListView) return _shadows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shadows);
  }

  final List<ThemeAnimation> _animations;
  @override
  @JsonKey()
  List<ThemeAnimation> get animations {
    if (_animations is EqualUnmodifiableListView) return _animations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_animations);
  }

  final Map<String, VariableDefinition> _custom;
  @override
  @JsonKey()
  Map<String, VariableDefinition> get custom {
    if (_custom is EqualUnmodifiableMapView) return _custom;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_custom);
  }

  @override
  String toString() {
    return 'ThemeVariables(colors: $colors, typography: $typography, spacing: $spacing, radius: $radius, opacity: $opacity, shadows: $shadows, animations: $animations, custom: $custom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeVariablesImpl &&
            (identical(other.colors, colors) || other.colors == colors) &&
            (identical(other.typography, typography) ||
                other.typography == typography) &&
            (identical(other.spacing, spacing) || other.spacing == spacing) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            const DeepCollectionEquality().equals(other._shadows, _shadows) &&
            const DeepCollectionEquality()
                .equals(other._animations, _animations) &&
            const DeepCollectionEquality().equals(other._custom, _custom));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      colors,
      typography,
      spacing,
      radius,
      opacity,
      const DeepCollectionEquality().hash(_shadows),
      const DeepCollectionEquality().hash(_animations),
      const DeepCollectionEquality().hash(_custom));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeVariablesImplCopyWith<_$ThemeVariablesImpl> get copyWith =>
      __$$ThemeVariablesImplCopyWithImpl<_$ThemeVariablesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeVariablesImplToJson(
      this,
    );
  }
}

abstract class _ThemeVariables implements ThemeVariables {
  const factory _ThemeVariables(
      {final ColorPalette colors,
      final TypographySet typography,
      final SpacingSet spacing,
      final RadiusSet radius,
      final double opacity,
      final List<ShadowDefinition> shadows,
      final List<ThemeAnimation> animations,
      final Map<String, VariableDefinition> custom}) = _$ThemeVariablesImpl;

  factory _ThemeVariables.fromJson(Map<String, dynamic> json) =
      _$ThemeVariablesImpl.fromJson;

  @override
  ColorPalette get colors;
  @override
  TypographySet get typography;
  @override
  SpacingSet get spacing;
  @override
  RadiusSet get radius;
  @override
  double get opacity;
  @override
  List<ShadowDefinition> get shadows;
  @override
  List<ThemeAnimation> get animations;
  @override
  Map<String, VariableDefinition> get custom;
  @override
  @JsonKey(ignore: true)
  _$$ThemeVariablesImplCopyWith<_$ThemeVariablesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
