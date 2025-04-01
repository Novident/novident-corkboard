import 'dart:ui';

import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

class Folder extends NodeContainer
    implements OffsetManagerMixin, CardIndexPositionMixin {
  Folder({
    required super.children,
    required super.details,
  });

  @override
  bool operator ==(covariant Node other) {
    throw UnimplementedError();
  }

  @override
  Folder clone() {
    throw UnimplementedError();
  }

  @override
  Node copyWith({NodeDetails? details}) {
    throw UnimplementedError();
  }

  @override
  int get hashCode => throw UnimplementedError();

  @override
  bool get isExpanded => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  set cardIndex(int index) {}

  @override
  set cardOffset(Offset offset) {}

  @override
  int get cardIndex => 1;

  @override
  Offset get cardOffset => Offset.zero;
}
