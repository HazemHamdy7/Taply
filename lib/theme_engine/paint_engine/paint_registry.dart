import '../registry/registry_base.dart';
import 'base_painter.dart';

class PaintRegistry extends RegistryBase<BasePainter> {
  static final PaintRegistry instance = PaintRegistry._();

  PaintRegistry._();

  BasePainter? resolve(String type) => get(type);

  bool contains(String type) => has(type);

  void replace(String type, BasePainter painter) {
    registerOrReplace(type, painter);
  }

  List<BasePainter> resolveAll(Iterable<String> types) {
    return types.map((t) => get(t)).whereType<BasePainter>().toList();
  }

  List<String> findUnregistered(Iterable<String> types) {
    return types.where((t) => !has(t)).toList();
  }
}
