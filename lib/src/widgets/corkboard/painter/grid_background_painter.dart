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
    const double gridStep = 50.0;
    final Paint gridPaint = Paint()
      ..color = Colors.grey[300]!.withAlpha(50)
      ..strokeWidth = 1.0 / scale;

    final double worldLeft = viewOffset.dx;
    final double worldTop = viewOffset.dy;
    final double worldRight = worldLeft + size.width / scale;
    final double worldBottom = worldTop + size.height / scale;

    final double firstVerticalLine = (worldLeft ~/ gridStep) * gridStep;
    for (double x = firstVerticalLine; x <= worldRight; x += gridStep) {
      final double screenX = (x - worldLeft) * scale;
      canvas.drawLine(
        Offset(screenX, 0),
        Offset(screenX, size.height),
        gridPaint,
      );
    }

    final double firstHorizontalLine = (worldTop ~/ gridStep) * gridStep;
    for (double y = firstHorizontalLine; y <= worldBottom; y += gridStep) {
      final double screenY = (y - worldTop) * scale;
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
