import '../models/theme_document.dart';

/// Service for migrating themes between specification versions.
class MigrationService {
  /// Migrates a [theme] from [fromVersion] to [toVersion].
  ThemeDocument migrate(ThemeDocument theme, String fromVersion, String toVersion) {
    throw UnimplementedError('MigrationService.migrate');
  }

  /// Returns `true` if a migration path exists between the two versions.
  bool canMigrate(String fromVersion, String toVersion) {
    throw UnimplementedError('MigrationService.canMigrate');
  }

  /// Returns the latest supported theme version.
  String get latestVersion {
    throw UnimplementedError('MigrationService.latestVersion');
  }
}
