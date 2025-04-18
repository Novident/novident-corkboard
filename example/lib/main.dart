import 'package:example/src/domain/entities/document.dart';
import 'package:flutter/material.dart';
import 'package:novident_corkboard/novident_corkboard.dart';
import 'package:novident_nodes/novident_nodes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return CorkboardViewProvider(
      viewMode: CorkboardViewMode.corkboard,
      controller: CorkboardController(
        node: ValueNotifier(Document(details: NodeDetails.zero())),
        selectedNodes: [],
        labels: {},
        options: CorkboardOptions.starter(),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Scrollbar(
          controller: _horizontalScrollController,
          trackVisibility: true,
          thumbVisibility: true,
          scrollbarOrientation: ScrollbarOrientation.top,
          child: SingleChildScrollView(
            controller: _verticalScrollController,
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Text(
                  'Works dskja dksajksdaj sdakdsakdsakdsajjkdsa dskaj dsaksd aksdaj kjdas kjdsa kdjsa dsakj '
                  'daskj dsakjsda kjdas kjdsa kjdsa kjdaskdjsadkasjdaskjda jkda kjdsa kjdsa kjdsakjdsadkjsa dsakj dsakjdsa kjdsa '
                  'kdsakdsakjdsasd adsa jkjdsa dskj dsakjdsakjsdakjdaskjdas sdakdaksjdakjdaskjdsa jkdsa k',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
