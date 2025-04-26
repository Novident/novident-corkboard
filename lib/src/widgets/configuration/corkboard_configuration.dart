import 'package:flutter/widgets.dart';
import 'package:novident_nodes/novident_nodes.dart';

class CorkboardConfiguration {
  // used normally on FreeForm mode
  final double maxScale;
  final double minScale;
  final double initialScale;
  final Offset? initialViewOffset;
  final bool debugMode;
  final bool allowZoom;
  final bool focusCardOnPress;
  final void Function(Offset offset)? onChangeViewportOffset;
  final void Function(double scale)? onChangeScaleAspect;
  final void Function(Offset viewport)? onMovingViewportStart;
  final void Function(Offset viewport)? onMovingViewportEnd;

  final Widget Function(
    BuildContext context,
    Node node,
    double currentScale,
    bool isSelected,
    bool isDragging,
    BoxConstraints contraints,
    void Function() selectThis,
  ) cardWidget;

  /// For leaf nodes, corkboard or outliner are not available
  final Widget Function(Node node)? onNoAvailableViewForNode;

  final ValueNotifier<CardCorkboardOptions> cardCorkboardOptions;

  CorkboardConfiguration({
    required this.allowZoom,
    required this.cardWidget,
    required this.cardCorkboardOptions,
    this.onMovingViewportEnd,
    this.onMovingViewportStart,
    this.initialViewOffset,
    this.onNoAvailableViewForNode,
    this.debugMode = false,
    this.focusCardOnPress = true,
    this.maxScale = 0.7,
    this.minScale = 0.5,
    this.initialScale = 0.5,
    this.onChangeViewportOffset,
    this.onChangeScaleAspect,
  })  : assert(
            initialScale <= maxScale,
            'initialScale($initialScale) must be less or equals than '
            'the maxScale($maxScale) passed'),
        assert(
            initialScale >= minScale,
            'initialScale($initialScale) must be major or equals than '
            'the minScale($minScale) passed');
}

class CardCorkboardOptions {
  final Size size;
  // 5.3 == 5:3, 5.2 == 5:2
  final double ratio;
  final double spacing;

  /// Only on no free form mode
  /// if not, then will be row mode
  final bool isColumnModeActive;
  final bool isLabelModeActive;

  CardCorkboardOptions({
    required this.size,
    required this.ratio,
    required this.spacing,
    required this.isColumnModeActive,
    required this.isLabelModeActive,
  });

  CardCorkboardOptions.starter()
      : size = Size(250, 200),
        spacing = 100,
        ratio = 0.3,
        isColumnModeActive = false,
        isLabelModeActive = false;

  CardCorkboardOptions copyWith({
    Size? size,
    double? ratio,
    double? spacing,
    bool? isColumnModeActive,
    bool? isLabelModeActive,
  }) {
    return CardCorkboardOptions(
      size: size ?? this.size,
      ratio: ratio ?? this.ratio,
      spacing: spacing ?? this.spacing,
      isColumnModeActive: isColumnModeActive ?? this.isColumnModeActive,
      isLabelModeActive: isLabelModeActive ?? this.isLabelModeActive,
    );
  }

  @override
  bool operator ==(covariant CardCorkboardOptions other) {
    return size == other.size &&
        ratio == other.ratio &&
        spacing == other.spacing &&
        isColumnModeActive == other.isColumnModeActive &&
        isLabelModeActive == other.isLabelModeActive;
  }

  @override
  int get hashCode => Object.hashAllUnordered(<Object?>[
        size,
        ratio,
        spacing,
        isColumnModeActive,
        isLabelModeActive,
      ]);
}
