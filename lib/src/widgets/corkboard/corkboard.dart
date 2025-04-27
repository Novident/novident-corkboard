import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/common/structs/viewport_range.dart';
import 'package:novident_corkboard/src/widgets/corkboard/debug/debug_free_form_panel_widget.dart';
import 'package:novident_corkboard/src/widgets/corkboard/items/empty_viewport_widget_alert.dart';
import 'package:novident_corkboard/src/widgets/corkboard/items/node_free_form_index_card.dart';
import 'package:novident_corkboard/src/widgets/corkboard/painter/grid_background_painter.dart';
import 'package:novident_corkboard/src/widgets/corkboard/providers/freeform_viewport_listener.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Corkboard extends StatefulWidget {
  final CorkboardConfiguration configuration;
  final Node node;
  const Corkboard({
    super.key,
    required this.configuration,
    required this.node,
  });

  @override
  State<Corkboard> createState() => _CorkboardState();
}

class _CorkboardState extends State<Corkboard> {
  NodeContainer get container => widget.node as NodeContainer;

  @override
  void initState() {
    if (widget.configuration.initialScale != null) {
      widget.configuration.cardCorkboardOptions.value =
          widget.configuration.cardCorkboardOptions.value.copyWith(
        ratio: widget.configuration.initialScale,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FreeFormViewportListener(
      viewOffset: ValueNotifier<Offset>(
        widget.configuration.initialViewOffset ?? Offset.zero,
      ),
      child: FreeFormCardSelectedListener(
        selection: ValueNotifier<Node?>(null),
        child: _FreeFormCorkboard(
          configuration: widget.configuration,
          container: container,
        ),
      ),
    );
  }
}

class _FreeFormCorkboard extends StatefulWidget {
  const _FreeFormCorkboard({
    required this.configuration,
    required this.container,
  });

  final CorkboardConfiguration configuration;
  final NodeContainer container;

  @override
  State<_FreeFormCorkboard> createState() => _FreeFormCorkboardState();
}

class _FreeFormCorkboardState extends State<_FreeFormCorkboard>
    with CoordinateSystemMixin<_FreeFormCorkboard> {
  Offset _startPanOffset = Offset.zero;
  late List<Node> _children;

  Size _viewportSize = Size(0, 0);
  double _scale = 0.8;
  Offset __internalViewOffset = Offset.zero;

  Offset get _internalViewOffset => __internalViewOffset;

  set _internalViewOffset(Offset offset) {
    __internalViewOffset = offset;
    final FreeFormViewportListener viewportListener =
        FreeFormViewportListener.of(context);
    viewportListener.viewOffset.value = offset;
    widget.configuration.onChangeViewportOffset?.call(_internalViewOffset);
    _isMovingWorld = true;
  }

  @override
  Offset get viewOffset => _internalViewOffset;

  @override
  Size get viewportContraints => _viewportSize;

  @override
  double get scale => _scale;

  @override
  List<Node> get children => _children;

  @override
  void initState() {
    _children = <Node>[...widget.container.children];
    _handleObjectMove();

    _internalViewOffset =
        widget.configuration.initialViewOffset ?? centerClosestChild();
    super.initState();
  }

  double get maxScale => widget.configuration.maxScale;
  double get minScale => widget.configuration.minScale;

  @override
  ViewportRange get viewportRange =>
      _cachedViewportRange ?? _buildViewportRange();

  final ValueNotifier<bool> _isViewportEmptyNotifier =
      ValueNotifier<bool>(false);
  bool _isMovingWorld = false;

  ViewportRange? _cachedViewportRange;

  ViewportRange _buildViewportRange({bool cache = true}) {
    if (_cachedViewportRange != null && cache) {
      if (_cachedViewportRange!.viewportSize == _viewportSize &&
          _cachedViewportRange!.viewOffset == _internalViewOffset) {
        return _cachedViewportRange!;
      }
      _cachedViewportRange = null;
    }

    final ViewportRange viewport = ViewportRange(
      viewOffset: _internalViewOffset,
      viewportSize: _viewportSize,
      scale: _scale,
    );

    if (cache) {
      return _cachedViewportRange ??= viewport;
    }
    return viewport;
  }

  @override
  Widget build(BuildContext context) {
    final FreeFormCardSelectedListener listener =
        FreeFormCardSelectedListener.of(context);
    final FreeFormViewportListener viewportListener =
        FreeFormViewportListener.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size viewportSize =
            Size(constraints.maxWidth, constraints.maxHeight);
        return ListenableBuilder(
            listenable: Listenable.merge(
              <Listenable?>[
                viewportListener.viewOffset,
                widget.configuration.cardCorkboardOptions,
                listener.selection,
              ],
            ),
            builder: (BuildContext context, Widget? __) {
              final CardCorkboardOptions value =
                  widget.configuration.cardCorkboardOptions.value;
              final Node? node = listener.selection.value;
              final Size cardSize = value.size;
              final double scale = value.ratio;
              _viewportSize = viewportSize;
              _scale = scale;
              // this is used to center the content at the right position
              //
              // Why?
              //
              // This is a workaround, since the Offset(0, 0) aims to the borders of the screen
              // we need a way to center correctly the content. How? Well, we use this, to make this.
              // We compute manually the center of the available size, and move the children to
              // that position give the "feeling" that they're putting it's node at the right side
              final Offset screenCenterOffset = Offset(
                viewportSize.width / 2,
                viewportSize.height / 2,
              );
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    widget.configuration.onMovingViewportStart
                        ?.call(_internalViewOffset);
                    _startPanOffset = details.globalPosition;
                    isViewportEmpty(
                        cardSize,
                        (bool isEmpty) =>
                            _isViewportEmptyNotifier.value = isEmpty);
                  },
                  behavior: HitTestBehavior.deferToChild,
                  onPanUpdate: (DragUpdateDetails details) {
                    _cachedViewportRange = null;
                    isViewportEmpty(
                        cardSize,
                        (bool isEmpty) =>
                            _isViewportEmptyNotifier.value = isEmpty);
                    // move canvas
                    final Offset delta =
                        (_startPanOffset - details.globalPosition) / scale;
                    _startPanOffset = details.globalPosition;
                    _internalViewOffset = _internalViewOffset + delta;
                  },
                  onPanEnd: (DragEndDetails _) {
                    _isMovingWorld = false;
                    widget.configuration.onMovingViewportEnd
                        ?.call(_internalViewOffset);
                    setState(() {});
                    if (node == null) {
                      isViewportEmpty(
                          cardSize,
                          (bool isEmpty) =>
                              _isViewportEmptyNotifier.value = isEmpty);
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: <Widget>[
                      RepaintBoundary(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Container(
                            color: Colors.purpleAccent.withAlpha(10),
                            constraints: BoxConstraints.loose(viewportSize),
                            child: CustomPaint(
                              size: viewportSize,
                              painter: InfiniteGridBackgroundPainter(
                                viewOffset: -_internalViewOffset,
                                scale: scale,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ..._drawObjects(value, scale, screenCenterOffset),
                      if (widget.configuration.debugMode)
                        DebugFreeFormCorkboardPanel(
                          constraints: constraints,
                          realViewOffset: _internalViewOffset,
                          scale: scale,
                          isMovingWorld: _isMovingWorld,
                          viewOffset: viewportListener.viewOffset.value,
                          configuration: widget.configuration,
                          value: value,
                          tryCheckViewport: () {
                            isViewportEmpty(
                              cardSize,
                              (bool isEmpty) =>
                                  _isViewportEmptyNotifier.value = isEmpty,
                            );
                          },
                        ),
                      EmptyViewportWidget(
                        constraints: constraints,
                        isViewportEmptyNotifier: _isViewportEmptyNotifier,
                      ),
                      if (widget.configuration.debugMode)
                        Positioned(
                          left: 0,
                          top: 0,
                          width: viewportSize.width,
                          height: viewportSize.height,
                          child: RepaintBoundary(
                            child: IgnorePointer(
                              child: Container(
                                clipBehavior: Clip.none,
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.configuration.debugMode)
                        Positioned(
                          left: (constraints.maxWidth / 2),
                          top: (constraints.maxHeight / 2),
                          width: 10,
                          height: 10,
                          child: RepaintBoundary(
                            child: IgnorePointer(
                              child: Container(
                                clipBehavior: Clip.none,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (widget.configuration.debugMode)
                        ViewportDebugOverlay(
                          range: viewportRange,
                        )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Iterable<Widget> _drawObjects(
    CardCorkboardOptions options,
    double scale,
    Offset screenCenterOffset,
  ) {
    return children.map<Widget>(
      (Node node) {
        return NodeFreeFormIndexCard(
          node: node,
          centerOffset: screenCenterOffset,
          scale: scale,
          viewOffset: -_internalViewOffset,
          onTap: () {
            if (!widget.configuration.focusCardOnPress) return;
            if (_children[_children.length - 1].id == node.id) return;
            final int index = _children.indexWhere((Node e) => e.id == node.id);
            if (index != -1 && index != _children.length - 1) {
              setState(() {
                _children
                  ..removeAt(index)
                  ..insert(_children.length, node);
              });
            }
          },
          onMove: () {
            if (!widget.configuration.focusCardOnPress) return;
            if (_children[_children.length - 1].id == node.id) return;
            final int index = _children.indexWhere((Node e) => e.id == node.id);
            if (index != -1 && index != _children.length - 1) {
              setState(() {
                _children
                  ..removeAt(index)
                  ..insert(_children.length, node);
              });
            }
          },
          options: options,
          configs: widget.configuration,
        );
      },
    );
  }

  void _handleObjectMove() {
    if (widget.configuration.focusCardOnPress) {
      children.sort(
        (Node a, Node b) => (a as OffsetManagerMixin)
            .lastCardOffsetModification
            .value
            .compareTo(
              (b as OffsetManagerMixin).lastCardOffsetModification.value,
            ),
      );
    }
  }
}

// Widget para visualizar el rango visible
class ViewportDebugOverlay extends StatelessWidget {
  final ViewportRange range;

  const ViewportDebugOverlay({super.key, required this.range});

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

class _ViewportDebugPainter extends CustomPainter {
  final ViewportRange range;

  _ViewportDebugPainter({required this.range});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(
        range.visibleStartX,
        range.visibleStartY,
        range.visibleEndX,
        range.visibleEndY,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ViewportDebugPainter old) => true;
}
