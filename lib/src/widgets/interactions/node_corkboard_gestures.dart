import 'package:novident_nodes/novident_nodes.dart';

class NodePressCorkboardGestures {
  final void Function(Node node)? onTapNode;
  final void Function(Node node)? onDoubleTap;
  final void Function(Node node)? onLongPress;

  NodePressCorkboardGestures({
    this.onTapNode,
    this.onDoubleTap,
    this.onLongPress,
  });
}

class NodeDragCorkboardGestures {
  final void Function(
    Node node,
    int to,
    int from, {
    String? label,
  })? onTryRepositionCard;

  NodeDragCorkboardGestures({
    this.onTryRepositionCard,
  });
}
