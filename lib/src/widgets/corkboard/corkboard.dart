import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
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

class _FreeFormCorkboardState extends State<_FreeFormCorkboard> {
  Offset __viewOffset = Offset.zero;
  Offset get _viewOffset => __viewOffset;

  set _viewOffset(Offset offset) {
    __viewOffset = offset;
    final FreeFormViewportListener viewportListener =
        FreeFormViewportListener.of(context);
    viewportListener.viewOffset.value = offset;
    widget.configuration.onChangeViewportOffset?.call(_viewOffset);
    _isMovingWorld = true;
  }

  Offset _startPanOffset = Offset.zero;
  late List<Node> _children;

  @override
  void initState() {
    _children = <Node>[...widget.container.children.reversed];

    __viewOffset = widget.configuration.initialViewOffset ?? Offset.zero;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.sizeOf(context);
      _viewOffset += Offset(size.width, size.height);
    });
  }

  double get maxScale => widget.configuration.maxScale;
  double get minScale => widget.configuration.minScale;

  final ValueNotifier<bool> _isViewportEmptyNotifier =
      ValueNotifier<bool>(false);
  bool _isMovingWorld = false;

  List<Node> get children => _children;

  /// Checks if we have an object into the viewport
  void _isViewportEmpty(double scale, Size cardSizes, Size viewportSize) {
    if (children.isEmpty ||
        _isViewportEmptyNotifier.value && children.isEmpty) {
      _isViewportEmptyNotifier.value = false;
      return;
    }
    final Rect worldViewportRect = Rect.fromLTWH(
      _viewOffset.dx,
      _viewOffset.dy,
      viewportSize.width / scale,
      viewportSize.height / scale,
    );

    _isViewportEmptyNotifier.value = children.any((Node node) {
      final Rect objectRect = Rect.fromCenter(
        center: (node as OffsetManagerMixin).nodeCardOffset.value,
        width: cardSizes.width,
        height: cardSizes.height,
      );
      return worldViewportRect.overlaps(objectRect);
    });
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
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: GestureDetector(
                  onPanStart: (DragStartDetails details) {
                    widget.configuration.onMovingViewportStart
                        ?.call(_viewOffset);
                    _startPanOffset = details.globalPosition;
                    _isViewportEmpty(scale, cardSize, viewportSize);
                  },
                  behavior: HitTestBehavior.deferToChild,
                  onPanUpdate: (DragUpdateDetails details) {
                    _isViewportEmpty(scale, cardSize, viewportSize);
                    // move canvas
                    final Offset delta =
                        (details.globalPosition - _startPanOffset) / scale;
                    _startPanOffset = details.globalPosition;
                    _viewOffset = _viewOffset + delta;
                  },
                  onPanEnd: (DragEndDetails _) {
                    _isMovingWorld = false;
                    widget.configuration.onMovingViewportEnd?.call(_viewOffset);
                    setState(() {});
                    if (node == null) {
                      _isViewportEmpty(scale, cardSize, viewportSize);
                    }
                  },
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Container(
                          color: Colors.purpleAccent.withAlpha(10),
                          constraints: BoxConstraints.loose(viewportSize),
                          child: CustomPaint(
                            size: viewportSize,
                            painter: InfiniteGridBackgroundPainter(
                              viewOffset: -viewportListener.viewOffset.value,
                              scale: scale,
                            ),
                          ),
                        ),
                      ),
                      ..._drawObjects(value, scale),
                      if (widget.configuration.debugMode)
                        DebugFreeFormCorkboardPanel(
                          constraints: constraints,
                          realViewOffset: _viewOffset,
                          scale: scale,
                          isMovingWorld: _isMovingWorld,
                          viewOffset: viewportListener.viewOffset.value,
                          configuration: widget.configuration,
                          value: value,
                          tryCheckViewport: () {
                            _isViewportEmpty(
                              scale,
                              cardSize,
                              viewportSize,
                            );
                          },
                        ),
                      EmptyViewportWidget(
                        constraints: constraints,
                        isViewportEmptyNotifier: _isViewportEmptyNotifier,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Iterable<Widget> _drawObjects(CardCorkboardOptions options, double scale) {
    return children.map<Widget>(
      (Node node) {
        return NodeFreeFormIndexCard(
          node: node,
          scale: scale,
          viewOffset: _viewOffset,
          onMove: _handleObjectMove,
          options: options,
          configs: widget.configuration,
        );
      },
    );
  }

  void _handleObjectMove() {
    if (widget.configuration.focusCardOnPress) {
      setState(() {
        children.sort(
          (Node a, Node b) => (a as OffsetManagerMixin)
              .lastCardOffsetModification
              .value
              .compareTo(
                (b as OffsetManagerMixin).lastCardOffsetModification.value,
              ),
        );
      });
    }
  }
}
