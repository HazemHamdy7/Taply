import '../../models/scene_node.dart';

void walkSceneNodes(
  List<SceneNode> nodes,
  String parentPath,
  void Function(SceneNode node, String path) visitor,
) {
  for (int i = 0; i < nodes.length; i++) {
    final nodePath = '$parentPath[$i]';
    visitor(nodes[i], nodePath);
    nodes[i].maybeWhen(
      group: (id, name, visible, opacity, children, properties) {
        if (children.isNotEmpty) {
          walkSceneNodes(children, '$nodePath.children', visitor);
        }
      },
      orElse: () {},
    );
  }
}
