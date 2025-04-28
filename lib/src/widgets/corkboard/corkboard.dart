import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/free_form_corkboard_view_mode.dart';
import 'package:novident_corkboard/src/widgets/corkboard/freeform/providers/freeform_viewport_listener.dart';
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
          widget.configuration.initialViewOffset ?? Offset.zero),
      child: FreeFormCardSelectedListener(
        selection: ValueNotifier<Node?>(null),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final Size viewConstraints =
              Size(constraints.maxWidth, constraints.maxHeight);
          return FreeFormCorkboard(
            key: Key('freeform_corkboard'),
            configuration: widget.configuration,
            container: container,
            viewportContraints: viewConstraints,
            constraints: constraints,
          );
        }),
      ),
    );
  }
}
