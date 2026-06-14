import '../models/theme_document.dart';
import 'runtime_cache.dart';

enum RuntimeMode { preview, render, export }

class RuntimeContext {
  final ThemeDocument document;
  final RuntimeMode mode;
  final RuntimeCache cache;

  RuntimeContext({
    required this.document,
    this.mode = RuntimeMode.render,
    RuntimeCache? cache,
  }) : cache = cache ?? RuntimeCache();

  RuntimeContext copyWith({
    ThemeDocument? document,
    RuntimeMode? mode,
    RuntimeCache? cache,
  }) {
    return RuntimeContext(
      document: document ?? this.document,
      mode: mode ?? this.mode,
      cache: cache ?? this.cache,
    );
  }
}
