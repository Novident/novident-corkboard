import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/widgets/configuration/corkboard_configuration.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Corkboard extends StatefulWidget {
  final CorkboardConfiguration configuration;
  const Corkboard({
    super.key,
    required this.configuration,
  });

  @override
  State<Corkboard> createState() => _CorkboardState();
}

class _CorkboardState extends State<Corkboard>
    with AutomaticKeepAliveClientMixin<Corkboard> {
  late CorkboardViewProvider provider;
  Offset? _cursorPointer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = CorkboardViewProvider.of(context);
    });
  }

  @override
  bool get wantKeepAlive => isDragging;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<Node>(
      valueListenable: provider.controller.node,
      builder: (BuildContext context, Node node, Widget? _) {
        if (node is! OffsetManagerMixin ||
            node is! CardIndexPositionMixin ||
            node is! LabelManagerMixin ||
            node is! PersistentViewModeMixin) {
          throw FlutterErrorDetails(
            exception: Exception(
              'Node of type ${node.runtimeType} has no implemented some of the '
              'needed mixins: [OffsetManagerMixin, CardIndexPositionMixin, '
              'LabelManagerMixin, PersistentViewModeMixin]',
            ),
            library: 'novident_corkboard',
            context: ErrorDescription(''),
          );
        }
        if (node is! NodeContainer) {
          return widget.configuration.onEmptyOrNonContainerNode?.call(node) ??
              Center(
                child: Text(
                  '"${node.runtimeType}" has no '
                  'subnodes to be showed',
                ),
              );
        }
        //TODO: this is just a workaround for desktop
        // we need to listen the gestures from touch
        return Listener(
          onPointerHover: (PointerHoverEvent event) {
            _cursorPointer = event.position;
          },
          onPointerMove: (PointerMoveEvent event) {
            _cursorPointer = event.position;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[],
              ),
            ),
          ),
        );
      },
    );
  }

  bool get isDragging => _isDragging;
  bool _isDragging = false;

  set isDragging(bool value) {
    if (value == _isDragging) return;

    if (context.mounted && mounted) {
      setState(() {
        _isDragging = value;
        updateKeepAlive();
      });
    } else {
      _isDragging = value;
    }
  }
}
