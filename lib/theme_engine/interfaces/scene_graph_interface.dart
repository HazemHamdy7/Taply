import '../models/theme_scene.dart';

/// Interface for the scene graph data structure.
abstract class ISceneGraph {
  /// Builds a scene graph from a [ThemeScene].
  void build(ThemeScene scene);

  /// Returns the root node of the scene graph.
  SceneNode? get root;

  /// Finds a node by its layer [id].
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

/// A node in the scene graph tree.
class SceneNode {
  /// The layer identifier.
  final String id;

  /// The layer type.
  final String type;

  /// Child nodes.
  final List<SceneNode> children;

  /// Creates a [SceneNode].
  const SceneNode({
    required this.id,
    required this.type,
    this.children = const [],
  });
}
