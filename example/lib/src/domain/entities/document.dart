import 'dart:ui';

import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Document extends Node
    implements OffsetManagerMixin, CardIndexPositionMixin {
  Document({
    required super.details,
  });

  @override
  set cardIndex(int index) {}

  @override
  set cardOffset(Offset offset) {}

  @override
  int get cardIndex => 1;

  @override
  Offset get cardOffset => Offset.zero;

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
  bool operator ==(covariant Node other) {
    throw UnimplementedError();
  }

  @override
  int get hashCode => throw UnimplementedError();

  @override
  int countAllNodes({required Predicate countNode}) {
    // TODO: implement countAllNodes
    throw UnimplementedError();
  }

  @override
  int countNodes({required Predicate countNode}) {
    // TODO: implement countNodes
    throw UnimplementedError();
  }

  @override
  bool deepExist(String id) {
    // TODO: implement deepExist
    throw UnimplementedError();
  }

  @override
  bool exist(String id) {
    // TODO: implement exist
    throw UnimplementedError();
  }

  @override
  Node? visitAllNodes({required Predicate shouldGetNode}) {
    throw UnimplementedError();
  }

  @override
  Node? visitNode({required Predicate shouldGetNode}) {
    // TODO: implement visitNode
    throw UnimplementedError();
  }
}
