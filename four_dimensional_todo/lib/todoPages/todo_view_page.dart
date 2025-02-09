import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/todoPages/todo_generator_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../main.dart';
import '../widgets/todo_card.dart';

class TodoViewerPage extends StatefulWidget {
  const TodoViewerPage({super.key,});


  @override
  State<TodoViewerPage> createState() => _TodoViewerPageState();
}

class _TodoViewerPageState extends State<TodoViewerPage> {
  @override
  void initState() {
    super.initState();
    _myInit();
  }

  void _myInit() async {
    var appState = context.read<MyAppState>();
    await appState.getUnarchivedTodoElementsFromDB();
  }

  void _createNewTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        alignment: Alignment.center,
        child: TodoGeneratorForm(),
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
          child: Text(AppLocalizations.of(context)!.noTodosYet),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewTodo(),
          tooltip: AppLocalizations.of(context)!.newTodo,
          child: const Icon(Icons.add),
        ),
      );
    }
    return Scaffold(
      body: ListView.separated(
        itemCount: todoList.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return TodoCard(todoElement: todoList[index]);
        },
        separatorBuilder: (BuildContext context, int index) =>
            Container(padding: EdgeInsets.all(8.0)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewTodo(),
        tooltip: AppLocalizations.of(context)!.newTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
