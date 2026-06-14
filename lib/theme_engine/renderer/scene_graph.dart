import '../interfaces/scene_graph_interface.dart';
import '../models/scene_node.dart';
import '../models/theme_scene.dart';

class SceneGraph implements ISceneGraph {
  SceneNode? _root;

  @override
  void build(ThemeScene scene) {
    if (scene.nodes.length == 1) {
      _root = scene.nodes.first;
    } else if (scene.nodes.isEmpty) {
      _root = null;
    } else {
      _root = GroupNode(
        id: scene.id,
        name: scene.label,
        children: List.from(scene.nodes),
      );
    }
  }

  @override
  SceneNode? get root => _root;

  @override
  SceneNode? findById(String id) {
    if (_root == null) return null;
    return _findById(_root!, id);
  }

  SceneNode? _findById(SceneNode node, String id) {
    if (node.id == id) return node;
    if (node is GroupNode) {
      for (final child in node.children) {
        final found = _findById(child, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  @override
  void insertNode(String parentId, SceneNode node) {
    final parent = findById(parentId);
    if (parent == null) {
      throw ArgumentError('Parent node "$parentId" not found');
    }
    if (parent is! GroupNode) {
      throw ArgumentError('Node "$parentId" is not a group');
    }
    parent.children.add(node);
  }

  @override
  void removeNode(String id) {
    if (_root == null) return;
    if (_root!.id == id) {
      _root = null;
      return;
    }
    _removeFromParent(_root!, id);
  }

  bool _removeFromParent(SceneNode node, String id) {
    if (node is! GroupNode) return false;
    final children = node.children;
    for (var i = 0; i < children.length; i++) {
      if (children[i].id == id) {
        children.removeAt(i);
        return true;
      }
      if (_removeFromParent(children[i], id)) return true;
    }
    return false;
  }

  @override
  void traverse(void Function(SceneNode node) visitor) {
    if (_root == null) return;
    _traverse(_root!, visitor);
  }

  void _traverse(SceneNode node, void Function(SceneNode node) visitor) {
    visitor(node);
    if (node is GroupNode) {
      for (final child in node.children) {
        _traverse(child, visitor);
      }
    }
  }

  @override
  List<SceneNode> flatten() {
    final result = <SceneNode>[];
    if (_root == null) return result;
    _flatten(_root!, result);
    return result;
  }

  void _flatten(SceneNode node, List<SceneNode> result) {
    if (node is GroupNode) {
      for (final child in node.children) {
        _flatten(child, result);
      }
    } else {
      result.add(node);
    }
  }
}
