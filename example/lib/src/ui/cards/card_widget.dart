import 'package:example/src/domain/entities/document.dart';
import 'package:example/src/domain/entities/folder.dart';
import 'package:flutter/material.dart';
import 'package:novident_nodes/novident_nodes.dart';

@immutable
class NodeCardWidget extends StatelessWidget {
  const NodeCardWidget({
    super.key,
    required this.node,
    required this.currentScale,
    required this.isSelected,
    required this.isDragging,
    required this.constraints,
    required this.selectThis,
  });

  final Node node;
  final double currentScale;
  final bool isSelected;
  final bool isDragging;
  final BoxConstraints constraints;
  final void Function() selectThis;

  @override
  Widget build(BuildContext context) {
    final String name =
        node is Document ? (node as Document).name : (node as Folder).name;
    final String synopsis = node is Document
        ? (node as Document).content
        : (node as Folder).synopsis;
    return DecoratedBox(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  width: 2.0,
                  color: Colors.blueAccent,
                ),
              ),
            )
          : BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  color: Colors.black.withAlpha(200),
                  width: 1.0,
                ),
              ),
            ),
      position: DecorationPosition.foreground,
      child: Container(
        constraints: constraints,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(name),
            Divider(),
            const SizedBox(height: 2),
            Text(synopsis),
          ],
        ),
      ),
    );
  }
}
