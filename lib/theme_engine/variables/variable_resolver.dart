import '../interfaces/variable_resolver_interface.dart';
import '../models/theme_variables.dart';

/// Default implementation of [IVariableResolver].
///
/// Resolves `$variable` references in theme values. Supports nested
/// resolution with cycle detection.
class VariableResolver implements IVariableResolver {
  @override
  dynamic resolve(String name) {
    throw UnimplementedError('VariableResolver.resolve');
  }

  @override
  Map<String, dynamic> resolveAll(ThemeVariables variables) {
    throw UnimplementedError('VariableResolver.resolveAll');
  }

  @override
  bool hasVariableReference(dynamic value) {
    throw UnimplementedError('VariableResolver.hasVariableReference');
  }

  @override
  List<String> extractReferences(dynamic value) {
    throw UnimplementedError('VariableResolver.extractReferences');
  }
}
