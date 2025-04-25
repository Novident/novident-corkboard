import 'package:flutter/material.dart';

class DraggableObject {
  final String id;
  Color color;
  ValueNotifier<Offset> _offset;
  Size size;
  DateTime lastModification;

  Offset get offset => _offset.value;
  ValueNotifier<Offset> get offsetNotifier => _offset;
  set offset(Offset offset) {
    _offset.value = offset;
    lastModification = DateTime.now();
  }

  bool isInViewport(Offset viewOffset, {double scale = 0.5}) {
    final screenPos = Offset(
      (offset.dx - viewOffset.dx) * scale,
      (offset.dy - viewOffset.dy) * scale,
    );

    final Rect rect = Rect.fromCenter(
      center: screenPos,
      width: size.width * scale,
      height: size.height * scale,
    );

    return rect.contains(viewOffset);
  }

  Rect toRect(Offset viewOffset, {double scale = 0.5}) {
    final Offset screenPos = Offset(
      (offset.dx - viewOffset.dx) * scale,
      (offset.dy - viewOffset.dy) * scale,
    );

    return Rect.fromCenter(
      center: screenPos,
      width: size.width,
      height: size.height,
    );
  }

  DraggableObject({
    required this.id,
    required this.color,
    required Offset offset,
    DateTime? lastModification,
    this.size = const Size(100, 100),
  })  : _offset = ValueNotifier(offset),
        lastModification = lastModification ?? DateTime.now();
}
