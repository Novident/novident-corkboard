import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class NodeIndexCardWidget extends StatefulWidget {
  const NodeIndexCardWidget({
    super.key,
    required this.node,
    required this.viewOffset,
    required this.effectiveCompensationOffset,
    required this.scale,
    required this.options,
    required this.configs,
    this.onMove,
    this.onTap,
  });

  final CorkboardConfiguration configs;
  final CardCorkboardOptions options;
  final Node node;
  final Offset viewOffset;
  final Offset effectiveCompensationOffset;
  final double scale;
  final void Function()? onTap;
  final void Function()? onMove;

  @override
  State<NodeIndexCardWidget> createState() => _NodeFreeFormIndexCardState();
}

class _NodeFreeFormIndexCardState extends State<NodeIndexCardWidget> {
  late final FreeFormCardSelectedListener listener =
      FreeFormCardSelectedListener.of(context);

  Offset _startPanOffset = Offset.zero;

  bool isDragging = false;

  OffsetManagerMixin get _offsetManager => node as OffsetManagerMixin;

  CardCorkboardOptions get options => widget.options;

  Node get node => widget.node;

  Size get cardSize => options.size;

  Offset get viewOffset => widget.viewOffset;

  Offset get _currentOffset =>
      _offsetManager.nodeCardOffset.value ?? Offset.zero;

  bool get isDebugModeEnable => widget.configs.debugMode;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable?>[
        _offsetManager.nodeCardOffset,
        listener.selection,
      ]),
      builder: (BuildContext context, Widget? _) {
        final Offset nodeOffset =
            _offsetManager.nodeCardOffset.value ?? Offset.zero;
        final Node? value = listener.selection.value;
        final Rect rect = toRect(
          nodeOffset,
          cardSize,
        );

        final Widget child = widget.configs.cardWidget(
          context,
          node,
          widget.scale,
          value?.id == node.id,
          isDragging,
          BoxConstraints.tight(
            cardSize,
          ),
          () {
            if (value?.id != node.id) {
              listener.selection.value = node;
            }
          },
        );
        return Positioned.fromRect(
          rect: rect,
          child: Transform.scale(
            scale: widget.scale,
            child: RepaintBoundary(
              child: GestureDetector(
                onTap: () {
                  if (isDragging) return;
                  if (value?.id != node.id) {
                    listener.selection.value = node;
                  }
                  widget.onTap?.call();
                },
                onPanStart: (DragStartDetails details) {
                  if (value?.id != node.id) {
                    listener.selection.value = node;
                  }
                  _startPanOffset = details.globalPosition;
                  startDragging();
                },
                onPanUpdate: (DragUpdateDetails details) {
                  if (!isDragging) return;
                  if (value == null || value.id != node.id) return;

                  final Offset delta =
                      (details.globalPosition - _startPanOffset) / widget.scale;

                  _startPanOffset = details.globalPosition;

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
                  child: !isDebugModeEnable
                      ? child
                      : Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            child,
                            Positioned(
                              left: 0,
                              bottom: 220,
                              child: _buildDebugOverlay(value),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDebugOverlay(Node? selection) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.black.withAlpha(170),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('_Id: ${node.id.substring(0, 6)}',
              style: TextStyle(color: Colors.white)),
          Text('Selected: ${selection?.id == node.id ? 'Yes' : 'No'}',
              style: TextStyle(color: Colors.white)),
          Text('X: ${_currentOffset.dx.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white)),
          Text('Y: ${_currentOffset.dy.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white)),
          Text('Size: ${cardSize.width.toInt()}x${cardSize.height.toInt()}',
              style: TextStyle(color: Colors.white)),
          Text(
              'Actual size: ${(cardSize.width * widget.scale).toStringAsFixed(1)}x${(cardSize.height * widget.scale).toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white)),
          Text('State: ${isDragging ? 'Dragging' : 'Sleeping'}',
              style: TextStyle(
                color: isDragging ? Colors.amber : Colors.green,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  void startDragging() {
    if (isDragging) return;
    setState(() {
      isDragging = true;
    });
  }

  void endDragging() {
    if (!isDragging) return;
    _startPanOffset = Offset.zero;
    widget.onMove?.call();
    setState(() {
      isDragging = false;
    });
  }

  Rect toRect(Offset offset, Size size) {
    final Offset screenPos = Offset(
      (offset.dx + viewOffset.dx) * widget.scale,
      (offset.dy + viewOffset.dy) * widget.scale,
    );

    return Rect.fromCenter(
      center: screenPos + widget.effectiveCompensationOffset,
      width: size.width,
      height: size.height,
    );
  }
}
