import 'dart:ui';

import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Document extends Node
    implements
        OffsetManagerMixin,
        CardIndexPositionMixin,
        PersistentViewModeMixin,
        LabelManagerMixin {
  final String label;
  final Offset offset;
  final int cardIndex;
  final CorkboardViewMode viewMode;
  Document({
    required super.details,
    this.cardIndex = 0,
    this.label = '',
    Offset? offset,
    CorkboardViewMode? viewMode,
  })  : offset = offset ?? Offset.zero,
        viewMode = viewMode ?? CorkboardViewMode.single;

  @override
  int get nodeCardIndex => cardIndex;

  @override
  Offset get nodeCardOffset => offset;

  @override
  String get nodeLabel => label;

  @override
  CorkboardViewMode get nodeLastMode => viewMode;

  @override
  Document clone() {
    return Document(
      details: details,
    );
  }

  @override
  Document copyWith({NodeDetails? details}) {
    return Document(
      details: details ?? this.details,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  int countAllNodes({required Predicate countNode}) => countNode(this) ? 1 : 0;

  @override
  int countNodes({required Predicate countNode}) => countNode(this) ? 1 : 0;

  @override
  bool deepExist(String id) => this.id == id;

  @override
  bool exist(String id) => this.id == id;

  @override
  Node? visitAllNodes({required Predicate shouldGetNode}) =>
      shouldGetNode(this) ? this : null;

  @override
  Node? visitNode({required Predicate shouldGetNode}) =>
      shouldGetNode(this) ? this : null;

  @override
  bool operator ==(covariant Node other) {
    throw UnimplementedError();
  }

  @override
  int get hashCode => throw UnimplementedError();
}
