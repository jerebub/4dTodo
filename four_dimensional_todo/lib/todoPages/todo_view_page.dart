import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/todoPages/todo_generator_form.dart';
import 'package:provider/provider.dart';

import '../main.dart';


class TodoViewerPage extends StatefulWidget {
  const TodoViewerPage({super.key, required this.title});

  final String title;

  @override
  State<TodoViewerPage> createState() => _TodoViewerPageState();
}

class _TodoViewerPageState extends State<TodoViewerPage> {
  int _counter = 0;

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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
              ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description ?? ''),
                trailing: Checkbox(
                  value: todo.done,
                  onChanged: (value) {
                    todo.done = value!;
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Text(
        //       'You have pushed the button sooo many times:',
        //     ),
        //     Text(
        //       '$_counter',
        //       style: Theme.of(context).textTheme.headlineMedium,
        //     ),
        //   ],
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewTodo(),
        tooltip: 'New TODO',
        child: const Icon(Icons.add),
      ),
    );
  }
}
