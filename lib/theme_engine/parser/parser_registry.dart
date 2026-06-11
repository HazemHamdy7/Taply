import 'dart:collection';

import 'internal_parser.dart';
import '../utils/semver_utils.dart';

typedef MigrationHook = Map<String, dynamic> Function(
    Map<String, dynamic> json, String fromVersion, String toVersion);

class ParserRegistry {
  final Map<String, List<InternalParser>> _parsers = {};
  final Map<String, List<MigrationHook>> _migrationHooks = {};
  final Set<String> _discovered = {};

  void register(InternalParser parser) {
    _parsers.putIfAbsent(parser.key, () => []);
    _parsers[parser.key]!.add(parser);
    _parsers[parser.key]!
        .sort((a, b) => SemverUtils.compare(b.supportedVersion, a.supportedVersion));
  }

  void registerAll(Iterable<InternalParser> parsers) {
    for (final p in parsers) {
      register(p);
    }
  }

  void registerMigrationHook(String key, MigrationHook hook) {
    _migrationHooks.putIfAbsent(key, () => []);
    _migrationHooks[key]!.add(hook);
  }

  InternalParser? get(String key, {String? version}) {
    final entries = _parsers[key];
    if (entries == null || entries.isEmpty) return null;
    if (version == null) return entries.first;
    return entries.cast<InternalParser?>().firstWhere(
          (p) => p!.canParse(version),
          orElse: () => null,
        );
  }

  List<InternalParser> getAll(String key) {
    return List.unmodifiable(_parsers[key] ?? []);
  }

  List<InternalParser> getAllForVersion(String version) {
    final result = <InternalParser>[];
    for (final entries in _parsers.values) {
      for (final parser in entries) {
        if (parser.canParse(version)) {
          result.add(parser);
        }
      }
    }
    return result;
  }

  bool has(String key) => _parsers.containsKey(key) && _parsers[key]!.isNotEmpty;

  Set<String> get registeredKeys => UnmodifiableSetView(_parsers.keys.toSet());

  void discover() {
    _discovered.clear();
    _discovered.addAll(_parsers.keys);
  }

  Set<String> get discoveredKeys => UnmodifiableSetView(_discovered);

  bool isDiscovered(String key) => _discovered.contains(key);

  void registerDiscovery(String key) {
    _discovered.add(key);
  }

  Map<String, dynamic> runMigrationHooks(
      String key, Map<String, dynamic> json, String fromVersion, String toVersion) {
    final hooks = _migrationHooks[key] ?? [];
    var result = json;
    for (final hook in hooks) {
      result = hook(result, fromVersion, toVersion);
    }
    return result;
  }

  void clear() {
    _parsers.clear();
    _migrationHooks.clear();
    _discovered.clear();
  }

  int get parserCount =>
      _parsers.values.fold(0, (sum, list) => sum + list.length);

  int get hookCount =>
      _migrationHooks.values.fold(0, (sum, list) => sum + list.length);
}
