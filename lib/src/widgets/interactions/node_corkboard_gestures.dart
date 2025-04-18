import 'package:flutter/widgets.dart';
import 'package:novident_nodes/novident_nodes.dart';

class NodePressCorkboardGestures {
  final void Function(Node node) onTapNode;
  final void Function(Node node) onDoubleTap;
  final void Function(Node node) onLongPress;

  NodePressCorkboardGestures({
    required this.onTapNode,
    required this.onDoubleTap,
    required this.onLongPress,
  });
}

class NodeDragCorkboardGestures {
  final void Function(Node node, int to, int from, {String? label}) onTryRepositionCard;
  // common drag gestures
  final void Function(Node node, PointerUpEvent event) onPointerUp;
  final void Function(Node node, PointerDownEvent event) onPointerDown;
  final void Function(Node node, PointerMoveEvent event) onPointerMove;
  final void Function(Node node, PointerCancelEvent event) onPointerCancel;

  NodeDragCorkboardGestures({
    required this.onPointerUp,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerCancel,
    required this.onTryRepositionCard,
  });
}
