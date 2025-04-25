import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Document extends Node
    implements
        OffsetManagerMixin,
        CardIndexPositionMixin,
        PersistentViewModeMixin,
        LabelManagerMixin {
  final ValueNotifier<String> _label;
  final ValueNotifier<Offset> _offset;
  final ValueNotifier<int> _cardIndex;
  final ValueNotifier<CorkboardViewMode> _viewMode;
  final ValueNotifier<DateTime> _lastCardOffsetModification;
  Document({
    required super.details,
    int cardIndex = -1,
    String label = '',
    Offset? offset,
    DateTime? lastCardOffsetModification,
    CorkboardViewMode? viewMode,
  })  : _offset = ValueNotifier(offset ?? Offset.zero),
        _viewMode = ValueNotifier(viewMode ?? CorkboardViewMode.single),
        _label = ValueNotifier(label),
        _cardIndex = ValueNotifier(cardIndex),
        _lastCardOffsetModification = ValueNotifier(
          lastCardOffsetModification ?? DateTime.now(),
        );

  @override
  set setNewCardIndex(int index) {
    if (index == _cardIndex.value) return;
    _cardIndex.value = index;
  }

  @override
  set setNewLabel(String label) {
    if (label == _label.value) return;

    _label.value = label;
  }

  @override
  set setNewViewMode(CorkboardViewMode mode) {
    if (mode == _viewMode.value) return;

    _viewMode.value = mode;
  }

  @override
  set setCardOffset(Offset offset) {
    _offset.value = offset;
    _lastCardOffsetModification.value = DateTime.now();
  }

  @override
  ValueNotifier<int> get nodeCardIndex => _cardIndex;

  @override
  ValueNotifier<Offset> get nodeCardOffset => _offset;

  @override
  ValueNotifier<String> get nodeLabel => _label;

  @override
  ValueNotifier<CorkboardViewMode> get lastViewMode => _viewMode;

  @override
  ValueNotifier<DateTime> get lastCardOffsetModification =>
      _lastCardOffsetModification;

  @override
  Document clone() {
    return Document(
      details: details,
      cardIndex: _cardIndex.value,
      label: _label.value,
      offset: _offset.value,
      lastCardOffsetModification: _lastCardOffsetModification.value,
      viewMode: _viewMode.value,
    );
  }

  @override
  Node cloneWithNewLevel(int level) {
    return copyWith(
      details: details.cloneWithNewLevel(level),
    );
  }

  @override
  Document copyWith({NodeDetails? details}) {
    return Document(
      details: details ?? this.details,
      label: _label.value,
      offset: _offset.value,
      viewMode: _viewMode.value,
      cardIndex: _cardIndex.value,
      lastCardOffsetModification: _lastCardOffsetModification.value,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _offset.dispose();
    _label.dispose();
    _lastCardOffsetModification.dispose();
    _cardIndex.dispose();
    _viewMode.dispose();
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  bool operator ==(covariant Node other) {
    if (other is! Document) {
      return false;
    }
    return details == other.details &&
        _offset == other._offset &&
        _label == other._label &&
        _viewMode == other._viewMode &&
        _cardIndex == other._cardIndex &&
        _lastCardOffsetModification == other._lastCardOffsetModification;
  }

  @override
  int get hashCode => Object.hashAllUnordered([
        details,
        _offset,
        _label,
        _lastCardOffsetModification,
        _viewMode,
        _cardIndex,
      ]);
}
