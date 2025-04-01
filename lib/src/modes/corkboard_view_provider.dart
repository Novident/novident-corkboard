import 'package:flutter/material.dart';
import 'package:novident_corkboard/src/common/enums/modes.dart';
import 'package:novident_corkboard/src/corkboard_controller.dart';

class CorkboardViewProvider extends InheritedWidget {
  final CorkboardViewMode viewMode;
  final CorkboardController controller;
  const CorkboardViewProvider({
    required this.viewMode,
    required this.controller,
    required super.child,
    super.key,
  });

  static CorkboardViewProvider of(BuildContext context, {bool listen = false}) {
    if (!context.mounted) {
      throw Exception(
        'An unmounted widget '
        'is not valid to be used to '
        'get an instance of CorkboardViewProvider',
      );
    }
    final CorkboardViewProvider? mode = !listen
        ? context.getInheritedWidgetOfExactType<CorkboardViewProvider>()
        : context.dependOnInheritedWidgetOfExactType<CorkboardViewProvider>();
    if (mode == null) {
      throw FlutterErrorDetails(
        exception: Exception('MissingCorkboardViewProvider'),
        library: 'novident_corkboard',
        context: ErrorDescription(
          'CorkboardViewProvider was not founded into the widget '
          'tree. Please, ensure that you wrap your '
          'MaterialApp/Widget where NovidentCorkboard is used with '
          'CorkboardViewProvider '
          'to avoid seeing these type of errors.',
        ),
        silent: true,
      );
    }
    return mode;
  }

  @override
  bool updateShouldNotify(covariant CorkboardViewProvider oldWidget) {
    return false;
  }
}
