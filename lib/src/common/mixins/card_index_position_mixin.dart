import 'package:flutter/material.dart';

mixin CardIndexPositionMixin {
  ValueNotifier<int> get nodeCardIndex;
  set setNewCardIndex(int index);
}
