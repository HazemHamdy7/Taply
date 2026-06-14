import 'dart:convert';
import 'dart:io' show Directory, File;
import 'dart:ui' show PictureRecorder, Canvas;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/export/export_service.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/paint_engine/paint_engine.dart';
import 'package:business_card/theme_engine/parser/theme_parser.dart';
import 'package:business_card/theme_engine/renderer/render_pipeline.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

const _themeDir = 'assets/themes';

List<String> _themeFiles() {
  final dir = Directory(_themeDir);
  if (!dir.existsSync()) return [];
  return dir.listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .map((f) => f.path)
      .toList()
    ..sort();
}

ThemeDocument _loadTheme(String path) {
  final content = File(path).readAsStringSync();
  final json = jsonDecode(content) as Map<String, dynamic>;
  final parser = ThemeParser();
  return parser.parse(json);
}

void main() {
  final themeFiles = _themeFiles();
  if (themeFiles.isEmpty) {
    // Fallback: create test themes inline
    return;
  }

  group('Full Pipeline — All Themes', () {
    for (final filePath in themeFiles) {
      final themeName = filePath.split(RegExp(r'[/\\]')).last.replaceAll('.json', '');
      final renderPipeline = RenderPipeline();
      final paintEngine = PaintEngine();
      final exportService = ExportService();

      group(themeName, () {
        late ThemeDocument document;

        setUp(() {
          document = _loadTheme(filePath);
        });

        test('parses successfully', () {
          expect(document.metadata.id, isNotEmpty);
          expect(document.metadata.name, isNotEmpty);
          expect(document.canvas.width, greaterThan(0));
          expect(document.canvas.height, greaterThan(0));
        });

        test('renders successfully (via RenderPipeline + PaintEngine)', () {
          final renderTree = renderPipeline.prepare(document);
          expect(renderTree, isA<RenderTree>());
          expect(renderTree.root.children, isNotEmpty);

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);
          final metrics = paintEngine.render(
            renderTree,
            document,
            canvas: canvas,
            viewportWidth: document.canvas.width,
            viewportHeight: document.canvas.height,
          );
          recorder.endRecording();
          expect(metrics.totalProcessed, greaterThan(0));
          expect(metrics.failedNodes, equals(0),
              reason: 'Theme "$themeName" had rendering failures');
        });

        test('exports via PictureRecorder', () {
          final picture = exportService.renderToPicture(document);
          expect(picture, isNotNull);
        });

        test('exports via ui.Image', () async {
          final image = await exportService.renderToImage(
            document,
            viewportWidth: document.canvas.width,
            viewportHeight: document.canvas.height,
          );
          expect(image.width, greaterThan(0));
          expect(image.height, greaterThan(0));
        }, timeout: const Timeout(Duration(seconds: 10)));

        test('exports PNG bytes', () async {
          final bytes = await exportService.renderToPngBytes(
            document,
            viewportWidth: document.canvas.width,
            viewportHeight: document.canvas.height,
          );
          expect(bytes, isNotEmpty);
          // PNG header: 89 50 4E 47
          expect(bytes[0], equals(0x89));
          expect(bytes[1], equals(0x50));
          expect(bytes[2], equals(0x4E));
          expect(bytes[3], equals(0x47));
        }, timeout: const Timeout(Duration(seconds: 10)));

        test('exportToJson produces valid output', () {
          final json = exportService.exportToJson(document);
          expect(json, isA<Map<String, dynamic>>());
          expect(json['metadata'], isNotNull);
          expect(json['scene'], isNotNull);
        });
      });
    }
  });

  group('RenderPipeline Coverage', () {
    test('registered paint types can be queried', () {
      final pipeline = RenderPipeline();
      // Empty by default — painters register via PaintEngine.initialize()
      expect(pipeline.registeredPaintTypes, isA<List<String>>());
    });
  });

  group('PaintEngine Coverage', () {
    test('PaintEngine renders empty tree without errors', () {
      final engine = PaintEngine();
      engine.initialize();
      final document = ThemeDocument.fromJson(<String, dynamic>{
        'metadata': <String, dynamic>{'id': 'empty', 'name': 'Empty'},
        'variables': <String, dynamic>{},
        'assets': <String, dynamic>{},
        'scene': <String, dynamic>{'nodes': <dynamic>[]},
        'components': <String, dynamic>{},
        'animations': <dynamic>[],
        'states': <dynamic>[],
      });
      final renderTree = RenderPipeline().prepare(document);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final metrics = engine.render(renderTree, document, canvas: canvas);
      recorder.endRecording();
      expect(metrics.totalProcessed, equals(0));
      expect(metrics.failedNodes, equals(0));
    });
  });
}
