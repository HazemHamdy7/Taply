import 'package:meta/meta.dart';

/// Represents a set of responsive breakpoints for adaptive layouts.
@immutable
class BreakpointSet {
  /// Named breakpoints keyed by identifier (e.g., `"sm"`, `"md"`, `"lg"`).
  final Map<String, double> breakpoints;

  /// Creates a [BreakpointSet].
  const BreakpointSet({
    this.breakpoints = const {},
  });

  /// Creates a [BreakpointSet] from a JSON map.
  factory BreakpointSet.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('BreakpointSet.fromJson');
  }

  /// Converts this set to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('BreakpointSet.toJson');
  }
}
