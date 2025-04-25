import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/widgets/corkboard/items/node_free_form_index_card.dart';
import 'package:novident_corkboard/src/widgets/corkboard/painter/grid_background_painter.dart';
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
    return FreeFormCardSelectedListener(
      selection: ValueNotifier<Node?>(null),
      child: _FreeFormCorkboard(
        configuration: widget.configuration,
        container: container,
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
  Offset _viewOffset = Offset.zero;
  Offset _startPanOffset = Offset.zero;
  Offset _startFocalPoint = Offset.zero;

  @override
  void initState() {
    super.initState();
  }

  double get maxScale => widget.configuration.maxScale;
  double get minScale => widget.configuration.minScale;

  Offset _screenToWorld(double scale, Offset screenPoint) {
    return Offset(
      (screenPoint.dx / scale) + _viewOffset.dx,
      (screenPoint.dy / scale) + _viewOffset.dy,
    );
  }

  final ValueNotifier<bool> _isViewportEmptyNotifier =
      ValueNotifier<bool>(false);
  List<Node> get children => widget.container.children;

  void _isViewportEmpty(double scale, Size cardSizes, Size viewportSize) {
    if (children.isEmpty) return;
    final Rect worldViewportRect = Rect.fromLTWH(
      _viewOffset.dx,
      _viewOffset.dy,
      viewportSize.width / scale,
      viewportSize.height / scale,
    );

    _isViewportEmptyNotifier.value = !children.any((Node node) {
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size viewportSize =
            Size(constraints.maxWidth, constraints.maxHeight);
        return ValueListenableBuilder<CardCorkboardOptions>(
            valueListenable: widget.configuration.cardCorkboardOptions,
            builder:
                (BuildContext context, CardCorkboardOptions value, Widget? __) {
              final Size cardSize = value.size;
              final double scale = value.ratio;
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ValueListenableBuilder<Node?>(
                        valueListenable:
                            FreeFormCardSelectedListener.of(context).selection,
                        builder:
                            (BuildContext context, Node? value, Widget? _) {
                          return GestureDetector(
                            onScaleStart: (ScaleStartDetails details) {
                              _startPanOffset = _viewOffset;
                              _startFocalPoint = details.localFocalPoint;
                              _isViewportEmpty(scale, cardSize, viewportSize);
                            },
                            behavior: HitTestBehavior.deferToChild,
                            onScaleUpdate: (ScaleUpdateDetails details) {
                              if (value == null) {
                                setState(() {
                                  _isViewportEmpty(
                                      scale, cardSize, viewportSize);
                                  // move canvas
                                  final Offset delta = (_startFocalPoint -
                                      details.localFocalPoint);
                                  _viewOffset = _startPanOffset + delta / scale;

                                  // change the zoom of the current view only on
                                  // mobile devices
                                  if (widget.configuration.allowZoom) {
                                    if (details.scale == scale) return;
                                    if (details.scale >= minScale &&
                                        details.scale <= maxScale) {
                                      final double newScale =
                                          scale * details.scale;
                                      final Offset focalWorldBefore =
                                          _screenToWorld(
                                              scale, details.localFocalPoint);

                                      widget.configuration.cardCorkboardOptions
                                              .value =
                                          widget.configuration
                                              .cardCorkboardOptions.value
                                              .copyWith(
                                        ratio: newScale,
                                      );

                                      final Offset focalWorldAfter =
                                          _screenToWorld(newScale,
                                              details.localFocalPoint);
                                      _viewOffset +=
                                          (focalWorldBefore - focalWorldAfter);
                                    }
                                  }
                                });
                              }
                            },
                            onScaleEnd: (_) {
                              if (value == null) {
                                _isViewportEmpty(scale, cardSize, viewportSize);
                              }
                            },
                            child: Container(
                              color: Colors.purpleAccent.withAlpha(10),
                              constraints: BoxConstraints.loose(viewportSize),
                              child: CustomPaint(
                                size: viewportSize,
                                painter: InfiniteGridBackgroundPainter(
                                  viewOffset: _viewOffset,
                                  scale: scale,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Positioned(
                    left: constraints.maxWidth * 0.70,
                    bottom: 30,
                    child: Row(
                      children: <Widget>[
                        Text('Scale: ${scale.toStringAsFixed(2)}'),
                        const SizedBox(width: 5),
                        Slider(
                          min: widget.configuration.minScale,
                          max: widget.configuration.maxScale,
                          value: value.ratio,
                          onChanged: (double value) {
                            if (scale != value) {
                              setState(
                                () {
                                  widget.configuration.cardCorkboardOptions
                                          .value =
                                      widget.configuration.cardCorkboardOptions
                                          .value
                                          .copyWith(
                                    ratio: value,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // this is the size card slider
                  Positioned(
                    left: constraints.maxWidth * 0.70,
                    bottom: 70,
                    child: Row(
                      children: <Widget>[
                        Text('Size card: ${value.size}'),
                        const SizedBox(width: 5),
                        Slider(
                          min: 40,
                          max: 150,
                          value: value.size.height,
                          allowedInteraction: SliderInteraction.slideOnly,
                          onChanged: (double change) {
                            if (value.size.height != change) {
                              setState(() {
                                widget.configuration.cardCorkboardOptions
                                        .value =
                                    widget.configuration.cardCorkboardOptions
                                        .value
                                        .copyWith(
                                  size: Size(value.size.width, change),
                                );
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: (constraints.maxWidth * 0.50) - 130,
                    bottom: 80,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isViewportEmptyNotifier,
                      builder: (BuildContext context, bool value, Widget? _) {
                        if (value) {
                          return InkWell(
                            onTap: () {
                              _viewOffset =
                                  (children.last as OffsetManagerMixin)
                                      .nodeCardOffset
                                      .value;
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'No hay objetos visibles',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  ..._drawObjects(value, scale),
                ],
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
