import 'dart:ui';

import 'package:novident_corkboard/src/common/enums/modes.dart';
import 'package:novident_corkboard/src/common/mixins/mixins.dart';
import 'package:novident_nodes/novident_nodes.dart';

class NodeMock extends Node
   with 
        OffsetManagerMixin,
        CardIndexPositionMixin,
        PersistentViewModeMixin,
        LabelManagerMixin {
  NodeMock() : super(details: NodeDetails.zero());

  @override
  NodeMock clone() {
    return NodeMock();
  }

  @override
  Node copyWith({NodeDetails? details}) {
    return NodeMock();
  }

  @override
  String get nodeLabel => '';

  @override
  CorkboardViewMode get nodeLastMode => CorkboardViewMode.corkboard;

  @override
  int get nodeCardIndex => -1;

  @override
  Offset get nodeCardOffset => Offset.zero;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  Node? visitAllNodes({required Predicate shouldGetNode}) {
    throw UnimplementedError();
  }

  @override
  Node? visitNode({required Predicate shouldGetNode}) {
    throw UnimplementedError();
  }

  @override
  int countAllNodes({required Predicate countNode}) {
    throw UnimplementedError();
  }

  @override
  int countNodes({required Predicate countNode}) {
    throw UnimplementedError();
  }

  @override
  bool deepExist(String id) {
    throw UnimplementedError();
  }

  @override
  bool exist(String id) {
    throw UnimplementedError();
  }

  @override
  bool operator ==(covariant NodeMock other) {
    return details == other.details;
  }

  @override
  int get hashCode => details.hashCode;
}
