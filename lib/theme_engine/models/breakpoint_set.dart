import 'package:freezed_annotation/freezed_annotation.dart';

part 'breakpoint_set.freezed.dart';
part 'breakpoint_set.g.dart';

@freezed
class BreakpointSet with _$BreakpointSet {
  const factory BreakpointSet({
    @Default({}) Map<String, double> breakpoints,
  }) = _BreakpointSet;

  factory BreakpointSet.fromJson(Map<String, dynamic> json) =>
      _$BreakpointSetFromJson(json);

}