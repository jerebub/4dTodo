import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/todoPages/todo_generator_form.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/todo_card.dart';


class TodoViewerPage extends StatefulWidget {
  const TodoViewerPage({super.key, required this.title});

  final String title;

  @override
  State<TodoViewerPage> createState() => _TodoViewerPageState();
}

class _TodoViewerPageState extends State<TodoViewerPage> {

  void _createNewTodo() {
    var appState = context.read<MyAppState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        alignment: Alignment.center,
        child: TodoGeneratorForm(appState: appState,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var todoList = appState.todoList;

    if (todoList.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('No TODOs yet'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewTodo(),
          tooltip: 'New TODO',
          child: const Icon(Icons.add),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            for (var todo in todoList)
              TodoCard(todoElement: todo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewTodo(),
        tooltip: 'New TODO',
        child: const Icon(Icons.add),
      ),
    );
  }
}
