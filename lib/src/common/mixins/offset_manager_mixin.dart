import 'package:flutter/material.dart';

mixin OffsetManagerMixin {
  ValueNotifier<Offset> get nodeCardOffset;
  ValueNotifier<DateTime> get lastCardOffsetModification;
  set setCardOffset(Offset offset);
}
