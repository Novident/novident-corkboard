import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';

class DebugFreeFormCorkboardPanel extends StatefulWidget {
  final CorkboardConfiguration configuration;
  final BoxConstraints constraints;
  final double scale;
  final CardCorkboardOptions value;
  final void Function() tryCheckViewport;
  final bool isMovingWorld;
  final Offset viewOffset;
  final Offset realViewOffset;
  const DebugFreeFormCorkboardPanel({
    super.key,
    required this.constraints,
    required this.scale,
    required this.configuration,
    required this.value,
    required this.tryCheckViewport,
    required this.isMovingWorld,
    required this.viewOffset,
    required this.realViewOffset,
  });

  @override
  State<DebugFreeFormCorkboardPanel> createState() =>
      _DebugFreeFormCorkboardPanelState();
}

class _DebugFreeFormCorkboardPanelState
    extends State<DebugFreeFormCorkboardPanel> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.constraints.maxWidth - 190,
      height: widget.constraints.maxHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 1.2,
              color: Colors.black,
            ),
            left: BorderSide(
              width: 1.2,
              color: Colors.black,
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text('Scale: ${widget.scale.toStringAsFixed(2)}'),
                Slider(
                  min: widget.configuration.minScale,
                  max: widget.configuration.maxScale,
                  value: widget.value.ratio,
                  onChanged: (double value) {
                    if (widget.scale != value) {
                      widget.tryCheckViewport();
                      widget.configuration.cardCorkboardOptions.value = widget
                          .configuration.cardCorkboardOptions.value
                          .copyWith(
                        ratio: value,
                      );
                    }
                  },
                ),
              ],
            ),
            // this is the size card slider
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                      'Size card: ${widget.value.size.height.toStringAsFixed(1)}'),
                ),
                Slider(
                  min: 40,
                  max: 200,
                  divisions: 3,
                  value: widget.value.size.height,
                  allowedInteraction: SliderInteraction.slideOnly,
                  onChanged: (double change) {
                    if (widget.value.size.height != change) {
                      widget.configuration.cardCorkboardOptions.value = widget
                          .configuration.cardCorkboardOptions.value
                          .copyWith(
                        size: Size(widget.value.size.width, change),
                      );
                    }
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Moving world: ${widget.isMovingWorld}'),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Viewport X: ${widget.realViewOffset.dx.toStringAsFixed(1)}'),
                const SizedBox(height: 5),
                Text(
                    'Viewport Y: ${widget.realViewOffset.dy.toStringAsFixed(1)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
