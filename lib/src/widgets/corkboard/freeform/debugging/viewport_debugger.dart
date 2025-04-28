@internal
library;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:novident_corkboard/src/common/structs/viewport_range.dart';

@immutable
class ViewportDebugOverlay extends StatelessWidget {
  final ViewportRange range;

  const ViewportDebugOverlay({
    super.key,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ViewportDebugPainter(range: range),
        ),
      ),
    );
  }
}

@immutable
class _ViewportDebugPainter extends CustomPainter {
  final ViewportRange range;

  const _ViewportDebugPainter({
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.withAlpha(50)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(
        -range.visibleStartX,
        -range.visibleStartY,
        -range.visibleEndX,
        -range.visibleEndY,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ViewportDebugPainter old) => true;
}
