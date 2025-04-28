import 'package:flutter/material.dart';

class ViewportConfiguration {
  final void Function(Offset offset)? onChangeViewportOffset;
  final void Function(double scale)? onChangeScaleAspect;

  /// Called when the user start moving the world
  final void Function(Offset viewport)? onMovingViewportStart;

  /// Called when the user end of moving the world
  final void Function(Offset viewport)? onMovingViewportEnd;

  const ViewportConfiguration({
    this.onChangeViewportOffset,
    this.onChangeScaleAspect,
    this.onMovingViewportStart,
    this.onMovingViewportEnd,
  });
}
