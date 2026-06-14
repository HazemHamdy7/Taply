import '../taply_theme_runtime.dart';

/// Provides [BusinessCardData] to the runtime.
///
/// Implement this interface to supply card data from any source
/// (local storage, network, user input, etc.).
abstract class DataProvider {
  /// Load business card data.
  Future<BusinessCardData> load();

  /// Save business card data.
  Future<void> save(BusinessCardData data);

  /// Subscribe to data changes.
  void addListener(void Function(BusinessCardData data) listener);

  /// Remove a change listener.
  void removeListener(void Function(BusinessCardData data) listener);
}
