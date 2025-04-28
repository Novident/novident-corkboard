import 'package:flutter/widgets.dart';
import 'package:novident_nodes/novident_nodes.dart';

class FreeFormCardSelectedListener extends InheritedWidget {
  final ValueNotifier<Node?> selection;

  const FreeFormCardSelectedListener({
    super.key,
    required super.child,
    required this.selection,
  });

  static FreeFormCardSelectedListener of(BuildContext context,
      {bool listen = false}) {
    if (!context.mounted) {
      throw Exception(
        'An unmounted widget '
        'is not valid to be used to '
        'get an instance of FreeFormCardSelectedListener',
      );
    }
    final FreeFormCardSelectedListener? listener = listen
        ? context
            .dependOnInheritedWidgetOfExactType<FreeFormCardSelectedListener>()
        : context.getInheritedWidgetOfExactType<FreeFormCardSelectedListener>();

    if (listener == null) {
      throw FlutterErrorDetails(
        exception: Exception('MissingCorkboardViewProvider'),
        library: 'novident_corkboard',
        context: ErrorDescription(
          'FreeFormCardSelectedListener was not founded into the widget '
          'tree. Please, ensure that you wrap your '
          'MaterialApp/Widget where NovidentCorkboard is used with '
          'FreeFormCardSelectedListener '
          'to avoid seeing these type of errors.',
        ),
        silent: true,
      );
    }
    return listener;
  }

  static FreeFormCardSelectedListener? maybeOf(
    BuildContext context, {
    bool listen = false,
  }) {
    if (!context.mounted) {
      throw Exception(
        'An unmounted widget '
        'is not valid to be used to '
        'get an instance of FreeFormCardSelectedListener',
      );
    }
    final FreeFormCardSelectedListener? listener = listen
        ? context
            .dependOnInheritedWidgetOfExactType<FreeFormCardSelectedListener>()
        : context.getInheritedWidgetOfExactType<FreeFormCardSelectedListener>();
    return listener;
  }

  @override
  bool updateShouldNotify(covariant FreeFormCardSelectedListener oldWidget) {
    return selection.value != oldWidget.selection.value;
  }
}
