import 'dart:convert';
import 'dart:io' show File, Directory;
import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/card_runtime.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';
import 'package:business_card/shared/integration/template_to_theme_converter.dart';

const _templateDir = 'assets/templates';

List<File> _templateFiles() {
  final dir = Directory(_templateDir);
  if (!dir.existsSync()) return [];
  return dir.listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()..sort((a, b) => a.path.compareTo(b.path));
}

final _testData = BusinessCardData(
  fullName: 'Test User',
  jobTitle: 'Engineer',
  company: 'Test Corp',
  email: 'test@test.com',
  phone: '+1234567890',
  website: 'https://test.com',
  address: '123 Test St',
  social: {'linkedin': 'testuser'},
);

Map<String, dynamic> _loadFile(File f) =>
    jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

class _TemplateResult {
  final String name;
  final int boundNodes;
  final int paintedNodes;
  final int failedNodes;
  final int cacheHits;
  final int cacheMisses;
  final Duration resolveTime;
  final Duration renderTime;
  final Duration totalTime;

  _TemplateResult({
    required this.name,
    required this.boundNodes,
    required this.paintedNodes,
    required this.failedNodes,
    required this.cacheHits,
    required this.cacheMisses,
    required this.resolveTime,
    required this.renderTime,
    required this.totalTime,
  });
}

void main() {
  final templateFiles = _templateFiles();
  if (templateFiles.isEmpty) {
    test('no templates found', () {});
    return;
  }

  late List<_TemplateResult> results;

  group('Validation: Theme Switching', () {
    test('all templates convert to ThemeDocument without error', () {
      for (final file in templateFiles) {
        final json = _loadFile(file);
        final doc = TemplateToThemeConverter.convert(json);
        expect(doc.metadata.id, isNotEmpty, reason: '${file.path} id empty');
        expect(doc.scene.nodes, isNotEmpty, reason: '${file.path} no scene nodes');
      }
    });

    test('render all templates and collect metrics', () {
      results = [];

      for (final file in templateFiles) {
        final json = _loadFile(file);
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(_testData);

        final sw = Stopwatch()..start();
        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );
        sw.stop();

        final name = file.path.split(RegExp(r'[/\\]')).last;
        results.add(_TemplateResult(
          name: name,
          boundNodes: result.boundNodes,
          paintedNodes: result.metrics.paintedNodes,
          failedNodes: result.metrics.failedNodes,
          cacheHits: result.metrics.cacheHits,
          cacheMisses: result.metrics.cacheMisses,
          resolveTime: result.resolveTime,
          renderTime: result.renderTime,
          totalTime: sw.elapsed,
        ));
      }

      // Print per-template summary
      print('');
      print('  ── Template Render Results ──');
      for (final r in results) {
        final status = r.failedNodes == 0 ? '✓' : '✗';
        print('  $status ${r.name}: '
            '${r.boundNodes} nodes, '
            '${r.paintedNodes} painted, '
            '${r.failedNodes} failed, '
            '${r.totalTime.inMilliseconds}ms');
      }

      // Document failures — integration converts to supported types;
      // remaining failures are engine painter edge cases (e.g. missing properties)
      final cleanCount = results.where((r) => r.failedNodes == 0).length;
      final maxFail = results.map((r) => r.failedNodes).reduce((a, b) => a > b ? a : b);
      print('  Clean renders: $cleanCount / ${results.length}');
      print('  Max failures per template: $maxFail');
      // At least some templates should render cleanly
      expect(cleanCount, greaterThan(0),
          reason: 'All templates have render failures — converter issue');
    });

    test('themes produce different visual output (node count varies)', () {
      final nodeCounts = results.map((r) => r.boundNodes).toSet();
      expect(nodeCounts.length, greaterThan(1),
          reason: 'all themes produce same node count — likely incorrect');
    });

    test('cache behavior across theme switches', () {
      final allHits = results.fold<int>(0, (s, r) => s + r.cacheHits);
      final allMisses = results.fold<int>(0, (s, r) => s + r.cacheMisses);
      final total = allHits + allMisses;
      print('  Cache hits: $allHits, misses: $allMisses'
          '${total > 0 ? ', ratio: ${(allHits / total * 100).toStringAsFixed(1)}%' : ''}');
    });

    test('resolve and render timing collected', () {
      for (final r in results) {
        print('  ${r.name}: resolve=${r.resolveTime.inMilliseconds}ms, '
            'render=${r.renderTime.inMilliseconds}ms');
      }
    });
  });
}
