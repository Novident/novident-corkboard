import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart' as appf;
import 'package:example/src/domain/entities/document.dart';
import 'package:example/src/domain/entities/folder.dart';
import 'package:example/src/ui/cards/card_widget.dart';
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
    name: 'Root folder',
    synopsis: '',
    details: NodeDetails.zero(),
    children: <Node>[
      Document(
        details: NodeDetails.zero(),
        content: 'Este es un texto en el documento 1',
        name: 'Documento 1',
      ),
      Document(
        details: NodeDetails.zero(),
        content: '',
        name: 'Documento 2',
      ),
      Document(
        details: NodeDetails.zero(),
        content: 'Este es un texto en el documento 3',
        name: 'Documento 3',
      ),
      Document(
        details: NodeDetails.zero(),
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
              filterViewMode: (node, value) {
                if (value.isSingleMode && node is Folder) {
                  return false;
                }

                if (!value.isSingleMode && node is! NodeContainer) {
                  return false;
                }

                return true;
              },
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
                cardWidget: (
                  BuildContext context,
                  Node node,
                  double currentScale,
                  bool isSelected,
                  bool isDragging,
                  BoxConstraints constraints,
                  void Function() selectThis,
                ) =>
                    NodeCardWidget(
                  node: node,
                  currentScale: currentScale,
                  isSelected: isSelected,
                  isDragging: isDragging,
                  constraints: constraints,
                  selectThis: selectThis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
