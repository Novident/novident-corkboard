import 'package:flutter/material.dart';

class InfiniteGridBackgroundPainter extends CustomPainter {
  final Offset viewOffset;
  final double scale;

  InfiniteGridBackgroundPainter({
    required this.viewOffset,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    const gridStep = 50.0;
    final gridPaint = Paint()
      ..color = Colors.grey[300]!.withAlpha(50)
      ..strokeWidth = 1.0 / scale;

    final worldLeft = viewOffset.dx;
    final worldTop = viewOffset.dy;
    final worldRight = worldLeft + size.width / scale;
    final worldBottom = worldTop + size.height / scale;

    final firstVerticalLine = (worldLeft ~/ gridStep) * gridStep;
    for (double x = firstVerticalLine; x <= worldRight; x += gridStep) {
      final screenX = (x - worldLeft) * scale;
      canvas.drawLine(
        Offset(screenX, 0),
        Offset(screenX, size.height),
        gridPaint,
      );
    }

    final firstHorizontalLine = (worldTop ~/ gridStep) * gridStep;
    for (double y = firstHorizontalLine; y <= worldBottom; y += gridStep) {
      final screenY = (y - worldTop) * scale;
      canvas.drawLine(
        Offset(0, screenY),
        Offset(size.width, screenY),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant InfiniteGridBackgroundPainter oldDelegate) {
    return oldDelegate.viewOffset != viewOffset || oldDelegate.scale != scale;
  }
}
