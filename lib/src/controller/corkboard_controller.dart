import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:novident_corkboard/src/common/corkboard_options.dart';
import 'package:novident_nodes/novident_nodes.dart';

@experimental
class CorkboardController extends ChangeNotifier {
  /// This is the node that is being focused
  final ValueNotifier<Node> node;
  /// these are the selected nodes into the view of Corkboard mode
  /// used only when card mode is being selected
  final ValueNotifier<List<Node>> selectedNodes;
  final ValueNotifier<Map<String, dynamic>> labels;
  CorkboardOptions _options;

  CorkboardController({
    required this.node,
    required List<Node> selectedNodes,
    required Map<String, dynamic> labels,
    required CorkboardOptions options,
  })  : selectedNodes = ValueNotifier<List<Node>>(
          <Node>[...selectedNodes],
        ),
        labels = ValueNotifier<Map<String, dynamic>>(
          <String, dynamic>{...labels},
        ),
        _options = options;

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
    labels.dispose();
    node.dispose();
  }
}
