import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_metadata.freezed.dart';
part 'theme_metadata.g.dart';

@freezed
class ThemeMetadata with _$ThemeMetadata {
  const factory ThemeMetadata({
    required String id,
    required String name,
    @Default('2.0.0') String specVersion,
    String? description,
    String? author,
    String? themeVersion,
    @Default([]) List<String> tags,
    String? colorScheme,
  }) = _ThemeMetadata;

  factory ThemeMetadata.fromJson(Map<String, dynamic> json) =>
      _$ThemeMetadataFromJson(json);

}