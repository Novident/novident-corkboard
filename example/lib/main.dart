import 'package:example/src/domain/entities/document.dart';
import 'package:example/src/domain/entities/folder.dart';
import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canvas Infinito con Objetos',
      home: ExampleWidget(),
    );
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({
    super.key,
  });

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  final ValueNotifier<CardCorkboardOptions> _options =
      ValueNotifier(CardCorkboardOptions.starter());

  final Folder folder = Folder(
    details: NodeDetails.zero(),
    children: <Node>[
      Document(
        details: NodeDetails.zero(),
        offset: Offset(100, 100),
      ),
      Document(
        details: NodeDetails.zero(),
        offset: Offset(130, 130),
      ),
      Document(
        details: NodeDetails.zero(),
        offset: Offset(160, 160),
      ),
      Document(
        details: NodeDetails.zero(),
        offset: Offset(190, 190),
      ),
    ],
    viewMode: CorkboardViewMode.corkboardFreeform,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Free form example')),
      body: NovidentCorkboard(
        node: folder,
        configuration: CorkboardConfiguration(
          debugMode: true,
          allowZoom: true,
          cardCorkboardOptions: _options,
          cardWidget: (
            BuildContext context,
            Node node,
            bool isSelected,
            BoxConstraints constraints,
            void Function() selectThis,
          ) {
            return DecoratedBox(
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.fromBorderSide(
                        BorderSide(
                          width: 2.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  : BoxDecoration(),
              position: DecorationPosition.foreground,
              child: Container(
                constraints: constraints,
                color: Colors.red,
                child: Text(
                    'Object: ${(node as OffsetManagerMixin).nodeCardOffset.value}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
