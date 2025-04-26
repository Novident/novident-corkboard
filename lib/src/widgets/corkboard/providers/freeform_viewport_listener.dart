import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@internal
class FreeFormViewportListener extends InheritedWidget {
  final ValueNotifier<Offset> viewOffset;

  const FreeFormViewportListener({
    super.key,
    required this.viewOffset,
    required super.child,
  });

  static FreeFormViewportListener of(BuildContext context,
      {bool listen = false}) {
    if (!context.mounted) {
      throw Exception(
        'An unmounted widget '
        'is not valid to be used to '
        'get an instance of FreeFormViewportListener',
      );
    }
    final FreeFormViewportListener? listener = listen
        ? context.dependOnInheritedWidgetOfExactType<FreeFormViewportListener>()
        : context.getInheritedWidgetOfExactType<FreeFormViewportListener>();

    if (listener == null) {
      throw FlutterErrorDetails(
        exception: Exception('MissingCorkboardViewProvider'),
        library: 'novident_corkboard',
        context: ErrorDescription(
          'FreeFormViewportListener was not founded into the widget '
          'tree. Please, ensure that you wrap your '
          'MaterialApp/Widget where NovidentCorkboard is used with '
          'FreeFormViewportListener '
          'to avoid seeing these type of errors.',
        ),
        silent: true,
      );
    }
    return listener;
  }

  static FreeFormViewportListener? maybeOf(
    BuildContext context, {
    bool listen = false,
  }) {
    if (!context.mounted) {
      throw Exception(
        'An unmounted widget '
        'is not valid to be used to '
        'get an instance of FreeFormViewportListener',
      );
    }
    final FreeFormViewportListener? listener = listen
        ? context.dependOnInheritedWidgetOfExactType<FreeFormViewportListener>()
        : context.getInheritedWidgetOfExactType<FreeFormViewportListener>();
    return listener;
  }

  @override
  bool updateShouldNotify(covariant FreeFormViewportListener oldWidget) {
    return viewOffset.value != oldWidget.viewOffset.value;
  }
}
