import '../models/theme_document.dart';

/// Service for exporting themes to various output formats.
class ExportService {
  /// Exports a [theme] as a JSON map.
  Map<String, dynamic> exportToJson(ThemeDocument theme) {
    throw UnimplementedError('ExportService.exportToJson');
  }

  /// Exports a [theme] as a formatted JSON string.
  String exportToJsonString(ThemeDocument theme) {
    throw UnimplementedError('ExportService.exportToJsonString');
  }

  /// Exports a [theme] for external consumption by the Taply Theme API.
  Map<String, dynamic> exportForApi(ThemeDocument theme) {
    throw UnimplementedError('ExportService.exportForApi');
  }
}
