import 'package:flutter/cupertino.dart';

mixin LabelManagerMixin {
  ValueNotifier<String> get nodeLabel;
  set setNewLabel(String label);
}
