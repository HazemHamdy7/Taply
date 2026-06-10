// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typography_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TextStyleDef _$TextStyleDefFromJson(Map<String, dynamic> json) {
  return _TextStyleDef.fromJson(json);
}

/// @nodoc
mixin _$TextStyleDef {
  double? get fontSize => throw _privateConstructorUsedError;
  String? get fontWeight => throw _privateConstructorUsedError;
  double? get lineHeight => throw _privateConstructorUsedError;
  double? get letterSpacing => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TextStyleDefCopyWith<TextStyleDef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextStyleDefCopyWith<$Res> {
  factory $TextStyleDefCopyWith(
          TextStyleDef value, $Res Function(TextStyleDef) then) =
      _$TextStyleDefCopyWithImpl<$Res, TextStyleDef>;
  @useResult
  $Res call(
      {double? fontSize,
      String? fontWeight,
      double? lineHeight,
      double? letterSpacing,
      String? color});
}

/// @nodoc
class _$TextStyleDefCopyWithImpl<$Res, $Val extends TextStyleDef>
    implements $TextStyleDefCopyWith<$Res> {
  _$TextStyleDefCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontSize = freezed,
    Object? fontWeight = freezed,
    Object? lineHeight = freezed,
    Object? letterSpacing = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      fontSize: freezed == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      fontWeight: freezed == fontWeight
          ? _value.fontWeight
          : fontWeight // ignore: cast_nullable_to_non_nullable
              as String?,
      lineHeight: freezed == lineHeight
          ? _value.lineHeight
          : lineHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      letterSpacing: freezed == letterSpacing
          ? _value.letterSpacing
          : letterSpacing // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextStyleDefImplCopyWith<$Res>
    implements $TextStyleDefCopyWith<$Res> {
  factory _$$TextStyleDefImplCopyWith(
          _$TextStyleDefImpl value, $Res Function(_$TextStyleDefImpl) then) =
      __$$TextStyleDefImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? fontSize,
      String? fontWeight,
      double? lineHeight,
      double? letterSpacing,
      String? color});
}

