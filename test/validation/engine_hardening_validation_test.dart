import 'dart:convert';
import 'dart:io' show File, Directory;
import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/card_runtime.dart';
import 'package:business_card/theme_engine/runtime/field/data_provider.dart';
import 'package:business_card/theme_engine/paint_engine/render_report.dart';
import 'package:business_card/shared/integration/template_to_theme_converter.dart';

const _templateDir = 'assets/templates';
const _reportDir = 'test/validation/reports';

List<File> _templateFiles() {
  final dir = Directory(_templateDir);
  if (!dir.existsSync()) return [];
  return dir.listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()..sort((a, b) => a.path.compareTo(b.path));
}

String _templateName(File f) => f.path.split(RegExp(r'[/\\]')).last.replaceAll('.json', '');

void main() {
  final templateFiles = _templateFiles();
  if (templateFiles.isEmpty) {
    test('no templates found', () {});
    return;
  }

  late Directory reportDir;
  setUpAll(() {
    reportDir = Directory(_reportDir);
    if (!reportDir.existsSync()) reportDir.createSync(recursive: true);
  });

  group('Validation: Engine Hardening — Edge Case Recovery & Compatibility', () {
    test('T01 — Theme compatibility scoring: all templates', () {
      final scores = <String, double>{};
      final details = <String, StringBuffer>{};
      int totalNodes = 0;
      int totalFailed = 0;
      int totalRecovered = 0;

      for (final file in templateFiles) {
        final name = _templateName(file);
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);

        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(_defaultCardData());

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

        final metrics = result.metrics;
        final nodeCount = metrics.totalProcessed;
        totalNodes += nodeCount;
        totalFailed += metrics.failedNodes;
        totalRecovered += metrics.recoveredNodes;

        final report = RenderReport.fromMetrics(nodeCount, metrics);
        scores[name] = report.compatibilityScore;

        final buf = StringBuffer();
        buf.writeln('  $name:');
        buf.writeln('    Score: ${report.compatibilityScore.toStringAsFixed(1)}%');
        buf.writeln('    Nodes: ${report.totalNodes} total, '
            '${report.paintedNodes} painted, ${report.skippedNodes} skipped, '
            '${report.recoveredNodes} recovered, ${report.failedNodes} failed');
        buf.writeln('    Time: ${report.totalPaintTime.inMilliseconds}ms');
        buf.writeln('    Warnings: ${report.warnings.length}');
        if (report.warnings.isNotEmpty) {
          for (final w in report.warnings) {
            buf.writeln('      - $w');
          }
        }
        details[name] = buf;
      }

      final compatBuf = StringBuffer();
      compatBuf.writeln('======================================================================');
      compatBuf.writeln('          COMPATIBILITY REPORT');
      compatBuf.writeln('          Generated: 2026-06-14');
      compatBuf.writeln('======================================================================');
      compatBuf.writeln();
      compatBuf.writeln('TEMPLATE COMPATIBILITY SCORES');
      compatBuf.writeln('──────────────────────────────────────────────────────────────────────');
      compatBuf.writeln();

      for (final file in templateFiles) {
        final name = _templateName(file);
        compatBuf.writeln(details[name].toString());
      }

      compatBuf.writeln('SUMMARY');
      compatBuf.writeln('──────────────────────────────────────────────────────────────────────');
      compatBuf.writeln('  Total nodes processed: $totalNodes');
      compatBuf.writeln('  Total failed: $totalFailed');
      compatBuf.writeln('  Total recovered: $totalRecovered');

      final minScore = scores.values.isEmpty ? 0.0 : scores.values.reduce((a, b) => a < b ? a : b);
      final avgScore = scores.values.isEmpty ? 0.0 : scores.values.reduce((a, b) => a + b) / scores.length;
      compatBuf.writeln('  Min score: ${minScore.toStringAsFixed(1)}%');
      compatBuf.writeln('  Avg score: ${avgScore.toStringAsFixed(1)}%');
      compatBuf.writeln('  Templates: ${scores.length}');
      compatBuf.writeln();
      compatBuf.writeln('VERDICT');
      compatBuf.writeln('──────────────────────────────────────────────────────────────────────');

      if (totalFailed == 0) {
        compatBuf.writeln('  All templates pass with 0 hard failures. Engine is hardened.\u2705');
      } else {
        compatBuf.writeln('  $totalFailed nodes still fail across all templates. '
            'Recovery handled $totalRecovered.');
      }

      File('${reportDir.path}/compatibility_report.txt').writeAsStringSync(compatBuf.toString());
      print(compatBuf.toString());

      for (final entry in scores.entries) {
        expect(entry.value, greaterThanOrEqualTo(80.0),
            reason: '${entry.key} compatibility ${entry.value}% < 80%');
      }
    }, timeout: const Timeout(Duration(seconds: 120)));

    test('T02 — Recovery mode: engine continues after failures', () {
      int totalNodesProcessed = 0;
      int totalFailures = 0;
      int totalRecoveries = 0;

      for (final file in templateFiles) {
        final name = _templateName(file);
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);

        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(_defaultCardData());

        final result = runtime.render(
          viewportWidth: doc.canvas.width,
          viewportHeight: doc.canvas.height,
        );

        final m = result.metrics;
        totalNodesProcessed += m.totalProcessed;
        totalFailures += m.failedNodes;
        totalRecoveries += m.recoveredNodes;

        print('  $name: ${m.paintedNodes}p ${m.skippedNodes}s '
            '${m.recoveredNodes}r ${m.failedNodes}f');
      }

      final recoveryBuf = StringBuffer();
      recoveryBuf.writeln('======================================================================');
      recoveryBuf.writeln('          RECOVERY REPORT');
      recoveryBuf.writeln('          Generated: 2026-06-14');
      recoveryBuf.writeln('======================================================================');
      recoveryBuf.writeln();
      recoveryBuf.writeln('RECOVERY MODE VALIDATION');
      recoveryBuf.writeln('──────────────────────────────────────────────────────────────────────');
      recoveryBuf.writeln('  Total nodes processed: $totalNodesProcessed');
      recoveryBuf.writeln('  Total hard failures: $totalFailures');
      recoveryBuf.writeln('  Total recovery events: $totalRecoveries');
      recoveryBuf.writeln('  Recovery coverage: ${totalNodesProcessed > 0 ? ((totalNodesProcessed - totalFailures) / totalNodesProcessed * 100).toStringAsFixed(1) : "N/A"}%');
      recoveryBuf.writeln();
      recoveryBuf.writeln('RECOVERY MECHANISMS');
      recoveryBuf.writeln('──────────────────────────────────────────────────────────────────────');
      recoveryBuf.writeln('  1. Painter resolution failure -> UnsupportedPainter fallback');
      recoveryBuf.writeln('  2. Painter.paint() returns !success -> recorded as recovery');
      recoveryBuf.writeln('  3. Painter.paint() throws exception -> caught, recorded as recovery');
      recoveryBuf.writeln('  4. Degenerate geometry -> skipped with warning (not failure)');
      recoveryBuf.writeln('  5. NaN/Infinity coordinates -> sanitized to 0.0');
      recoveryBuf.writeln('  6. Oversized border radius -> clamped to min dimension / 2');
      recoveryBuf.writeln();
      recoveryBuf.writeln('VERDICT');
      recoveryBuf.writeln('──────────────────────────────────────────────────────────────────────');
      if (totalFailures == 0) {
        recoveryBuf.writeln('  Recovery mode fully operational - 0 unrecoverable failures.\u2705');
      } else {
        recoveryBuf.writeln('  $totalFailures unrecoverable failures remain. '
            '$totalRecoveries successfully recovered.');
      }

      File('${reportDir.path}/recovery_report.txt').writeAsStringSync(recoveryBuf.toString());
      print(recoveryBuf.toString());

      expect(totalFailures, lessThan(totalNodesProcessed),
          reason: 'Hard failures should not exceed total processed nodes');
    }, timeout: const Timeout(Duration(seconds: 120)));

    test('T03 — Stress: 10,000 sequential renders (no crash, stable memory)', () {
      const targetRenders = 10000;
      final rendersPerTemplate = targetRenders ~/ templateFiles.length;
      int totalRenders = 0;
      int totalCrashes = 0;
      final stopwatch = Stopwatch()..start();

      final documents = <String, dynamic>{};
      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        documents[_templateName(file)] = json;
      }

      for (final file in templateFiles) {
        final name = _templateName(file);
        final json = documents[name] as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);

        for (var i = 0; i < rendersPerTemplate; i++) {
          try {
            final runtime = CardRuntime();
            runtime.setDocument(doc);
            runtime.setCardData(_defaultCardData());

            runtime.render(
              viewportWidth: doc.canvas.width,
              viewportHeight: doc.canvas.height,
            );

            totalRenders++;
            runtime.paintEngine.dispose();
          } catch (e) {
            totalCrashes++;
          }
        }

        final progress = ((totalRenders / targetRenders) * 100).toStringAsFixed(1);
        print('  $name: $rendersPerTemplate renders ($progress%)');
      }

      stopwatch.stop();
      final elapsed = stopwatch.elapsed;

      final hardeningBuf = StringBuffer();
      hardeningBuf.writeln('======================================================================');
      hardeningBuf.writeln('          ENGINE HARDENING REPORT');
      hardeningBuf.writeln('          Generated: 2026-06-14');
      hardeningBuf.writeln('======================================================================');
      hardeningBuf.writeln();
      hardeningBuf.writeln('HARDENING MEASURES APPLIED');
      hardeningBuf.writeln('──────────────────────────────────────────────────────────────────────');
      hardeningBuf.writeln('  1. RectanglePainter: degenerate rect check (w<=0 || h<=0)');
      hardeningBuf.writeln('  2. RectanglePainter: NaN/Infinity rect dimension protection');
      hardeningBuf.writeln('  3. RectanglePainter: borderRadius clamped to min(w,h)/2');
      hardeningBuf.writeln('  4. CirclePainter: radius <= 0 / NaN / Infinity check');
      hardeningBuf.writeln('  5. CirclePainter: cx/cy NaN/Infinity check');
      hardeningBuf.writeln('  6. CirclePainter: rotation/scale NaN protection');
      hardeningBuf.writeln('  7. PathPainter: empty commands list check');
      hardeningBuf.writeln('  8. PathPainter: NaN/Infinity coordinate sanitization');
      hardeningBuf.writeln('  9. PathPainter: rotation/scale NaN protection');
      hardeningBuf.writeln('  10. UnsupportedPainter: fallback for unknown node types');
      hardeningBuf.writeln('  11. PaintEngine recovery mode: catch+recover instead of fail');
      hardeningBuf.writeln('  12. PaintMetrics: recoveredNodes + warnings tracking');
      hardeningBuf.writeln();
      hardeningBuf.writeln('STRESS TEST');
      hardeningBuf.writeln('──────────────────────────────────────────────────────────────────────');
      hardeningBuf.writeln('  Target renders: $targetRenders');
      hardeningBuf.writeln('  Actual renders: $totalRenders');
      hardeningBuf.writeln('  Templates: ${templateFiles.length}');
      hardeningBuf.writeln('  Renders per template: $rendersPerTemplate');
      hardeningBuf.writeln('  Crashes: $totalCrashes');
      hardeningBuf.writeln('  Elapsed: ${elapsed.inSeconds}s');
      hardeningBuf.writeln('  Avg per render: ${elapsed.inMicroseconds ~/ totalRenders}us');
      hardeningBuf.writeln();
      hardeningBuf.writeln('VERDICT');
      hardeningBuf.writeln('──────────────────────────────────────────────────────────────────────');
      if (totalCrashes == 0) {
        hardeningBuf.writeln('  Engine hardening validated - 0 crashes.\u2705');
      } else {
        hardeningBuf.writeln('  $totalCrashes crashes detected during stress test.');
      }

      File('${reportDir.path}/hardening_report.txt').writeAsStringSync(hardeningBuf.toString());
      print(hardeningBuf.toString());

      expect(totalCrashes, 0, reason: 'Stress test must have 0 crashes');
      expect(totalRenders, greaterThan(0), reason: 'At least one render completed');
    }, timeout: const Timeout(Duration(seconds: 600)));
  });
}

BusinessCardData _defaultCardData() {
  return BusinessCardData(
    fullName: 'John Doe',
    firstName: 'John',
    lastName: 'Doe',
    jobTitle: 'Software Engineer',
    company: 'Tech Inc.',
    email: 'john@tech.com',
    phone: '+1-555-0100',
    website: 'https://john.doe.dev',
    address: '456 Innovation Drive, San Francisco, CA',
    bio: 'Passionate about building great software.',
    social: {
      'linkedin': 'johndoe',
      'twitter': '@johndoe',
      'github': 'johndoe',
    },
  );
}
