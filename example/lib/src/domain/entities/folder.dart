import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Folder extends NodeContainer
    implements
        OffsetManagerMixin,
        CardIndexPositionMixin,
        PersistentViewModeMixin,
        LabelManagerMixin {
  final String name;
  final String synopsis;
  final ValueNotifier<String> _label;
  final ValueNotifier<Offset> _offset;
  final ValueNotifier<int> _cardIndex;
  final ValueNotifier<CorkboardViewMode> _viewMode;
  final ValueNotifier<DateTime> _lastCardOffsetModification;
  Folder({
    required super.details,
    required super.children,
    required this.name,
    required this.synopsis,
    int cardIndex = -1,
    String label = '',
    Offset? offset,
    DateTime? lastCardOffsetModification,
    CorkboardViewMode? viewMode,
  })  : _offset = ValueNotifier<Offset>(offset ?? Offset.zero),
        _viewMode = ValueNotifier<CorkboardViewMode>(
            viewMode ?? CorkboardViewMode.outliner),
        _label = ValueNotifier<String>(label),
        _cardIndex = ValueNotifier<int>(cardIndex),
        _lastCardOffsetModification = ValueNotifier<DateTime>(
          lastCardOffsetModification ?? DateTime.now(),
        ) {
    for (final Node child in children) {
      if (child.owner != this) {
        child.owner = this;
      }
    }
    redepthChildren(checkFirst: true);
  }

  /// adjust the depth level of the children
  void redepthChildren({int? currentLevel, bool checkFirst = false}) {
    void redepth(List<Node> unformattedChildren, int currentLevel) {
      for (int i = 0; i < unformattedChildren.length; i++) {
        final Node node = unformattedChildren.elementAt(i);
        unformattedChildren[i] = node.cloneWithNewLevel(currentLevel + 1);
        if (node is NodeContainer && node.isNotEmpty) {
          redepth(node.children, currentLevel + 1);
        }
      }
    }

    bool ignoreRedepth = false;
    if (checkFirst) {
      for (final Node child in children) {
        if (child.level == childrenLevel) {
          ignoreRedepth = true;
          break;
        }
      }
    }
    if (ignoreRedepth) return;

    redepth(children, currentLevel ?? level);
    notify();
  }

  @override
  set setNewCardIndex(int index) {
    if (index == _cardIndex.value) return;
    _cardIndex.value = index;
    notify();
  }

  @override
  set setNewLabel(String label) {
    if (label == _label.value) return;

    _label.value = label;
    notify();
  }

  @override
  set setNewViewMode(CorkboardViewMode mode) {
    if (mode == _viewMode.value) return;

    _viewMode.value = mode;
    notify();
  }

  @override
  set setCardOffset(Offset offset) {
    _offset.value = offset;
    _lastCardOffsetModification.value = DateTime.now();
    notify();
  }

  @override
  ValueNotifier<int> get nodeCardIndex => _cardIndex;

  @override
  ValueNotifier<Offset?> get nodeCardOffset => _offset;

  @override
  ValueNotifier<String> get nodeLabel => _label;

  @override
  ValueNotifier<CorkboardViewMode> get lastViewMode => _viewMode;

  @override
  ValueNotifier<DateTime> get lastCardOffsetModification =>
      _lastCardOffsetModification;

  @override
  Folder clone() {
    return Folder(
      details: details,
      children: children,
      cardIndex: _cardIndex.value,
      label: _label.value,
      offset: _offset.value,
      synopsis: synopsis,
      name: name,
      lastCardOffsetModification: _lastCardOffsetModification.value,
      viewMode: _viewMode.value,
    );
  }

  @override
  Folder copyWith({
    NodeDetails? details,
    List<Node>? children,
    String? name,
    String? synopsis,
  }) {
    return Folder(
      details: details ?? this.details,
      children: children ?? this.children,
      synopsis: synopsis ?? this.synopsis,
      name: name ?? this.name,
      label: _label.value,
      offset: _offset.value,
      viewMode: _viewMode.value,
      cardIndex: _cardIndex.value,
      lastCardOffsetModification: _lastCardOffsetModification.value,
    );
  }

  @override
  bool get isExpanded => false;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{};
  }

  @override
  Folder cloneWithNewLevel(int level) {
    return copyWith(
      details: details.cloneWithNewLevel(level),
    );
  }

  @override
  bool operator ==(covariant Node other) {
    if (other is! Folder) {
      return false;
    }
    return details == other.details &&
        _offset == other._offset &&
        _label == other._label &&
        _viewMode == other._viewMode &&
        name == other.name &&
        synopsis == other.synopsis &&
        _cardIndex == other._cardIndex;
  }

  @override
  int get hashCode => Object.hashAllUnordered(
        [
          details,
          _offset,
          _label,
          _viewMode,
          name,
          synopsis,
          _cardIndex,
        ],
      );
}
