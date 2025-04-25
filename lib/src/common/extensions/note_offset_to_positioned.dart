import 'package:flutter/material.dart';
import 'package:novident_corkboard/src/common/mixins/mixins.dart';
import 'package:novident_corkboard/src/controller/corkboard_controller.dart';
import 'package:novident_corkboard/src/widgets/configuration/corkboard_configuration.dart';
import 'package:novident_nodes/novident_nodes.dart';

extension NodeOffsetToWidget on Node {
  Widget? toPosition({
    required Widget child,
    required CorkboardController controller,
    required CorkboardConfiguration configuration,
  }) {
    if (this is! OffsetManagerMixin) return null;
    // size is determined by non customizable values
    //
    //TODO: create those values and test them
    final double size = controller.options.size;
    return Positioned.fromRect(
      rect: (this as OffsetManagerMixin).nodeCardOffset &
          Size(
            size / 2,
            size,
          ),
      child: child,
    );
  }
}
