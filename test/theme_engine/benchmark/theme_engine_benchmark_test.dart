import 'dart:convert';
import 'dart:io' show File, Directory;
import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/paint_engine/paint_engine.dart';
import 'package:business_card/theme_engine/parser/theme_parser.dart';
import 'package:business_card/theme_engine/renderer/render_pipeline.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';

const _themeDir = 'assets/themes';

class BenchmarkResult {
  final String name;
  final Duration parseTime;
  final Duration prepareTime;
  final Duration renderTime;
  final int nodeCount;
  final int paintedNodes;
  final int failedNodes;
  final int cacheHits;
  final int cacheMisses;

  const BenchmarkResult({
    required this.name,
    required this.parseTime,
    required this.prepareTime,
    required this.renderTime,
    required this.nodeCount,
    required this.paintedNodes,
    required this.failedNodes,
    required this.cacheHits,
    required this.cacheMisses,
  });

  Duration get totalTime => parseTime + prepareTime + renderTime;
}

void main() {
  final dir = Directory(_themeDir);
  if (!dir.existsSync()) return;

  final themeFiles = dir.listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList();

  if (themeFiles.isEmpty) return;

  group('Theme Engine Benchmark', () {
    final results = <BenchmarkResult>[];
    final allParseTimes = <Duration>[];
    final allRenderTimes = <Duration>[];

    test('Render 100 cards and collect metrics', () {
      final parser = ThemeParser();
      final pipeline = RenderPipeline();
      final paintEngine = PaintEngine();

      // Pre-parse all themes
      final documents = <ThemeDocument>[];
      final names = <String>[];
      for (final file in themeFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = parser.parse(json);
        documents.add(doc);
        names.add(file.path.split(RegExp(r'[/\\]')).last.replaceAll('.json', ''));
      }

      // Render each theme multiple times to reach ~100 total renders
      final iterations = (100 / documents.length).ceil();

      for (var i = 0; i < iterations; i++) {
        for (var j = 0; j < documents.length; j++) {
          final doc = documents[j];
          final name = names[j];

          final parseSw = Stopwatch()..start();
          // Already parsed above
          parseSw.stop();

          final prepareSw = Stopwatch()..start();
          final renderTree = pipeline.prepare(doc);
          prepareSw.stop();

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);

          final renderSw = Stopwatch()..start();
          final metrics = paintEngine.render(
            renderTree,
            doc,
            canvas: canvas,
            viewportWidth: doc.canvas.width,
            viewportHeight: doc.canvas.height,
          );
          renderSw.stop();

          recorder.endRecording();

          allParseTimes.add(parseSw.elapsed);
          allRenderTimes.add(renderSw.elapsed);

          results.add(BenchmarkResult(
            name: name,
            parseTime: parseSw.elapsed,
            prepareTime: prepareSw.elapsed,
            renderTime: renderSw.elapsed,
            nodeCount: renderTree.flatten().length,
            paintedNodes: metrics.paintedNodes,
            failedNodes: metrics.failedNodes,
            cacheHits: metrics.cacheHits,
            cacheMisses: metrics.cacheMisses,
          ));
        }
      }

      // Summary calculation
      final totalRenders = results.length;
      final totalTime = results.fold<Duration>(
        Duration.zero, (sum, r) => sum + r.totalTime);
      final totalParseTime = results.fold<Duration>(
        Duration.zero, (sum, r) => sum + r.parseTime);
      final totalPrepareTime = results.fold<Duration>(
        Duration.zero, (sum, r) => sum + r.prepareTime);
      final totalRenderTime = results.fold<Duration>(
        Duration.zero, (sum, r) => sum + r.renderTime);
      final totalNodes = results.fold<int>(0, (sum, r) => sum + r.nodeCount);
      final totalFailures = results.fold<int>(0, (sum, r) => sum + r.failedNodes);
      final totalCacheHits = results.fold<int>(0, (sum, r) => sum + r.cacheHits);
      final totalCacheMisses = results.fold<int>(0, (sum, r) => sum + r.cacheMisses);

      final avgRenderTimeMs = totalRenderTime.inMicroseconds / totalRenders / 1000.0;
      final avgParseTimeMs = totalParseTime.inMicroseconds / totalRenders / 1000.0;
      final avgTotalTimeMs = totalTime.inMicroseconds / totalRenders / 1000.0;
      final hitRatio = (totalCacheHits + totalCacheMisses) > 0
          ? totalCacheHits / (totalCacheHits + totalCacheMisses)
          : 0.0;
      final missRatio = (totalCacheHits + totalCacheMisses) > 0
          ? totalCacheMisses / (totalCacheHits + totalCacheMisses)
          : 0.0;

      print('');
      print('══════════════════════════════════════════════════');
      print('        THEME ENGINE BENCHMARK REPORT');
      print('══════════════════════════════════════════════════');
      print('  Themes:             ${documents.length} unique × $iterations');
      print('  Total renders:      $totalRenders');
      print('  Total nodes:        $totalNodes');
      print('  Total failures:     $totalFailures');
      print('');
      print('  ── Timing (average per render) ──');
      print('  Parse time:         ${avgParseTimeMs.toStringAsFixed(3)}ms');
      print('  Prepare time:       ${(totalPrepareTime.inMicroseconds / totalRenders / 1000.0).toStringAsFixed(3)}ms');
      print('  Render time:        ${avgRenderTimeMs.toStringAsFixed(3)}ms');
      print('  Total time:         ${avgTotalTimeMs.toStringAsFixed(3)}ms');
      print('');
      print('  ── Cache ──');
      print('  Cache hits:         $totalCacheHits');
      print('  Cache misses:       $totalCacheMisses');
      print('  Cache hit ratio:    ${(hitRatio * 100).toStringAsFixed(1)}%');
      print('  Cache miss ratio:   ${(missRatio * 100).toStringAsFixed(1)}%');
      print('');
      print('  ── Reliability ──');
      print('  Zero-failure runs:  ${results.where((r) => r.failedNodes == 0).length} / $totalRenders');
      print('  Success rate:       ${((totalRenders - results.where((r) => r.failedNodes > 0).length) / totalRenders * 100).toStringAsFixed(1)}%');
      print('══════════════════════════════════════════════════');
      print('');

      // Verify no failures
      expect(totalFailures, equals(0),
          reason: 'Expected 0 rendering failures across all benchmarks');
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}
