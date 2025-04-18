import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_corkboard/src/widgets/configuration/corkboard_configuration.dart';
import 'package:novident_corkboard/src/widgets/corkboard/corkboard.dart';

class NovidentCorkboard extends StatefulWidget {
  final CorkboardConfiguration configuration;
  const NovidentCorkboard({
    super.key,
    required this.configuration,
  });

  @override
  State<NovidentCorkboard> createState() => _NovidentCorkboardState();
}

class _NovidentCorkboardState extends State<NovidentCorkboard> {
  @override
  Widget build(BuildContext context) {
    final CorkboardViewProvider provider =
        CorkboardViewProvider.of(context, listen: true);
    if (provider.viewMode.isSingleMode) {}
    if (provider.viewMode.isOutliner) {}
    if (provider.viewMode.isCorkboard) {
      return Corkboard(
        configuration: widget.configuration,
      );
    }
    return Center(
      child: Text('Not founded ${provider.viewMode.name} implementation view'),
    );
  }
}
