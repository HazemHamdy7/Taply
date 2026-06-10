import '../interfaces/scene_graph_interface.dart';
import '../models/theme_scene.dart';

/// Default implementation of [ISceneGraph].
///
/// Builds and manages a tree of [SceneNode] objects from a [ThemeScene].
class SceneGraph implements ISceneGraph {
  SceneNode? _root;

  @override
  void build(ThemeScene scene) {
    throw UnimplementedError('SceneGraph.build');
  }

  @override
  SceneNode? get root => _root;

  @override
  SceneNode? findById(String id) {
    throw UnimplementedError('SceneGraph.findById');
  }

  @override
  void insertNode(String parentId, SceneNode node) {
    throw UnimplementedError('SceneGraph.insertNode');
  }

  @override
  void removeNode(String id) {
    throw UnimplementedError('SceneGraph.removeNode');
  }

  @override
  void traverse(void Function(SceneNode node) visitor) {
    throw UnimplementedError('SceneGraph.traverse');
  }

  @override
  List<SceneNode> flatten() {
    throw UnimplementedError('SceneGraph.flatten');
  }
}
