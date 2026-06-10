// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gradient_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GradientDefinition _$GradientDefinitionFromJson(Map<String, dynamic> json) {
  return _GradientDefinition.fromJson(json);
}

/// @nodoc
mixin _$GradientDefinition {
  String get kind => throw _privateConstructorUsedError;
  List<String> get colors => throw _privateConstructorUsedError;
  double get angle => throw _privateConstructorUsedError;
  List<double>? get stops => throw _privateConstructorUsedError;
  double get focalX => throw _privateConstructorUsedError;
  double get focalY => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GradientDefinitionCopyWith<GradientDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradientDefinitionCopyWith<$Res> {
  factory $GradientDefinitionCopyWith(
          GradientDefinition value, $Res Function(GradientDefinition) then) =
      _$GradientDefinitionCopyWithImpl<$Res, GradientDefinition>;
  @useResult
  $Res call(
      {String kind,
      List<String> colors,
      double angle,
      List<double>? stops,
      double focalX,
      double focalY,
      double radius});
}

/// @nodoc
class _$GradientDefinitionCopyWithImpl<$Res, $Val extends GradientDefinition>
    implements $GradientDefinitionCopyWith<$Res> {
  _$GradientDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? colors = null,
    Object? angle = null,
    Object? stops = freezed,
    Object? focalX = null,
    Object? focalY = null,
    Object? radius = null,
  }) {
    return _then(_value.copyWith(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      angle: null == angle
          ? _value.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      stops: freezed == stops
          ? _value.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<double>?,
      focalX: null == focalX
          ? _value.focalX
          : focalX // ignore: cast_nullable_to_non_nullable
              as double,
      focalY: null == focalY
          ? _value.focalY
          : focalY // ignore: cast_nullable_to_non_nullable
              as double,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GradientDefinitionImplCopyWith<$Res>
    implements $GradientDefinitionCopyWith<$Res> {
  factory _$$GradientDefinitionImplCopyWith(_$GradientDefinitionImpl value,
          $Res Function(_$GradientDefinitionImpl) then) =
      __$$GradientDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String kind,
      List<String> colors,
      double angle,
      List<double>? stops,
      double focalX,
      double focalY,
      double radius});
}

/// @nodoc
class __$$GradientDefinitionImplCopyWithImpl<$Res>
    extends _$GradientDefinitionCopyWithImpl<$Res, _$GradientDefinitionImpl>
    implements _$$GradientDefinitionImplCopyWith<$Res> {
  __$$GradientDefinitionImplCopyWithImpl(_$GradientDefinitionImpl _value,
      $Res Function(_$GradientDefinitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? colors = null,
    Object? angle = null,
    Object? stops = freezed,
    Object? focalX = null,
    Object? focalY = null,
    Object? radius = null,
  }) {
    return _then(_$GradientDefinitionImpl(
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      colors: null == colors
          ? _value._colors
          : colors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      angle: null == angle
          ? _value.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      stops: freezed == stops
          ? _value._stops
          : stops // ignore: cast_nullable_to_non_nullable
              as List<double>?,
      focalX: null == focalX
          ? _value.focalX
          : focalX // ignore: cast_nullable_to_non_nullable
              as double,
      focalY: null == focalY
          ? _value.focalY
          : focalY // ignore: cast_nullable_to_non_nullable
              as double,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GradientDefinitionImpl implements _GradientDefinition {
  const _$GradientDefinitionImpl(
      {this.kind = 'linear',
      final List<String> colors = const [],
      this.angle = 0,
      final List<double>? stops,
      this.focalX = 0,
      this.focalY = 0,
      this.radius = 1.0})
      : _colors = colors,
        _stops = stops;

  factory _$GradientDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradientDefinitionImplFromJson(json);

  @override
  @JsonKey()
  final String kind;
  final List<String> _colors;
  @override
  @JsonKey()
  List<String> get colors {
    if (_colors is EqualUnmodifiableListView) return _colors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colors);
  }

  @override
  @JsonKey()
  final double angle;
  final List<double>? _stops;
  @override
  List<double>? get stops {
    final value = _stops;
    if (value == null) return null;
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final double focalX;
  @override
  @JsonKey()
  final double focalY;
  @override
  @JsonKey()
  final double radius;

  @override
  String toString() {
    return 'GradientDefinition(kind: $kind, colors: $colors, angle: $angle, stops: $stops, focalX: $focalX, focalY: $focalY, radius: $radius)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradientDefinitionImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            const DeepCollectionEquality().equals(other._colors, _colors) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            const DeepCollectionEquality().equals(other._stops, _stops) &&
            (identical(other.focalX, focalX) || other.focalX == focalX) &&
            (identical(other.focalY, focalY) || other.focalY == focalY) &&
            (identical(other.radius, radius) || other.radius == radius));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      kind,
      const DeepCollectionEquality().hash(_colors),
      angle,
      const DeepCollectionEquality().hash(_stops),
      focalX,
      focalY,
      radius);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GradientDefinitionImplCopyWith<_$GradientDefinitionImpl> get copyWith =>
      __$$GradientDefinitionImplCopyWithImpl<_$GradientDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradientDefinitionImplToJson(
      this,
    );
  }
}

abstract class _GradientDefinition implements GradientDefinition {
  const factory _GradientDefinition(
      {final String kind,
      final List<String> colors,
      final double angle,
      final List<double>? stops,
      final double focalX,
      final double focalY,
      final double radius}) = _$GradientDefinitionImpl;

  factory _GradientDefinition.fromJson(Map<String, dynamic> json) =
      _$GradientDefinitionImpl.fromJson;

  @override
  String get kind;
  @override
  List<String> get colors;
  @override
  double get angle;
  @override
  List<double>? get stops;
  @override
  double get focalX;
  @override
  double get focalY;
  @override
  double get radius;
  @override
  @JsonKey(ignore: true)
  _$$GradientDefinitionImplCopyWith<_$GradientDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
