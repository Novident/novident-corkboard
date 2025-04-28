import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/common/structs/viewport_range.dart';
import 'package:novident_nodes/novident_nodes.dart';

mixin CoordinateSystemMixin<T extends StatefulWidget> on State<T> {
  List<Node> get children;
  Offset get viewOffset;
  ViewportRange get viewportRange;
  Size get viewportContraints;
  double get scale;

  void isViewportEmpty(Size cardSize, void Function(bool) notify) {
    if (children.isEmpty) {
      notify(false);
      return;
    }

    notify(
      children.any(
        (Node node) {
          final Offset nodeOffset =
              (node as OffsetManagerMixin).nodeCardOffset.value!;
          final bool isVisible =
              viewportRange.overlapsWithArea(nodeOffset, cardSize) ||
                  viewportRange.containsPosition(
                    nodeOffset,
                  );
          return isVisible;
        },
      ),
    );
  }

  bool isNodeVisible(Node node) {
    final Offset nodePos = (node as OffsetManagerMixin).nodeCardOffset.value!;
    final bool isVisible = viewportRange.containsPosition(nodePos);
    return isVisible;
  }

  Node? getClosestChild() {
    if (children.isEmpty) return null;

    Node closestNode = children.first;
    double minDistance = double.infinity;
    const double maxDistance = 4500.0;

    final Offset viewportCenter = Offset(
      viewOffset.dx + (viewportContraints.width / 2) / scale,
      viewOffset.dy + (viewportContraints.height / 2) / scale,
    );

    for (final Node node in children) {
      final Offset nodeOffset =
          (node as OffsetManagerMixin).nodeCardOffset.value!;
      final double distance = (nodeOffset - viewportCenter).distance;

      if (distance < minDistance && distance < maxDistance) {
        minDistance = distance;
        closestNode = node;
      }
    }

    return closestNode;
  }

  Offset centerClosestChild() {
    final Node? closestChild = getClosestChild();

    if (closestChild != null) {
      final Offset childWorldPos =
          (closestChild as OffsetManagerMixin).nodeCardOffset.value!;

      return Offset(
        childWorldPos.dx - (viewportContraints.width / 2) / scale,
        childWorldPos.dy - (viewportContraints.height / 2) / scale,
      );
    }
    return Offset.zero;
  }
}
