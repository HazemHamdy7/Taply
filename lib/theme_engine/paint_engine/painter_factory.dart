import 'base_painter.dart';
import 'paint_exception.dart';

typedef PainterConstructor = BasePainter Function();

class PainterFactory {
  final Map<String, PainterConstructor> _constructors = {};
  final Map<String, BasePainter> _instances = {};

  void register(String type, PainterConstructor constructor) {
    if (_constructors.containsKey(type)) {
      throw PaintException('Constructor for painter type "$type" is already registered');
    }
    _constructors[type] = constructor;
  }

  void registerOrReplace(String type, PainterConstructor constructor) {
    _constructors[type] = constructor;
  }

  BasePainter create(String type) {
    final constructor = _constructors[type];
    if (constructor == null) {
      throw PaintException('No constructor registered for painter type "$type"');
    }
    final painter = constructor();
    _instances[type] = painter;
    return painter;
  }

  BasePainter getOrCreate(String type) {
    if (_instances.containsKey(type)) return _instances[type]!;
    return create(type);
  }

  void dispose(String type) {
    final painter = _instances.remove(type);
    painter?.dispose();
  }

  void disposeAll() {
    for (final painter in _instances.values) {
      painter.dispose();
    }
    _instances.clear();
  }

  bool hasConstructor(String type) => _constructors.containsKey(type);

  List<String> get registeredTypes => _constructors.keys.toList();

  void clear() {
    disposeAll();
    _constructors.clear();
  }
}
