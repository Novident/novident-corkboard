import 'package:flutter/material.dart';

class ViewportRange {
  final Offset viewOffset;
  final Size viewportSize;
  final double scale;

  ViewportRange({
    required this.viewOffset,
    required this.viewportSize,
    required this.scale,
  });

  double get visibleStartX => viewOffset.dx;
  double get visibleEndX => visibleStartX + (viewportSize.width / scale);

  double get visibleStartY => viewOffset.dy;
  double get visibleEndY => visibleStartY + (viewportSize.height / scale);

  bool containsPosition(Offset position) {
    return position.dx >= visibleStartX &&
        position.dx <= visibleEndX &&
        position.dy >= visibleStartY &&
        position.dy <= visibleEndY;
  }

  bool overlapsWithArea(Offset center, Size size) {
    final double halfWidth = size.width / scale;
    final double halfHeight = size.height / scale;
    if (halfWidth + center.dx >= visibleStartX &&
        halfWidth - center.dx <= visibleEndX) {
      return true;
    }

    if (halfHeight + center.dy >= visibleStartY &&
        halfHeight - center.dy <= visibleEndY) {
      return true;
    }

    return false;
  }

  // Representación útil para debugging
  @override
  String toString() {
    return 'ViewportRange(X: ${visibleStartX.toStringAsFixed(1)}→${visibleEndX.toStringAsFixed(1)}, '
        'Y: ${visibleStartY.toStringAsFixed(1)}→${visibleEndY.toStringAsFixed(1)})';
  }
}
