import '../taply_theme_runtime.dart';

/// The runtime for a single business card.
///
/// Manages the lifecycle of card data, field resolution,
/// and expression evaluation during rendering.
class CardRuntime {
  final RuntimeConfig config;
  final FieldResolver fieldResolver;
  final ExpressionResolver expressionResolver;
  final DataProvider? dataProvider;

  BusinessCardData _data;
  CardState _state;

  CardRuntime({
    RuntimeConfig? config,
    FieldResolver? fieldResolver,
    ExpressionResolver? expressionResolver,
    this.dataProvider,
    BusinessCardData? data,
  })  : config = config ?? const RuntimeConfig(),
        fieldResolver = fieldResolver ?? FieldResolver(),
        expressionResolver = expressionResolver ?? ExpressionResolver(),
        _data = data ?? BusinessCardData.empty,
        _state = CardState.idle;

  BusinessCardData get data => _data;
  CardState get state => _state;

  /// Initialize the runtime.
  Future<void> initialize() async {
    _state = CardState.loading;
    if (dataProvider != null) {
      _data = await dataProvider!.load();
    }
    _state = CardState.ready;
  }

  /// Resolve a field value from the card data.
  String? resolveField(String field) {
    return fieldResolver.resolve(field, _data, this);
  }

  /// Evaluate an expression string.
  String evaluateExpression(String expression) {
    return expressionResolver.evaluate(expression, this);
  }

  /// Update card data at runtime.
  void updateData(BusinessCardData newData) {
    _data = newData;
    _state = CardState.ready;
  }

  /// Refresh data from the data provider.
  Future<void> refresh() async {
    if (dataProvider != null) {
      _state = CardState.loading;
      _data = await dataProvider!.load();
      _state = CardState.ready;
    }
  }

  /// Dispose of runtime resources.
  void dispose() {
    _state = CardState.disposed;
  }
}