/// @nodoc
class __$$TextStyleDefImplCopyWithImpl<$Res>
    extends _$TextStyleDefCopyWithImpl<$Res, _$TextStyleDefImpl>
    implements _$$TextStyleDefImplCopyWith<$Res> {
  __$$TextStyleDefImplCopyWithImpl(
      _$TextStyleDefImpl _value, $Res Function(_$TextStyleDefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontSize = freezed,
    Object? fontWeight = freezed,
    Object? lineHeight = freezed,
    Object? letterSpacing = freezed,
    Object? color = freezed,
  }) {
    return _then(_$TextStyleDefImpl(
      fontSize: freezed == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double?,
      fontWeight: freezed == fontWeight
          ? _value.fontWeight
          : fontWeight // ignore: cast_nullable_to_non_nullable
              as String?,
      lineHeight: freezed == lineHeight
          ? _value.lineHeight
          : lineHeight // ignore: cast_nullable_to_non_nullable
              as double?,
      letterSpacing: freezed == letterSpacing
          ? _value.letterSpacing
          : letterSpacing // ignore: cast_nullable_to_non_nullable
              as double?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TextStyleDefImpl implements _TextStyleDef {
  const _$TextStyleDefImpl(
      {this.fontSize,
      this.fontWeight,
      this.lineHeight,
      this.letterSpacing,
      this.color});

  factory _$TextStyleDefImpl.fromJson(Map<String, dynamic> json) =>
      _$$TextStyleDefImplFromJson(json);

  @override
  final double? fontSize;
  @override
  final String? fontWeight;
  @override
  final double? lineHeight;
  @override
  final double? letterSpacing;
  @override
  final String? color;

  @override
  String toString() {
    return 'TextStyleDef(fontSize: $fontSize, fontWeight: $fontWeight, lineHeight: $lineHeight, letterSpacing: $letterSpacing, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextStyleDefImpl &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.fontWeight, fontWeight) ||
                other.fontWeight == fontWeight) &&
            (identical(other.lineHeight, lineHeight) ||
                other.lineHeight == lineHeight) &&
            (identical(other.letterSpacing, letterSpacing) ||
                other.letterSpacing == letterSpacing) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, fontSize, fontWeight, lineHeight, letterSpacing, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TextStyleDefImplCopyWith<_$TextStyleDefImpl> get copyWith =>
      __$$TextStyleDefImplCopyWithImpl<_$TextStyleDefImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TextStyleDefImplToJson(
      this,
    );
  }
}

abstract class _TextStyleDef implements TextStyleDef {
  const factory _TextStyleDef(
      {final double? fontSize,
      final String? fontWeight,
      final double? lineHeight,
      final double? letterSpacing,
      final String? color}) = _$TextStyleDefImpl;

  factory _TextStyleDef.fromJson(Map<String, dynamic> json) =
      _$TextStyleDefImpl.fromJson;

  @override
  double? get fontSize;
  @override
  String? get fontWeight;
  @override
  double? get lineHeight;
  @override
  double? get letterSpacing;
  @override
  String? get color;
  @override
  @JsonKey(ignore: true)
  _$$TextStyleDefImplCopyWith<_$TextStyleDefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypographySet _$TypographySetFromJson(Map<String, dynamic> json) {
  return _TypographySet.fromJson(json);
}

/// @nodoc
mixin _$TypographySet {
  String? get primaryFontFamily => throw _privateConstructorUsedError;
  String? get secondaryFontFamily => throw _privateConstructorUsedError;
  Map<String, TextStyleDef> get styles => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TypographySetCopyWith<TypographySet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypographySetCopyWith<$Res> {
  factory $TypographySetCopyWith(
          TypographySet value, $Res Function(TypographySet) then) =
      _$TypographySetCopyWithImpl<$Res, TypographySet>;
  @useResult
  $Res call(
      {String? primaryFontFamily,
      String? secondaryFontFamily,
      Map<String, TextStyleDef> styles});
}

/// @nodoc
class _$TypographySetCopyWithImpl<$Res, $Val extends TypographySet>
    implements $TypographySetCopyWith<$Res> {
  _$TypographySetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryFontFamily = freezed,
    Object? secondaryFontFamily = freezed,
    Object? styles = null,
  }) {
    return _then(_value.copyWith(
      primaryFontFamily: freezed == primaryFontFamily
          ? _value.primaryFontFamily
          : primaryFontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryFontFamily: freezed == secondaryFontFamily
          ? _value.secondaryFontFamily
          : secondaryFontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      styles: null == styles
          ? _value.styles
          : styles // ignore: cast_nullable_to_non_nullable
              as Map<String, TextStyleDef>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypographySetImplCopyWith<$Res>
    implements $TypographySetCopyWith<$Res> {
  factory _$$TypographySetImplCopyWith(
          _$TypographySetImpl value, $Res Function(_$TypographySetImpl) then) =
      __$$TypographySetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? primaryFontFamily,
      String? secondaryFontFamily,
      Map<String, TextStyleDef> styles});
}

/// @nodoc
class __$$TypographySetImplCopyWithImpl<$Res>
    extends _$TypographySetCopyWithImpl<$Res, _$TypographySetImpl>
    implements _$$TypographySetImplCopyWith<$Res> {
  __$$TypographySetImplCopyWithImpl(
      _$TypographySetImpl _value, $Res Function(_$TypographySetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryFontFamily = freezed,
    Object? secondaryFontFamily = freezed,
    Object? styles = null,
  }) {
    return _then(_$TypographySetImpl(
      primaryFontFamily: freezed == primaryFontFamily
          ? _value.primaryFontFamily
          : primaryFontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      secondaryFontFamily: freezed == secondaryFontFamily
          ? _value.secondaryFontFamily
          : secondaryFontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      styles: null == styles
          ? _value._styles
          : styles // ignore: cast_nullable_to_non_nullable
              as Map<String, TextStyleDef>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypographySetImpl implements _TypographySet {
  const _$TypographySetImpl(
      {this.primaryFontFamily,
      this.secondaryFontFamily,
      final Map<String, TextStyleDef> styles = const {}})
      : _styles = styles;

  factory _$TypographySetImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypographySetImplFromJson(json);

  @override
  final String? primaryFontFamily;
  @override
  final String? secondaryFontFamily;
  final Map<String, TextStyleDef> _styles;
  @override
  @JsonKey()
  Map<String, TextStyleDef> get styles {
    if (_styles is EqualUnmodifiableMapView) return _styles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_styles);
  }

  @override
  String toString() {
    return 'TypographySet(primaryFontFamily: $primaryFontFamily, secondaryFontFamily: $secondaryFontFamily, styles: $styles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypographySetImpl &&
            (identical(other.primaryFontFamily, primaryFontFamily) ||
                other.primaryFontFamily == primaryFontFamily) &&
            (identical(other.secondaryFontFamily, secondaryFontFamily) ||
                other.secondaryFontFamily == secondaryFontFamily) &&
            const DeepCollectionEquality().equals(other._styles, _styles));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, primaryFontFamily,
      secondaryFontFamily, const DeepCollectionEquality().hash(_styles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypographySetImplCopyWith<_$TypographySetImpl> get copyWith =>
      __$$TypographySetImplCopyWithImpl<_$TypographySetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypographySetImplToJson(
      this,
    );
  }
}

abstract class _TypographySet implements TypographySet {
  const factory _TypographySet(
      {final String? primaryFontFamily,
      final String? secondaryFontFamily,
      final Map<String, TextStyleDef> styles}) = _$TypographySetImpl;

  factory _TypographySet.fromJson(Map<String, dynamic> json) =
      _$TypographySetImpl.fromJson;

  @override
  String? get primaryFontFamily;
  @override
  String? get secondaryFontFamily;
  @override
  Map<String, TextStyleDef> get styles;
  @override
  @JsonKey(ignore: true)
  _$$TypographySetImplCopyWith<_$TypographySetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
