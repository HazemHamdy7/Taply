import 'package:meta/meta.dart';

@immutable
class ParserOptions {
  final bool strictMode;
  final bool lenientMode;
  final bool collectUnknownFields;
  final bool enablePlugins;
  final bool resolveReferences;
  final int maxDepth;
  final String? specVersionOverride;

  const ParserOptions({
    this.strictMode = false,
    this.lenientMode = false,
    this.collectUnknownFields = true,
    this.enablePlugins = true,
    this.resolveReferences = true,
    this.maxDepth = 32,
    this.specVersionOverride,
  });

  bool get isStrictOrLenient => strictMode || lenientMode;

  bool get isLenientOnly => lenientMode && !strictMode;

  ParserOptions copyWith({
    bool? strictMode,
    bool? lenientMode,
    bool? collectUnknownFields,
    bool? enablePlugins,
    bool? resolveReferences,
    int? maxDepth,
    String? specVersionOverride,
  }) {
    return ParserOptions(
      strictMode: strictMode ?? this.strictMode,
      lenientMode: lenientMode ?? this.lenientMode,
      collectUnknownFields: collectUnknownFields ?? this.collectUnknownFields,
      enablePlugins: enablePlugins ?? this.enablePlugins,
      resolveReferences: resolveReferences ?? this.resolveReferences,
      maxDepth: maxDepth ?? this.maxDepth,
      specVersionOverride: specVersionOverride ?? this.specVersionOverride,
    );
  }
}
