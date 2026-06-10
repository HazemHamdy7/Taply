// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThemeAssets _$ThemeAssetsFromJson(Map<String, dynamic> json) {
  return _ThemeAssets.fromJson(json);
}

/// @nodoc
mixin _$ThemeAssets {
  String? get fontFamily => throw _privateConstructorUsedError;
  String? get fontAsset => throw _privateConstructorUsedError;
  String? get backgroundImage => throw _privateConstructorUsedError;
  List<String> get imageAssets => throw _privateConstructorUsedError;
  Map<String, String> get assetMap => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeAssetsCopyWith<ThemeAssets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeAssetsCopyWith<$Res> {
  factory $ThemeAssetsCopyWith(
          ThemeAssets value, $Res Function(ThemeAssets) then) =
      _$ThemeAssetsCopyWithImpl<$Res, ThemeAssets>;
  @useResult
  $Res call(
      {String? fontFamily,
      String? fontAsset,
      String? backgroundImage,
      List<String> imageAssets,
      Map<String, String> assetMap});
}

/// @nodoc
class _$ThemeAssetsCopyWithImpl<$Res, $Val extends ThemeAssets>
    implements $ThemeAssetsCopyWith<$Res> {
  _$ThemeAssetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontFamily = freezed,
    Object? fontAsset = freezed,
    Object? backgroundImage = freezed,
    Object? imageAssets = null,
    Object? assetMap = null,
  }) {
    return _then(_value.copyWith(
      fontFamily: freezed == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      fontAsset: freezed == fontAsset
          ? _value.fontAsset
          : fontAsset // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      imageAssets: null == imageAssets
          ? _value.imageAssets
          : imageAssets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assetMap: null == assetMap
          ? _value.assetMap
          : assetMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeAssetsImplCopyWith<$Res>
    implements $ThemeAssetsCopyWith<$Res> {
  factory _$$ThemeAssetsImplCopyWith(
          _$ThemeAssetsImpl value, $Res Function(_$ThemeAssetsImpl) then) =
      __$$ThemeAssetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? fontFamily,
      String? fontAsset,
      String? backgroundImage,
      List<String> imageAssets,
      Map<String, String> assetMap});
}

/// @nodoc
class __$$ThemeAssetsImplCopyWithImpl<$Res>
    extends _$ThemeAssetsCopyWithImpl<$Res, _$ThemeAssetsImpl>
    implements _$$ThemeAssetsImplCopyWith<$Res> {
  __$$ThemeAssetsImplCopyWithImpl(
      _$ThemeAssetsImpl _value, $Res Function(_$ThemeAssetsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontFamily = freezed,
    Object? fontAsset = freezed,
    Object? backgroundImage = freezed,
    Object? imageAssets = null,
    Object? assetMap = null,
  }) {
    return _then(_$ThemeAssetsImpl(
      fontFamily: freezed == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      fontAsset: freezed == fontAsset
          ? _value.fontAsset
          : fontAsset // ignore: cast_nullable_to_non_nullable
              as String?,
      backgroundImage: freezed == backgroundImage
          ? _value.backgroundImage
          : backgroundImage // ignore: cast_nullable_to_non_nullable
              as String?,
      imageAssets: null == imageAssets
          ? _value._imageAssets
          : imageAssets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      assetMap: null == assetMap
          ? _value._assetMap
          : assetMap // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeAssetsImpl implements _ThemeAssets {
  const _$ThemeAssetsImpl(
      {this.fontFamily,
      this.fontAsset,
      this.backgroundImage,
      final List<String> imageAssets = const [],
      final Map<String, String> assetMap = const {}})
      : _imageAssets = imageAssets,
        _assetMap = assetMap;

  factory _$ThemeAssetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeAssetsImplFromJson(json);

  @override
  final String? fontFamily;
  @override
  final String? fontAsset;
  @override
  final String? backgroundImage;
  final List<String> _imageAssets;
  @override
  @JsonKey()
  List<String> get imageAssets {
    if (_imageAssets is EqualUnmodifiableListView) return _imageAssets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageAssets);
  }

  final Map<String, String> _assetMap;
  @override
  @JsonKey()
  Map<String, String> get assetMap {
    if (_assetMap is EqualUnmodifiableMapView) return _assetMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_assetMap);
  }

  @override
  String toString() {
    return 'ThemeAssets(fontFamily: $fontFamily, fontAsset: $fontAsset, backgroundImage: $backgroundImage, imageAssets: $imageAssets, assetMap: $assetMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeAssetsImpl &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.fontAsset, fontAsset) ||
                other.fontAsset == fontAsset) &&
            (identical(other.backgroundImage, backgroundImage) ||
                other.backgroundImage == backgroundImage) &&
            const DeepCollectionEquality()
                .equals(other._imageAssets, _imageAssets) &&
            const DeepCollectionEquality().equals(other._assetMap, _assetMap));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fontFamily,
      fontAsset,
      backgroundImage,
      const DeepCollectionEquality().hash(_imageAssets),
      const DeepCollectionEquality().hash(_assetMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeAssetsImplCopyWith<_$ThemeAssetsImpl> get copyWith =>
      __$$ThemeAssetsImplCopyWithImpl<_$ThemeAssetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeAssetsImplToJson(
      this,
    );
  }
}

abstract class _ThemeAssets implements ThemeAssets {
  const factory _ThemeAssets(
      {final String? fontFamily,
      final String? fontAsset,
      final String? backgroundImage,
      final List<String> imageAssets,
      final Map<String, String> assetMap}) = _$ThemeAssetsImpl;

  factory _ThemeAssets.fromJson(Map<String, dynamic> json) =
      _$ThemeAssetsImpl.fromJson;

  @override
  String? get fontFamily;
  @override
  String? get fontAsset;
  @override
  String? get backgroundImage;
  @override
  List<String> get imageAssets;
  @override
  Map<String, String> get assetMap;
  @override
  @JsonKey(ignore: true)
  _$$ThemeAssetsImplCopyWith<_$ThemeAssetsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
