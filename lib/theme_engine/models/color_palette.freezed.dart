// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_palette.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ColorSwatch _$ColorSwatchFromJson(Map<String, dynamic> json) {
  return _ColorSwatch.fromJson(json);
}

/// @nodoc
mixin _$ColorSwatch {
  String get id => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ColorSwatchCopyWith<ColorSwatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorSwatchCopyWith<$Res> {
  factory $ColorSwatchCopyWith(
          ColorSwatch value, $Res Function(ColorSwatch) then) =
      _$ColorSwatchCopyWithImpl<$Res, ColorSwatch>;
  @useResult
  $Res call({String id, String color, String? label});
}

/// @nodoc
class _$ColorSwatchCopyWithImpl<$Res, $Val extends ColorSwatch>
    implements $ColorSwatchCopyWith<$Res> {
  _$ColorSwatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? color = null,
    Object? label = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ColorSwatchImplCopyWith<$Res>
    implements $ColorSwatchCopyWith<$Res> {
  factory _$$ColorSwatchImplCopyWith(
          _$ColorSwatchImpl value, $Res Function(_$ColorSwatchImpl) then) =
      __$$ColorSwatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String color, String? label});
}

/// @nodoc
class __$$ColorSwatchImplCopyWithImpl<$Res>
    extends _$ColorSwatchCopyWithImpl<$Res, _$ColorSwatchImpl>
    implements _$$ColorSwatchImplCopyWith<$Res> {
  __$$ColorSwatchImplCopyWithImpl(
      _$ColorSwatchImpl _value, $Res Function(_$ColorSwatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? color = null,
    Object? label = freezed,
  }) {
    return _then(_$ColorSwatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColorSwatchImpl implements _ColorSwatch {
  const _$ColorSwatchImpl({required this.id, required this.color, this.label});

  factory _$ColorSwatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColorSwatchImplFromJson(json);

  @override
  final String id;
  @override
  final String color;
  @override
  final String? label;

  @override
  String toString() {
    return 'ColorSwatch(id: $id, color: $color, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColorSwatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, color, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ColorSwatchImplCopyWith<_$ColorSwatchImpl> get copyWith =>
      __$$ColorSwatchImplCopyWithImpl<_$ColorSwatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ColorSwatchImplToJson(
      this,
    );
  }
}

abstract class _ColorSwatch implements ColorSwatch {
  const factory _ColorSwatch(
      {required final String id,
      required final String color,
      final String? label}) = _$ColorSwatchImpl;

  factory _ColorSwatch.fromJson(Map<String, dynamic> json) =
      _$ColorSwatchImpl.fromJson;

  @override
  String get id;
  @override
  String get color;
  @override
  String? get label;
  @override
  @JsonKey(ignore: true)
  _$$ColorSwatchImplCopyWith<_$ColorSwatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ColorPalette _$ColorPaletteFromJson(Map<String, dynamic> json) {
  return _ColorPalette.fromJson(json);
}

/// @nodoc
mixin _$ColorPalette {
  List<ColorSwatch> get swatches => throw _privateConstructorUsedError;
  String? get blendMode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ColorPaletteCopyWith<ColorPalette> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ColorPaletteCopyWith<$Res> {
  factory $ColorPaletteCopyWith(
          ColorPalette value, $Res Function(ColorPalette) then) =
      _$ColorPaletteCopyWithImpl<$Res, ColorPalette>;
  @useResult
  $Res call({List<ColorSwatch> swatches, String? blendMode});
}

/// @nodoc
class _$ColorPaletteCopyWithImpl<$Res, $Val extends ColorPalette>
    implements $ColorPaletteCopyWith<$Res> {
  _$ColorPaletteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? swatches = null,
    Object? blendMode = freezed,
  }) {
    return _then(_value.copyWith(
      swatches: null == swatches
          ? _value.swatches
          : swatches // ignore: cast_nullable_to_non_nullable
              as List<ColorSwatch>,
      blendMode: freezed == blendMode
          ? _value.blendMode
          : blendMode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ColorPaletteImplCopyWith<$Res>
    implements $ColorPaletteCopyWith<$Res> {
  factory _$$ColorPaletteImplCopyWith(
          _$ColorPaletteImpl value, $Res Function(_$ColorPaletteImpl) then) =
      __$$ColorPaletteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ColorSwatch> swatches, String? blendMode});
}

/// @nodoc
class __$$ColorPaletteImplCopyWithImpl<$Res>
    extends _$ColorPaletteCopyWithImpl<$Res, _$ColorPaletteImpl>
    implements _$$ColorPaletteImplCopyWith<$Res> {
  __$$ColorPaletteImplCopyWithImpl(
      _$ColorPaletteImpl _value, $Res Function(_$ColorPaletteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? swatches = null,
    Object? blendMode = freezed,
  }) {
    return _then(_$ColorPaletteImpl(
      swatches: null == swatches
          ? _value._swatches
          : swatches // ignore: cast_nullable_to_non_nullable
              as List<ColorSwatch>,
      blendMode: freezed == blendMode
          ? _value.blendMode
          : blendMode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ColorPaletteImpl implements _ColorPalette {
  const _$ColorPaletteImpl(
      {final List<ColorSwatch> swatches = const [], this.blendMode})
      : _swatches = swatches;

  factory _$ColorPaletteImpl.fromJson(Map<String, dynamic> json) =>
      _$$ColorPaletteImplFromJson(json);

  final List<ColorSwatch> _swatches;
  @override
  @JsonKey()
  List<ColorSwatch> get swatches {
    if (_swatches is EqualUnmodifiableListView) return _swatches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_swatches);
  }

  @override
  final String? blendMode;

  @override
  String toString() {
    return 'ColorPalette(swatches: $swatches, blendMode: $blendMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ColorPaletteImpl &&
            const DeepCollectionEquality().equals(other._swatches, _swatches) &&
            (identical(other.blendMode, blendMode) ||
                other.blendMode == blendMode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_swatches), blendMode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ColorPaletteImplCopyWith<_$ColorPaletteImpl> get copyWith =>
      __$$ColorPaletteImplCopyWithImpl<_$ColorPaletteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ColorPaletteImplToJson(
      this,
    );
  }
}

abstract class _ColorPalette implements ColorPalette {
  const factory _ColorPalette(
      {final List<ColorSwatch> swatches,
      final String? blendMode}) = _$ColorPaletteImpl;

  factory _ColorPalette.fromJson(Map<String, dynamic> json) =
      _$ColorPaletteImpl.fromJson;

  @override
  List<ColorSwatch> get swatches;
  @override
  String? get blendMode;
  @override
  @JsonKey(ignore: true)
  _$$ColorPaletteImplCopyWith<_$ColorPaletteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
