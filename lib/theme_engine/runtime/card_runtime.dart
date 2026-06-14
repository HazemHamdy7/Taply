import 'dart:typed_data';
import 'dart:ui' as ui;

import '../export/export_service.dart';
import '../models/theme_document.dart';
import '../paint_engine/paint_engine.dart';
import '../parser/theme_parser.dart';
import '../renderer/render_node.dart';
import '../renderer/render_pipeline.dart';
import '../renderer/render_tree.dart';
import 'avatar/avatar_runtime.dart';
import 'field/data_provider.dart';
import 'field/expression_resolver.dart';
import 'field/field_binding.dart';
import 'field/field_resolver.dart';
import 'qr/qr_runtime.dart';
import 'runtime_cache.dart';
import 'runtime_context.dart';
import 'runtime_exception.dart';
import 'widget/widget_runtime.dart';

class CardRuntimeResult {
  final RenderTree renderTree;
  final ui.Picture picture;
  final PaintMetrics metrics;
  final RuntimeContext context;
  final Duration resolveTime;
  final Duration renderTime;
  final Duration totalTime;
  final int boundNodes;

  const CardRuntimeResult({
    required this.renderTree,
    required this.picture,
    required this.metrics,
    required this.context,
    required this.resolveTime,
    required this.renderTime,
    required this.totalTime,
    required this.boundNodes,
  });
}

class CardRuntime {
  final DataProvider dataProvider;
  final FieldBinding fieldBinding;
  final FieldResolver fieldResolver;
  final ExpressionResolver expressionResolver;
  final QRRuntime qrRuntime;
  final AvatarRuntime avatarRuntime;
  final WidgetRuntime widgetRuntime;
  final RenderPipeline renderPipeline;
  final PaintEngine paintEngine;
  final ExportService exportService;
  final RuntimeCache cache;

  ThemeDocument? _document;

  CardRuntime({
    DataProvider? dataProvider,
    FieldBinding? fieldBinding,
    FieldResolver? fieldResolver,
    ExpressionResolver? expressionResolver,
    QRRuntime? qrRuntime,
    AvatarRuntime? avatarRuntime,
    WidgetRuntime? widgetRuntime,
    RenderPipeline? renderPipeline,
    PaintEngine? paintEngine,
    ExportService? exportService,
    RuntimeCache? cache,
  })  : dataProvider = dataProvider ?? DataProvider(),
        fieldBinding = fieldBinding ?? FieldBinding(),
        fieldResolver = fieldResolver ?? FieldResolver(),
        expressionResolver = expressionResolver ?? ExpressionResolver(),
        qrRuntime = qrRuntime ?? QRRuntime(),
        avatarRuntime = avatarRuntime ?? AvatarRuntime(),
        widgetRuntime = widgetRuntime ?? WidgetRuntime(),
        renderPipeline = renderPipeline ?? RenderPipeline(),
        paintEngine = paintEngine ?? PaintEngine(),
        exportService = exportService ?? ExportService(),
        cache = cache ?? RuntimeCache();

  void setCardData(BusinessCardData data) {
    dataProvider.setData(data);
  }

  void setDocument(ThemeDocument document) {
    _document = document;
  }

  void loadThemeFromJson(Map<String, dynamic> json) {
    final parser = ThemeParser();
    _document = parser.parse(json);
  }

  void loadThemeFromString(String jsonString) {
    final parser = ThemeParser();
    _document = parser.parseString(jsonString);
  }

  bool get hasData => dataProvider.isInitialized;
  bool get hasDocument => _document != null;

  RenderTree resolveFields({BusinessCardData? data}) {
    final cardData = data ?? dataProvider.data;
    if (_document == null) {
      throw const RuntimeException('No theme document loaded', code: 'NO_DOCUMENT');
    }

    final renderTree = renderPipeline.prepare(_document!);
    return _resolveTree(renderTree, cardData);
  }

  CardRuntimeResult render({
    BusinessCardData? data,
    double viewportWidth = 1000,
    double viewportHeight = 600,
    RuntimeMode mode = RuntimeMode.render,
  }) {
    final totalSw = Stopwatch()..start();
    final cardData = data ?? dataProvider.data;

    if (_document == null) {
      throw const RuntimeException('No theme document loaded', code: 'NO_DOCUMENT');
    }

    final resolveSw = Stopwatch()..start();
    final renderTree = renderPipeline.prepare(
      _document!,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    final resolvedTree = _resolveTree(renderTree, cardData);
    resolveSw.stop();

    final context = RuntimeContext(
      document: _document!,
      mode: mode,
      cache: cache,
    );

    final renderSw = Stopwatch()..start();
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final metrics = paintEngine.render(
      resolvedTree,
      _document!,
      canvas: canvas,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    final picture = recorder.endRecording();
    renderSw.stop();

    totalSw.stop();

    final boundCount = resolvedTree.flatten().length;

    return CardRuntimeResult(
      renderTree: resolvedTree,
      picture: picture,
      metrics: metrics,
      context: context,
      resolveTime: resolveSw.elapsed,
      renderTime: renderSw.elapsed,
      totalTime: totalSw.elapsed,
      boundNodes: boundCount,
    );
  }

  Future<ui.Image> renderToImage({
    BusinessCardData? data,
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double pixelRatio = 3.0,
  }) async {
    final result = render(
      data: data,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    return result.picture.toImage(
      (viewportWidth * pixelRatio).toInt(),
      (viewportHeight * pixelRatio).toInt(),
    );
  }

  Future<Uint8List> renderToPngBytes({
    BusinessCardData? data,
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double pixelRatio = 3.0,
  }) async {
    final image = await renderToImage(
      data: data,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      pixelRatio: pixelRatio,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  RenderTree _resolveTree(RenderTree renderTree, BusinessCardData data) {
    final boundChildren = renderTree.root.children.map(
      (node) => fieldBinding.bind(node, data),
    ).toList();

    return RenderTree(
      canvasWidth: renderTree.canvasWidth,
      canvasHeight: renderTree.canvasHeight,
      viewportWidth: renderTree.viewportWidth,
      viewportHeight: renderTree.viewportHeight,
      layoutMode: renderTree.layoutMode,
      scaleFactor: renderTree.scaleFactor,
      root: RenderGroup(
        id: renderTree.root.id,
        name: renderTree.root.name,
        children: boundChildren,
      ),
    );
  }
}
