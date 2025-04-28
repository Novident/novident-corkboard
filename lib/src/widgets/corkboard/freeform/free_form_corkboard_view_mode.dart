import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/common/structs/viewport_range.dart';
import 'package:novident_corkboard/src/widgets/configuration/viewport_configuration.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/debugging/debug_free_form_panel_widget.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/debugging/viewport_debugger.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/items/node_index_card_widget.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/painter/grid_background_painter.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/providers/freeform_viewport_listener.dart';
import 'package:novident_nodes/novident_nodes.dart';

class FreeFormCorkboard extends StatefulWidget {
  const FreeFormCorkboard({
    super.key,
    required this.configuration,
    required this.container,
    required this.viewportContraints,
    required this.constraints,
  });

  final Size viewportContraints;
  final BoxConstraints constraints;
  final CorkboardConfiguration configuration;
  final NodeContainer container;

  @override
  State<FreeFormCorkboard> createState() => _FreeFormCorkboardState();
}

class _FreeFormCorkboardState extends State<FreeFormCorkboard>
    with CoordinateSystemMixin<FreeFormCorkboard> {
  late final FreeFormCardSelectedListener listener =
      FreeFormCardSelectedListener.of(context);

  late final FreeFormViewportListener viewportListener =
      FreeFormViewportListener.of(context);
  Offset _startPanOffset = Offset.zero;
  Offset __internalViewOffset = Offset.zero;

  late List<Node> _children;

  late Size _viewportSize = widget.viewportContraints;

  double _scale = 0.8;

  bool _isMovingWorld = false;
  ViewportRange? _cachedViewportRange;

  final ValueNotifier<bool> _isViewportEmptyNotifier =
      ValueNotifier<bool>(false);

  ViewportConfiguration get viewportConfiguration =>
      widget.configuration.viewportConfiguration;

  @override
  Offset get viewOffset => _internalViewOffset;

  @override
  Size get viewportContraints => _viewportSize;

  @override
  double get scale => _scale;

  @override
  List<Node> get children => _children;

  double get maxScale => widget.configuration.maxScale;

  double get minScale => widget.configuration.minScale;

  Offset get _internalViewOffset => __internalViewOffset;

  set _internalViewOffset(Offset offset) {
    __internalViewOffset = offset;
    final FreeFormViewportListener viewportListener =
        FreeFormViewportListener.of(context);
    viewportListener.viewOffset.value = offset;
    viewportConfiguration.onChangeViewportOffset?.call(_internalViewOffset);
    _isMovingWorld = true;
  }

  @override
  ViewportRange get viewportRange =>
      _cachedViewportRange ?? _buildViewportRange();

  // this is used to center the content at the right position
  //
  // Why?
  //
  // This is a workaround, since the Offset(0, 0) aims to the borders of the screen
  // we need a way to center correctly the content. How? Well, we use this, to make this.
  // We compute manually the center of the available size, and move the children to
  // that position give the "feeling" that they're putting it's node at the right side
  //
  // |-----------------------------------------|
  // |   __                                    |
  // |  |__| --- Compesation moves             |
  // |           nodes to here when            |
  // |           Offset.zero                   |
  // |                                         |
  // |                                         |
  // |-----------------------------------------|
  Offset get effectiveCompensationOffset {
    if (_lastViewSize != _viewportSize) {
      _cacheCompensation = null;
      _lastViewSize = null;
    } else {
      return _cacheCompensation!;
    }
    _lastViewSize = _viewportSize;
    final Offset offset = widget.configuration.debugMode
        ? Offset(
            _viewportSize.width * 0.1,
            _viewportSize.height * 0.4,
          )
        : Offset(
            _viewportSize.width * 0.1,
            _viewportSize.height * 0.20,
          );
    _cacheCompensation = offset;
    return _cacheCompensation!;
  }

  // these are cache vars for the compensation offset
  //
  // we use them to avoid re-computing the offset
  // when no necessary
  Offset? _cacheCompensation;
  Size? _lastViewSize;

  void _initializeChildren() {
    _sortLastModifyOfNodes();
    final Offset increaseOffsetBy = Offset(25, 25);
    for (int i = 0; i < _children.length; i++) {
      final Node node = _children.elementAt(i);
      final OffsetManagerMixin manager = (node as OffsetManagerMixin);
      final Offset? nodeOffset = manager.nodeCardOffset.value;
      if (nodeOffset == null) {
        final Offset assignedOffset = Offset(0, 0) +
            (i == 0 ? Offset.zero : increaseOffsetBy * i.toDouble());
        manager.nodeCardOffset.value = assignedOffset;
      }
    }
  }

  @override
  void initState() {
    _children = <Node>[...widget.container.children];
    _initializeChildren();

    _internalViewOffset = widget.configuration.initialViewOffset ?? Offset.zero;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FreeFormCorkboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewportContraints != oldWidget.viewportContraints) {
      _viewportSize = widget.viewportContraints;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _scale = scale;
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: GestureDetector(
              onPanStart: (DragStartDetails details) {
                viewportConfiguration.onMovingViewportStart
                    ?.call(_internalViewOffset);
                _startPanOffset = details.globalPosition;
                isViewportEmpty(cardSize,
                    (bool isEmpty) => _isViewportEmptyNotifier.value = isEmpty);
              },
              behavior: HitTestBehavior.deferToChild,
              onPanUpdate: (DragUpdateDetails details) {
                _cachedViewportRange = null;
                isViewportEmpty(cardSize,
                    (bool isEmpty) => _isViewportEmptyNotifier.value = isEmpty);
                // move canvas
                final Offset delta =
                    (_startPanOffset - details.globalPosition) / scale;
                _startPanOffset = details.globalPosition;
                _internalViewOffset = _internalViewOffset + delta;
              },
              onPanEnd: (DragEndDetails _) {
                _isMovingWorld = false;
                viewportConfiguration.onMovingViewportEnd
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
                        constraints: BoxConstraints.loose(_viewportSize),
                        child: CustomPaint(
                          size: _viewportSize,
                          painter: InfiniteGridBackgroundPainter(
                            viewOffset: -_internalViewOffset,
                            scale: scale,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.configuration.debugMode)
                    Positioned(
                      left: (_viewportSize.width / 2) - _internalViewOffset.dx,
                      top: (_viewportSize.height / 2) - _internalViewOffset.dy,
                      child: IgnorePointer(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Positioned(
                              left: -50,
                              bottom: 17,
                              child: Text('Offset(x: 0, y: 0)'),
                            ),
                            Container(
                              width: 13,
                              height: 13,
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ..._drawObjects(value, scale, effectiveCompensationOffset),
                  if (widget.configuration.debugMode)
                    DebugFreeFormCorkboardPanel(
                      constraints: widget.constraints,
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
                  if (widget.configuration.debugMode)
                    Positioned(
                      left: 0,
                      top: 0,
                      width: _viewportSize.width,
                      height: _viewportSize.height,
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
                    ViewportDebugOverlay(
                      range: viewportRange,
                    )
                ],
              ),
            ),
          );
        });
  }

  Iterable<Widget> _drawObjects(
    CardCorkboardOptions options,
    double scale,
    Offset effectiveCompensationOffset,
  ) {
    return children.map<Widget>(
      (Node node) {
        return NodeIndexCardWidget(
          node: node,
          effectiveCompensationOffset: effectiveCompensationOffset,
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

  void _sortLastModifyOfNodes() {
    if (widget.configuration.focusCardOnPress) {
      children.cast<OffsetManagerMixin>().sort(
        (OffsetManagerMixin a, OffsetManagerMixin b) {
          return a.lastCardOffsetModification.value.compareTo(
            b.lastCardOffsetModification.value,
          );
        },
      );
    }
  }

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
}
