import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class NovidentCorkboard extends StatefulWidget {
  final Node node;
  final CorkboardConfiguration configuration;
  final bool Function(Node node, CorkboardViewMode viewMode) filterViewMode;
  final Widget Function(Node node) onSingleView;
  const NovidentCorkboard({
    super.key,
    required this.configuration,
    required this.node,
    required this.onSingleView,
    this.filterViewMode = _defaultFilterViewMode,
  });

  static bool _defaultFilterViewMode(Node node, CorkboardViewMode mode) {
    if (node is! NodeContainer && mode != CorkboardViewMode.single) {
      return false;
    }
    return true;
  }

  @override
  State<NovidentCorkboard> createState() => _NovidentCorkboardState();
}

class _NovidentCorkboardState extends State<NovidentCorkboard> {
  Node get node => widget.node;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: node,
      builder: (BuildContext context, Widget? _) {
        if (node is! OffsetManagerMixin ||
            node is! CardIndexPositionMixin ||
            node is! LabelManagerMixin ||
            node is! PersistentViewModeMixin) {
          throw FlutterErrorDetails(
            exception: Exception(''),
            library: 'novident_corkboard',
            context: ErrorDescription(
                'Node of type ${node.runtimeType} has no implemented some of the '
                'needed mixins: [OffsetManagerMixin, CardIndexPositionMixin, '
                'LabelManagerMixin, PersistentViewModeMixin]'),
          );
        }
        final ValueNotifier<CorkboardViewMode> viewMode =
            (node as PersistentViewModeMixin).lastViewMode;
        return ValueListenableBuilder<CorkboardViewMode>(
          valueListenable: viewMode,
          builder: (BuildContext context, CorkboardViewMode value, _) {
            if (!widget.filterViewMode(node, value)) {
              return widget.configuration.onNoAvailableViewForNode
                      ?.call(node) ??
                  Center(
                    child: Text(
                      '"${node.runtimeType}" has no '
                      'subnodes to be showed',
                    ),
                  );
            }
            if (value.isSingleMode) {
              return widget.onSingleView(node);
            }
            if (value.isOutliner) {}
            return Corkboard(
              configuration: widget.configuration,
              node: node,
            );
          },
        );
      },
    );
  }
}
