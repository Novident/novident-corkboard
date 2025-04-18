import 'package:flutter/widgets.dart';
import 'package:novident_corkboard/src/widgets/interactions/node_corkboard_gestures.dart';
import 'package:novident_nodes/novident_nodes.dart';

class CorkboardConfiguration {
  final NodePressCorkboardGestures Function(Node node) pressGestures;
  final NodeDragCorkboardGestures Function(Node node) dragGestures;
  /// When a node is empty or, a selected node, is a non NodeContainer
  /// we call this to avoid show subnodes where there's nothing
  final Widget Function(Node node)? onEmptyOrNonContainerNode;
  final Widget Function(Node node) cardWidget;

  CorkboardConfiguration({
    required this.pressGestures,
    required this.dragGestures,
    required this.cardWidget,
    this.onEmptyOrNonContainerNode,
  });
}
