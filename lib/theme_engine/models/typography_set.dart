import 'package:freezed_annotation/freezed_annotation.dart';

part 'typography_set.freezed.dart';
part 'typography_set.g.dart';

@freezed
class TextStyleDef with _$TextStyleDef {
  const factory TextStyleDef({
    double? fontSize,
    String? fontWeight,
    double? lineHeight,
    double? letterSpacing,
    String? color,
  }) = _TextStyleDef;

  factory TextStyleDef.fromJson(Map<String, dynamic> json) =>
      _$TextStyleDefFromJson(json);

}

@freezed
class TypographySet with _$TypographySet {
  const factory TypographySet({
    String? primaryFontFamily,
    String? secondaryFontFamily,
    @Default({}) Map<String, TextStyleDef> styles,
  }) = _TypographySet;

  factory TypographySet.fromJson(Map<String, dynamic> json) =>
      _$TypographySetFromJson(json);

}