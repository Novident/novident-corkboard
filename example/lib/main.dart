import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart' as appf;
import 'package:example/src/domain/entities/document.dart';
import 'package:example/src/domain/entities/folder.dart';
import 'package:flutter/cupertino.dart';
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
      title: 'Example app',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
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
  final appf.EditorState editorState =
      appf.EditorState.blank(withInitialText: true);
  final ValueNotifier<CardCorkboardOptions> _options = ValueNotifier(
    CardCorkboardOptions.starter(),
  );

  final Folder folder = Folder(
    details: NodeDetails.zero(),
    children: <Node>[
      Document(
        details: NodeDetails.zero(),
        offset: Offset(0, 0),
        content: 'Este es un texto en el documento 1',
        name: 'Documento 1',
      ),
      Document(
        details: NodeDetails.zero(),
        offset: Offset(30, 30),
        content: '',
        name: 'Documento 2',
      ),
      Document(
        details: NodeDetails.zero(),
        offset: Offset(60, 60),
        content: 'Este es un texto en el documento 3',
        name: 'Documento 3',
      ),
      Document(
        details: NodeDetails.zero(),
        offset: Offset(1120, 700),
        content: 'Este es un texto en el documento 4',
        name: 'Documento 4',
      ),
    ],
    viewMode: CorkboardViewMode.corkboardFreeform,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Free form example')),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  folder.lastViewMode.value = CorkboardViewMode.single;
                },
                icon: Icon(CupertinoIcons.doc_text),
              ),
              IconButton(
                onPressed: () {
                  folder.lastViewMode.value =
                      CorkboardViewMode.corkboardFreeform;
                },
                icon: Icon(CupertinoIcons.book),
              ),
            ],
          ),
          Flexible(
            child: NovidentCorkboard(
              node: folder,
              onSingleView: (node) {
                return appf.AppFlowyEditor(
                  editorState: editorState,
                );
              },
              configuration: CorkboardConfiguration(
                debugMode: true,
                allowZoom: Platform.isAndroid || Platform.isIOS,
                cardCorkboardOptions: _options,
                minScale: 0.8,
                initialScale: 0.8,
                cardWidget: _cardWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardWidget(
    BuildContext context,
    Node node,
    double currentScale,
    bool isSelected,
    bool isDragging,
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
          : BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  color: Colors.black.withAlpha(200),
                  width: 1.0,
                ),
              ),
            ),
      position: DecorationPosition.foreground,
      child: Container(
        constraints: constraints,
        color: Colors.white,
        child: Column(
          children: [
            Text((node as Document).name),
            Divider(),
            const SizedBox(height: 2),
            Text(node.content),
          ],
        ),
      ),
    );
  }
}
