import 'package:freezed_annotation/freezed_annotation.dart';

part 'spacing_set.freezed.dart';
part 'spacing_set.g.dart';

@freezed
class SpacingSet with _$SpacingSet {
  const factory SpacingSet({
    @Default('8.0') String xs,
    @Default('12.0') String sm,
    @Default('16.0') String md,
    @Default('24.0') String lg,
    @Default('32.0') String xl,
    @Default({}) Map<String, String> custom,
  }) = _SpacingSet;

  factory SpacingSet.fromJson(Map<String, dynamic> json) =>
      _$SpacingSetFromJson(json);
}
