import 'package:freezed_annotation/freezed_annotation.dart';

part 'radius_set.freezed.dart';
part 'radius_set.g.dart';

@freezed
class RadiusSet with _$RadiusSet {
  const factory RadiusSet({
    @Default('0') String none,
    @Default('4.0') String sm,
    @Default('8.0') String md,
    @Default('12.0') String lg,
    @Default('16.0') String xl,
    @Default('9999') String full,
    @Default({}) Map<String, String> custom,
  }) = _RadiusSet;

  factory RadiusSet.fromJson(Map<String, dynamic> json) =>
      _$RadiusSetFromJson(json);
}
