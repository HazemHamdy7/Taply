/// Configuration for a [CardRuntime].
class RuntimeConfig {
  final bool enableExpressionEvaluation;
  final bool enableFieldValidation;
  final bool enableAutoRefresh;
  final Duration refreshInterval;
  final Map<String, String> defaultValues;

  const RuntimeConfig({
    this.enableExpressionEvaluation = true,
    this.enableFieldValidation = true,
    this.enableAutoRefresh = false,
    this.refreshInterval = Duration.zero,
    this.defaultValues = const {},
  });

  RuntimeConfig copyWith({
    bool? enableExpressionEvaluation,
    bool? enableFieldValidation,
    bool? enableAutoRefresh,
    Duration? refreshInterval,
    Map<String, String>? defaultValues,
  }) {
    return RuntimeConfig(
      enableExpressionEvaluation:
          enableExpressionEvaluation ?? this.enableExpressionEvaluation,
      enableFieldValidation:
          enableFieldValidation ?? this.enableFieldValidation,
      enableAutoRefresh: enableAutoRefresh ?? this.enableAutoRefresh,
      refreshInterval: refreshInterval ?? this.refreshInterval,
      defaultValues: defaultValues ?? this.defaultValues,
    );
  }
}
