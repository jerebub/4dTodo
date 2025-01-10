import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/todo_element.dart';

class TodoCard extends StatefulWidget {
  final TodoElement todoElement;

  const TodoCard({super.key, required this.todoElement});

  @override
  State<TodoCard> createState() => _TodoCardState();

  void onDone() {
    todoElement.done = !todoElement.done;
  }

  void onArchive() {
    //TODO: implement onArchive
  }

  void onDelete() {
    //TODO: implement onDelete
  }
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var des = '';
    if (widget.todoElement.description != null) {
      des = widget.todoElement.description!;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Dismissible(
          key: Key(widget.todoElement.title),
          onDismissed: (DismissDirection dir) {
            setState(() {
              dir == DismissDirection.endToStart
                  ? widget.onDelete()
                  : widget.onArchive();
            });
          },
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.delete),
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.archive_outlined),
            ),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            tileColor: theme.colorScheme.inversePrimary,
            title: Text(widget.todoElement.title),
            subtitle: Text(des),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.todoElement.getIcon(),
            ),
            trailing: IconButton(
              icon: widget.todoElement.done
                  ? Icon(Icons.check)
                  : Icon(Icons.check_box_outline_blank),
              onPressed: () {
                setState(() {
                  widget.onDone();
                });
              },
            ),
            onTap: () {
              setState(() {
                widget.onDone();
              });
            }
          ),
        ),
      ),
    );
  }
}
