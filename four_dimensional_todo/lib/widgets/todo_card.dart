import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:four_dimensional_todo/todoPages/todo_editor_form.dart';
import 'package:four_dimensional_todo/todo_element.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatefulWidget {
  final TodoElement todoElement;
  final int state;

  const TodoCard({super.key, required this.todoElement, this.state=0});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {

  void _edit(TodoElement todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        alignment: Alignment.center,
        child: TodoEditorForm(todoElement: todo, state: widget.state),
      ),
    );
  }

  void _onDone(TodoElement todo) async {
    if (widget.state == 0){
      MyAppState appState = context.read<MyAppState>();
      todo.markAsDone();
      await appState.updateTodoElement(todoElement: todo);
    }
  }

  void _onDelete(TodoElement todo) async {
    var appState = context.read<MyAppState>();
    await appState.deleteTodoElement(todo);
  }

  void _onArchive(TodoElement todo) async{
    MyAppState appState = context.read<MyAppState>();
    todo.markAsArchived();
    if (widget.state == 0) {
      appState.todoList.remove(todo);
      appState.archivedTodoList.add(todo);
      await appState.updateTodoElement(todoElement: todo);
    }
    else {
      appState.archivedTodoList.remove(todo);
      appState.todoList.add(todo);
      await appState.updateTodoElement(todoElement: todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var minHeight = 70.0;
    var des = '';
    if (widget.todoElement.description != null) {
      des = widget.todoElement.description!;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection dir) {
          setState(() {
            dir == DismissDirection.endToStart
                ? _onArchive(widget.todoElement)
                : _onDelete(widget.todoElement);
          });
        },
        background: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          color: Colors.red,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.delete),
          ),
        ),
        secondaryBackground: Container(
          constraints: BoxConstraints(minHeight: minHeight),
          color: widget.state == 0? Colors.green : Colors.grey,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.state == 0? const Icon(Icons.archive_outlined): const Icon(Icons.unarchive_outlined),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _onDone(widget.todoElement);
            });
          },
          onLongPress: () {
            setState(() {
              _edit(widget.todoElement);
            });
          },
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            color: widget.todoElement.done? theme.colorScheme.inversePrimary: theme.colorScheme.primary,
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.todoElement.getIcon(),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.todoElement.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          des,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: widget.todoElement.done
                        ? Icon(Icons.check)
                        : Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      setState(() {
                        _onDone(widget.todoElement);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
