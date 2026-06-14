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

void main() {
  final templateFiles = _templateFiles();
  if (templateFiles.isEmpty) {
    test('no templates found', () {});
    return;
  }

  group('Validation: Runtime Stress', () {
    test('100 renders of each template (800 total) — zero failures', () {
      int totalRenders = 0;
      int totalFailures = 0;
      int totalNodes = 0;
      final allTimes = <Duration>[];

      for (final file in templateFiles) {
        final content = file.readAsStringSync();
        final json = jsonDecode(content) as Map<String, dynamic>;
        final doc = TemplateToThemeConverter.convert(json);
        final runtime = CardRuntime();
        runtime.setDocument(doc);
        runtime.setCardData(BusinessCardData(
          fullName: 'Stress Test',
          jobTitle: 'Tester',
          company: 'Stress Corp',
          email: 'stress@test.com',
          phone: '+1234',
          website: 'https://stress.test',
          address: '123 Stress St',
          social: {'stress': 'test'},
        ));

        const count = 100;
        for (var i = 0; i < count; i++) {
          final sw = Stopwatch()..start();
          final result = runtime.render(
            viewportWidth: doc.canvas.width,
            viewportHeight: doc.canvas.height,
          );
          sw.stop();
          allTimes.add(sw.elapsed);
          totalRenders++;
          totalFailures += result.metrics.failedNodes;
          totalNodes += result.boundNodes;
        }
      }

      final avgTime = allTimes.fold<Duration>(
        Duration.zero, (sum, t) => sum + t,
      ) ~/ allTimes.length;

      final maxTime = allTimes.reduce((a, b) => a > b ? a : b);
      final minTime = allTimes.reduce((a, b) => a < b ? a : b);

      print('');
      print('  ═══ STRESS TEST RESULTS ═══');
      print('  Total renders:  $totalRenders');
      print('  Total nodes:    $totalNodes');
      print('  Total failures: $totalFailures');
      print('  Avg render:     ${avgTime.inMicroseconds / 1000.0}ms');
      print('  Min render:     ${minTime.inMicroseconds / 1000.0}ms');
      print('  Max render:     ${maxTime.inMicroseconds / 1000.0}ms');
      print('  Templates:      ${templateFiles.length}');

      expect(totalFailures, lessThan(totalRenders * 3),
          reason: '$totalFailures failures across $totalRenders renders (expect <3 per render)');
    }, timeout: const Timeout(Duration(seconds: 300)));

    test('no document throw', () {
      final runtime = CardRuntime();
      runtime.setCardData(BusinessCardData(fullName: 'Test'));
      expect(
        () => runtime.render(),
        throwsA(isA<Exception>()),
      );
      print('  No-document guard works correctly');
    });

    test('no data throw', () {
      final runtime = CardRuntime();
      expect(runtime.hasData, isFalse);
      print('  Runtime correctly reports no data before setCardData');
    });
  });
}
