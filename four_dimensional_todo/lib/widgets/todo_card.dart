import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:four_dimensional_todo/todo_element.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatefulWidget {
  final TodoElement todoElement;

  const TodoCard({super.key, required this.todoElement});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  void onDone(TodoElement todo) async {
    MyAppState appState = context.read<MyAppState>();
    todo.markAsDone();
    await appState.updateTodoElement(todo);
  }

  void onDelete(TodoElement todo) async {
    var appState = context.read<MyAppState>();
    await appState.deleteTodoElement(todo);
  }

  void onArchive() {
    //TODO: implement onArchive
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
                ? onArchive()
                : onDelete(widget.todoElement);
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
          color: Colors.green,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.archive_outlined),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              onDone(widget.todoElement);
            });
          },
          child: Container(
            constraints: BoxConstraints(minHeight: minHeight),
            color: theme.colorScheme.inversePrimary,
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
                        onDone(widget.todoElement);
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
