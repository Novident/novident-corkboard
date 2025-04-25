import 'package:flutter/material.dart';
import 'package:novident_corkboard/src/common/enums/modes.dart';

/// Used commonly in nodes implementation to persist the last mode
/// selected when that node was selected
mixin PersistentViewModeMixin {
  ValueNotifier<CorkboardViewMode> get lastViewMode;
  set setNewViewMode(CorkboardViewMode mode);
}
