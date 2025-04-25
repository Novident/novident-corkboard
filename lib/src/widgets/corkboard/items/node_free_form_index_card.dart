import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class NodeFreeFormIndexCard extends StatefulWidget {
  const NodeFreeFormIndexCard({
    super.key,
    required this.node,
    required this.viewOffset,
    required this.scale,
    required this.onMove,
    required this.options,
    required this.configs,
  });

  final CorkboardConfiguration configs;
  final CardCorkboardOptions options;
  final Node node;
  final Offset viewOffset;
  final double scale;
  final void Function() onMove;

  @override
  State<NodeFreeFormIndexCard> createState() => _NodeFreeFormIndexCardState();
}

class _NodeFreeFormIndexCardState extends State<NodeFreeFormIndexCard> {
  Node get node => widget.node;
  CardCorkboardOptions get options => widget.options;
  Size get cardSize => options.size;
  Offset get viewOffset => widget.viewOffset;

  bool isDragging = false;

  void startDragging() {
    if (isDragging) return;
    setState(() {
      isDragging = true;
    });
  }

  void endDragging() {
    if (!isDragging) return;
    widget.onMove();
    setState(() {
      isDragging = false;
    });
  }

  OffsetManagerMixin get _offsetManager => node as OffsetManagerMixin;
  Offset get _currentOffset => _offsetManager.nodeCardOffset.value;

  Offset _dragStartPosition = Offset.zero;

  bool get isDebugModeEnable => widget.configs.debugMode;

  Rect toRect(Offset offset, Size size) {
    final Offset screenPos = Offset(
      (offset.dx - viewOffset.dx) * widget.scale,
      (offset.dy - viewOffset.dy) * widget.scale,
    );

    return Rect.fromCenter(
      center: screenPos,
      width: (isDebugModeEnable ? size.width * 3 : size.width) * widget.scale,
      height: (isDebugModeEnable ? size.height * 3 : size.height) * widget.scale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final FreeFormCardSelectedListener listener =
        FreeFormCardSelectedListener.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([
        _offsetManager.nodeCardOffset,
        listener.selection,
      ]),
      builder: (BuildContext context, Widget? _) {
        final Offset nodeOffset = _offsetManager.nodeCardOffset.value;
        final Node? value = listener.selection.value;
        final Rect rect = toRect(
          nodeOffset,
          cardSize,
        );
        return Positioned.fromRect(
          rect: rect,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              if (isDragging) return;
              if (value?.id != node.id) {
                listener.selection.value = node;
              }
            },
            onPanStart: (DragStartDetails details) {
              if (value?.id != node.id) {
                listener.selection.value = node;
              }
              _dragStartPosition = details.globalPosition;
              startDragging();
            },
            onPanUpdate: (DragUpdateDetails details) {
              if (!isDragging) return;
              if (value == null || value.id != node.id) return;

              final Offset delta =
                  (details.globalPosition - _dragStartPosition) / widget.scale;
              _dragStartPosition = details.globalPosition;

              _offsetManager.setCardOffset = _currentOffset + delta;
            },
            onPanEnd: (DragEndDetails d) => endDragging(),
            onPanDown: (DragDownDetails d) => endDragging(),
            onPanCancel: () => endDragging(),
            child: TextFieldTapRegion(
              onTapOutside: (PointerDownEvent details) {
                if (isDragging) return;
                listener.selection.value = null;
              },
              child: Column(
                children: [
                  Text('X: ${_currentOffset.dx.toStringAsFixed(3)}'),
                  Text('Y: ${_currentOffset.dy.toStringAsFixed(3)}'),
                  Text('Being dragged: ${isDragging ? 'Yes' : 'No'}'),
                  widget.configs.cardWidget(
                    context,
                    node,
                    value?.id == node.id,
                    BoxConstraints.tight(
                      cardSize,
                    ),
                    () {
                      if (value?.id != node.id) {
                        listener.selection.value = node;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
