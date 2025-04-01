import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:novident_corkboard/src/common/corkboard_options.dart';
import 'package:novident_nodes/novident_nodes.dart';

class CorkboardController extends ChangeNotifier {
  final ValueNotifier<List<Node>> selectedNodes;
  final ValueNotifier<bool> freeform;
  final ValueNotifier<Map<String, dynamic>> labels;
  CorkboardOptions _options;

  CorkboardController({
    required List<Node> selectedNodes,
    required Map<String, dynamic> labels,
    required CorkboardOptions options,
    required bool freeform,
  })  : selectedNodes = ValueNotifier<List<Node>>(
          <Node>[...selectedNodes],
        ),
        labels = ValueNotifier<Map<String, dynamic>>(
          <String, dynamic>{...labels},
        ),
        _options = options,
        freeform = ValueNotifier<bool>(
          freeform,
        );

  CorkboardOptions get options => _options;

  set options(CorkboardOptions options) {
    if (options == _options) return;
    _options = options;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    selectedNodes.dispose();
    freeform.dispose();
  }
}
