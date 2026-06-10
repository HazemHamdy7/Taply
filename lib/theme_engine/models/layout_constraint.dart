import 'package:freezed_annotation/freezed_annotation.dart';

part 'layout_constraint.freezed.dart';
part 'layout_constraint.g.dart';

@freezed
class LayoutConstraint with _$LayoutConstraint {
  const factory LayoutConstraint({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) = _LayoutConstraint;

  factory LayoutConstraint.fromJson(Map<String, dynamic> json) =>
      _$LayoutConstraintFromJson(json);

}