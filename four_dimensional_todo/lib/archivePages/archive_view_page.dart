import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/todo_card.dart';

class ArchiveViewerPage extends StatefulWidget {
  const ArchiveViewerPage({super.key, required this.title});

  final String title;

  @override
  State<ArchiveViewerPage> createState() => _ArchiveViewerPageState();
}

class _ArchiveViewerPageState extends State<ArchiveViewerPage> {
  @override
  void initState() {
    super.initState();
    _myInit();
  }

  void _myInit() async {
    var appState = context.read<MyAppState>();
    await appState.getArchivedTodoElementsFromDB();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var archivedList = appState.archivedTodoList;

    if (archivedList.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Nothing archived yet'),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: ListView.separated(
          itemCount: archivedList.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return TodoCard(todoElement: archivedList[index], state: 1);
          },
          separatorBuilder: (BuildContext context, int index) =>
              Container(padding: EdgeInsets.all(8.0)),
        ),
      ),
    );
  }
}
