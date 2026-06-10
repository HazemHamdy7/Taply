// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_components.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ComponentProperty _$ComponentPropertyFromJson(Map<String, dynamic> json) {
  return _ComponentProperty.fromJson(json);
}

/// @nodoc
mixin _$ComponentProperty {
  String get type => throw _privateConstructorUsedError;
  dynamic get defaultValue => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComponentPropertyCopyWith<ComponentProperty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComponentPropertyCopyWith<$Res> {
  factory $ComponentPropertyCopyWith(
          ComponentProperty value, $Res Function(ComponentProperty) then) =
      _$ComponentPropertyCopyWithImpl<$Res, ComponentProperty>;
  @useResult
  $Res call({String type, dynamic defaultValue, String? description});
}

/// @nodoc
class _$ComponentPropertyCopyWithImpl<$Res, $Val extends ComponentProperty>
    implements $ComponentPropertyCopyWith<$Res> {
  _$ComponentPropertyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? defaultValue = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComponentPropertyImplCopyWith<$Res>
    implements $ComponentPropertyCopyWith<$Res> {
  factory _$$ComponentPropertyImplCopyWith(_$ComponentPropertyImpl value,
          $Res Function(_$ComponentPropertyImpl) then) =
      __$$ComponentPropertyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, dynamic defaultValue, String? description});
}

