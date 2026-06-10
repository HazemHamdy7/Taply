import '../models/scene_node.dart';
import '../models/theme_scene.dart';

/// Interface for the scene graph data structure.
abstract class ISceneGraph {
  /// Builds a scene graph from a [ThemeScene].
  void build(ThemeScene scene);

  /// Returns the root node of the scene graph.
  SceneNode? get root;

  /// Finds a node by its [id].
  SceneNode? findById(String id);

  /// Inserts a [node] as a child of the node identified by [parentId].
  void insertNode(String parentId, SceneNode node);

  /// Removes the node identified by [id] and all its children.
  void removeNode(String id);

  /// Traverses the scene graph depth-first, calling [visitor] for each node.
  void traverse(void Function(SceneNode node) visitor);

  /// Returns the flattened list of nodes in draw order.
  List<SceneNode> flatten();
}
