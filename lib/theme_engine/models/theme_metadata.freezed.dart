// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ThemeMetadata _$ThemeMetadataFromJson(Map<String, dynamic> json) {
  return _ThemeMetadata.fromJson(json);
}

/// @nodoc
mixin _$ThemeMetadata {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get specVersion => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  String? get themeVersion => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get colorScheme => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeMetadataCopyWith<ThemeMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeMetadataCopyWith<$Res> {
  factory $ThemeMetadataCopyWith(
          ThemeMetadata value, $Res Function(ThemeMetadata) then) =
      _$ThemeMetadataCopyWithImpl<$Res, ThemeMetadata>;
  @useResult
  $Res call(
      {String id,
      String name,
      String specVersion,
      String? description,
      String? author,
      String? themeVersion,
      List<String> tags,
      String? colorScheme});
}

/// @nodoc
class _$ThemeMetadataCopyWithImpl<$Res, $Val extends ThemeMetadata>
    implements $ThemeMetadataCopyWith<$Res> {
  _$ThemeMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? specVersion = null,
    Object? description = freezed,
    Object? author = freezed,
    Object? themeVersion = freezed,
    Object? tags = null,
    Object? colorScheme = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      specVersion: null == specVersion
          ? _value.specVersion
          : specVersion // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      themeVersion: freezed == themeVersion
          ? _value.themeVersion
          : themeVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      colorScheme: freezed == colorScheme
          ? _value.colorScheme
          : colorScheme // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeMetadataImplCopyWith<$Res>
    implements $ThemeMetadataCopyWith<$Res> {
  factory _$$ThemeMetadataImplCopyWith(
          _$ThemeMetadataImpl value, $Res Function(_$ThemeMetadataImpl) then) =
      __$$ThemeMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String specVersion,
      String? description,
      String? author,
      String? themeVersion,
      List<String> tags,
      String? colorScheme});
}

/// @nodoc
class __$$ThemeMetadataImplCopyWithImpl<$Res>
    extends _$ThemeMetadataCopyWithImpl<$Res, _$ThemeMetadataImpl>
    implements _$$ThemeMetadataImplCopyWith<$Res> {
  __$$ThemeMetadataImplCopyWithImpl(
      _$ThemeMetadataImpl _value, $Res Function(_$ThemeMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? specVersion = null,
    Object? description = freezed,
    Object? author = freezed,
    Object? themeVersion = freezed,
    Object? tags = null,
    Object? colorScheme = freezed,
  }) {
    return _then(_$ThemeMetadataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      specVersion: null == specVersion
          ? _value.specVersion
          : specVersion // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String?,
      themeVersion: freezed == themeVersion
          ? _value.themeVersion
          : themeVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      colorScheme: freezed == colorScheme
          ? _value.colorScheme
          : colorScheme // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeMetadataImpl implements _ThemeMetadata {
  const _$ThemeMetadataImpl(
      {required this.id,
      required this.name,
      this.specVersion = '2.0.0',
      this.description,
      this.author,
      this.themeVersion,
      final List<String> tags = const [],
      this.colorScheme})
      : _tags = tags;

  factory _$ThemeMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeMetadataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String specVersion;
  @override
  final String? description;
  @override
  final String? author;
  @override
  final String? themeVersion;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? colorScheme;

  @override
  String toString() {
    return 'ThemeMetadata(id: $id, name: $name, specVersion: $specVersion, description: $description, author: $author, themeVersion: $themeVersion, tags: $tags, colorScheme: $colorScheme)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeMetadataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.specVersion, specVersion) ||
                other.specVersion == specVersion) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.themeVersion, themeVersion) ||
                other.themeVersion == themeVersion) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.colorScheme, colorScheme) ||
                other.colorScheme == colorScheme));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      specVersion,
      description,
      author,
      themeVersion,
      const DeepCollectionEquality().hash(_tags),
      colorScheme);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeMetadataImplCopyWith<_$ThemeMetadataImpl> get copyWith =>
      __$$ThemeMetadataImplCopyWithImpl<_$ThemeMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeMetadataImplToJson(
      this,
    );
  }
}

abstract class _ThemeMetadata implements ThemeMetadata {
  const factory _ThemeMetadata(
      {required final String id,
      required final String name,
      final String specVersion,
      final String? description,
      final String? author,
      final String? themeVersion,
      final List<String> tags,
      final String? colorScheme}) = _$ThemeMetadataImpl;

  factory _ThemeMetadata.fromJson(Map<String, dynamic> json) =
      _$ThemeMetadataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get specVersion;
  @override
  String? get description;
  @override
  String? get author;
  @override
  String? get themeVersion;
  @override
  List<String> get tags;
  @override
  String? get colorScheme;
  @override
  @JsonKey(ignore: true)
  _$$ThemeMetadataImplCopyWith<_$ThemeMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