/// @nodoc
class __$$ComponentPropertyImplCopyWithImpl<$Res>
    extends _$ComponentPropertyCopyWithImpl<$Res, _$ComponentPropertyImpl>
    implements _$$ComponentPropertyImplCopyWith<$Res> {
  __$$ComponentPropertyImplCopyWithImpl(_$ComponentPropertyImpl _value,
      $Res Function(_$ComponentPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? defaultValue = freezed,
    Object? description = freezed,
  }) {
    return _then(_$ComponentPropertyImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComponentPropertyImpl implements _ComponentProperty {
  const _$ComponentPropertyImpl(
      {required this.type, this.defaultValue, this.description});

  factory _$ComponentPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComponentPropertyImplFromJson(json);

  @override
  final String type;
  @override
  final dynamic defaultValue;
  @override
  final String? description;

  @override
  String toString() {
    return 'ComponentProperty(type: $type, defaultValue: $defaultValue, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComponentPropertyImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.defaultValue, defaultValue) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type,
      const DeepCollectionEquality().hash(defaultValue), description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ComponentPropertyImplCopyWith<_$ComponentPropertyImpl> get copyWith =>
      __$$ComponentPropertyImplCopyWithImpl<_$ComponentPropertyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComponentPropertyImplToJson(
      this,
    );
  }
}

abstract class _ComponentProperty implements ComponentProperty {
  const factory _ComponentProperty(
      {required final String type,
      final dynamic defaultValue,
      final String? description}) = _$ComponentPropertyImpl;

  factory _ComponentProperty.fromJson(Map<String, dynamic> json) =
      _$ComponentPropertyImpl.fromJson;

  @override
  String get type;
  @override
  dynamic get defaultValue;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$ComponentPropertyImplCopyWith<_$ComponentPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ComponentSchema _$ComponentSchemaFromJson(Map<String, dynamic> json) {
  return _ComponentSchema.fromJson(json);
}

/// @nodoc
mixin _$ComponentSchema {
  String get id => throw _privateConstructorUsedError;
  Map<String, ComponentProperty> get properties =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComponentSchemaCopyWith<ComponentSchema> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComponentSchemaCopyWith<$Res> {
  factory $ComponentSchemaCopyWith(
          ComponentSchema value, $Res Function(ComponentSchema) then) =
      _$ComponentSchemaCopyWithImpl<$Res, ComponentSchema>;
  @useResult
  $Res call({String id, Map<String, ComponentProperty> properties});
}

/// @nodoc
class _$ComponentSchemaCopyWithImpl<$Res, $Val extends ComponentSchema>
    implements $ComponentSchemaCopyWith<$Res> {
  _$ComponentSchemaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? properties = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, ComponentProperty>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComponentSchemaImplCopyWith<$Res>
    implements $ComponentSchemaCopyWith<$Res> {
  factory _$$ComponentSchemaImplCopyWith(_$ComponentSchemaImpl value,
          $Res Function(_$ComponentSchemaImpl) then) =
      __$$ComponentSchemaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, Map<String, ComponentProperty> properties});
}

/// @nodoc
class __$$ComponentSchemaImplCopyWithImpl<$Res>
    extends _$ComponentSchemaCopyWithImpl<$Res, _$ComponentSchemaImpl>
    implements _$$ComponentSchemaImplCopyWith<$Res> {
  __$$ComponentSchemaImplCopyWithImpl(
      _$ComponentSchemaImpl _value, $Res Function(_$ComponentSchemaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? properties = null,
  }) {
    return _then(_$ComponentSchemaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, ComponentProperty>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComponentSchemaImpl implements _ComponentSchema {
  const _$ComponentSchemaImpl(
      {required this.id,
      final Map<String, ComponentProperty> properties = const {}})
      : _properties = properties;

  factory _$ComponentSchemaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComponentSchemaImplFromJson(json);

  @override
  final String id;
  final Map<String, ComponentProperty> _properties;
  @override
  @JsonKey()
  Map<String, ComponentProperty> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  String toString() {
    return 'ComponentSchema(id: $id, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComponentSchemaImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, const DeepCollectionEquality().hash(_properties));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ComponentSchemaImplCopyWith<_$ComponentSchemaImpl> get copyWith =>
      __$$ComponentSchemaImplCopyWithImpl<_$ComponentSchemaImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComponentSchemaImplToJson(
      this,
    );
  }
}

abstract class _ComponentSchema implements ComponentSchema {
  const factory _ComponentSchema(
      {required final String id,
      final Map<String, ComponentProperty> properties}) = _$ComponentSchemaImpl;

  factory _ComponentSchema.fromJson(Map<String, dynamic> json) =
      _$ComponentSchemaImpl.fromJson;

  @override
  String get id;
  @override
  Map<String, ComponentProperty> get properties;
  @override
  @JsonKey(ignore: true)
  _$$ComponentSchemaImplCopyWith<_$ComponentSchemaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThemeComponents _$ThemeComponentsFromJson(Map<String, dynamic> json) {
  return _ThemeComponents.fromJson(json);
}

/// @nodoc
mixin _$ThemeComponents {
  Map<String, ComponentSchema> get schemas =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ThemeComponentsCopyWith<ThemeComponents> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeComponentsCopyWith<$Res> {
  factory $ThemeComponentsCopyWith(
          ThemeComponents value, $Res Function(ThemeComponents) then) =
      _$ThemeComponentsCopyWithImpl<$Res, ThemeComponents>;
  @useResult
  $Res call({Map<String, ComponentSchema> schemas});
}

/// @nodoc
class _$ThemeComponentsCopyWithImpl<$Res, $Val extends ThemeComponents>
    implements $ThemeComponentsCopyWith<$Res> {
  _$ThemeComponentsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemas = null,
  }) {
    return _then(_value.copyWith(
      schemas: null == schemas
          ? _value.schemas
          : schemas // ignore: cast_nullable_to_non_nullable
              as Map<String, ComponentSchema>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeComponentsImplCopyWith<$Res>
    implements $ThemeComponentsCopyWith<$Res> {
  factory _$$ThemeComponentsImplCopyWith(_$ThemeComponentsImpl value,
          $Res Function(_$ThemeComponentsImpl) then) =
      __$$ThemeComponentsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, ComponentSchema> schemas});
}

/// @nodoc
class __$$ThemeComponentsImplCopyWithImpl<$Res>
    extends _$ThemeComponentsCopyWithImpl<$Res, _$ThemeComponentsImpl>
    implements _$$ThemeComponentsImplCopyWith<$Res> {
  __$$ThemeComponentsImplCopyWithImpl(
      _$ThemeComponentsImpl _value, $Res Function(_$ThemeComponentsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schemas = null,
  }) {
    return _then(_$ThemeComponentsImpl(
      schemas: null == schemas
          ? _value._schemas
          : schemas // ignore: cast_nullable_to_non_nullable
              as Map<String, ComponentSchema>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeComponentsImpl implements _ThemeComponents {
  const _$ThemeComponentsImpl(
      {final Map<String, ComponentSchema> schemas = const {}})
      : _schemas = schemas;

  factory _$ThemeComponentsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeComponentsImplFromJson(json);

  final Map<String, ComponentSchema> _schemas;
  @override
  @JsonKey()
  Map<String, ComponentSchema> get schemas {
    if (_schemas is EqualUnmodifiableMapView) return _schemas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_schemas);
  }

  @override
  String toString() {
    return 'ThemeComponents(schemas: $schemas)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeComponentsImpl &&
            const DeepCollectionEquality().equals(other._schemas, _schemas));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_schemas));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeComponentsImplCopyWith<_$ThemeComponentsImpl> get copyWith =>
      __$$ThemeComponentsImplCopyWithImpl<_$ThemeComponentsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeComponentsImplToJson(
      this,
    );
  }
}

abstract class _ThemeComponents implements ThemeComponents {
  const factory _ThemeComponents({final Map<String, ComponentSchema> schemas}) =
      _$ThemeComponentsImpl;

  factory _ThemeComponents.fromJson(Map<String, dynamic> json) =
      _$ThemeComponentsImpl.fromJson;

  @override
  Map<String, ComponentSchema> get schemas;
  @override
  @JsonKey(ignore: true)
  _$$ThemeComponentsImplCopyWith<_$ThemeComponentsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
