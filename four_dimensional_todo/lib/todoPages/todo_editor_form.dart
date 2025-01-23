import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:four_dimensional_todo/todo_element.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TodoEditorForm extends StatefulWidget {
  TodoElement todoElement;
  int state;
  TodoEditorForm({super.key, required this.todoElement, this.state = 0});

  @override
  State<TodoEditorForm> createState() => _TodoEditorFormState();
}

class _TodoEditorFormState extends State<TodoEditorForm> {
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('dd/MM/yyyy');
  var urgency = 'urgent';
  var importance = 'important';
  DateTime? dueDate = DateTime.now();
  DateTime creationDate = DateTime.now();
  bool done = false;
  String title = '';
  String? description = '';
  bool archived = true;

  @override
  void initState() {
    super.initState();
    urgency = widget.todoElement.getUrgency();
    importance = widget.todoElement.getImportance();
    dueDate = widget.todoElement.getDueDate();
    creationDate = widget.todoElement.creationDate;
    done = widget.todoElement.done;
    title = widget.todoElement.title;
    description = widget.todoElement.getDescription();
    archived = widget.todoElement.archived;
  }

  void editTodo(
      {required String title,
      String? description,
      required String urgency,
      required String importance,
      DateTime? dueDate,
      bool done = false,
      required DateTime creationDate}) {
    var appState = context.read<MyAppState>();

    widget.todoElement.title = title;
    widget.todoElement.description = description;
    widget.todoElement.done = done;
    widget.todoElement.dueDate = dueDate;
    widget.todoElement.creationDate = creationDate;

    if (urgency == 'urgent' && importance == 'important') {
      widget.todoElement.eisenhowerMatrixCategory =
          EisenhowerMatrixCategory.urgentImportant;
    } else if (urgency == 'urgent' && importance == 'unimportant') {
      widget.todoElement.eisenhowerMatrixCategory =
          EisenhowerMatrixCategory.urgentNotImportant;
    } else if (urgency == 'notUrgent' && importance == 'important') {
      widget.todoElement.eisenhowerMatrixCategory =
          EisenhowerMatrixCategory.notUrgentImportant;
    } else if (urgency == 'notUrgent' && importance == 'unimportant') {
      widget.todoElement.eisenhowerMatrixCategory =
          EisenhowerMatrixCategory.notUrgentNotImportant;
    }

    appState.updateTodoElement(todoElement: widget.todoElement);
    if (widget.state != 0 && archived != widget.todoElement.archived) {
      widget.todoElement.markAsArchived();
      if (archived) {
        appState.todoList.remove(widget.todoElement);
        appState.archivedTodoList.add(widget.todoElement);
      } else {
        appState.archivedTodoList.remove(widget.todoElement);
        appState.todoList.add(widget.todoElement);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var dueDateString = AppLocalizations.of(context)!.noDueDate;
    if (dueDate != null) {
      dueDateString = dateFormat.format(dueDate!);
    }
    var creationDateString = dateFormat.format(creationDate);
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.8),
        child: ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.title),
                      autofocus: true,
                      initialValue: title,
                      onChanged: (value) => title = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterATitle;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: AppLocalizations.of(context)!.description),
                      maxLines: null,
                      initialValue: description,
                      onChanged: (value) => description = value,
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!.dueDate),
                        TextButton(
                          onPressed: () async {
                            var newDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 9999999)),
                            );
                            if (newDate == null) return;
                            setState(() {
                              dueDate = newDate;
                              dueDateString = dateFormat.format(newDate);
                            });
                          },
                          child: Text(dueDateString),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context)!.creationDateCol),
                        TextButton(
                          onPressed: () async {
                            var newDate = await showDatePicker(
                              context: context,
                              initialDate: creationDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (newDate == null) return;
                            setState(() {
                              creationDate = newDate;
                              creationDateString = dateFormat.format(newDate);
                            });
                          },
                          child: Text(creationDateString),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: SegmentedButton(
                        showSelectedIcon: false,
                        segments: <ButtonSegment>[
                          ButtonSegment(
                            label: Text(AppLocalizations.of(context)!.urgent),
                            value: 'urgent',
                          ),
                          ButtonSegment(
                            label: Text(AppLocalizations.of(context)!.notUrgent),
                            value: 'notUrgent',
                          ),
                        ],
                        selected: {urgency},
                        onSelectionChanged: (selected) {
                          setState(() {
                            urgency = selected.first;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: SegmentedButton(
                        showSelectedIcon: false,
                        segments: <ButtonSegment>[
                          ButtonSegment(
                            label: Text(AppLocalizations.of(context)!.important),
                            value: 'important',
                          ),
                          ButtonSegment(
                            label: Text(AppLocalizations.of(context)!.unimportant),
                            value: 'unimportant',
                          ),
                        ],
                        selected: {importance},
                        onSelectionChanged: (selected) {
                          setState(() {
                            importance = selected.first;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    CheckboxListTile(
                      title: Text(AppLocalizations.of(context)!.markAsDone),
                      value: done,
                      onChanged: (value) {
                        setState(() {
                          done = value!;
                        });
                      },
                    ),
                    widget.state == 0
                      ? Container()
                      : CheckboxListTile(
                          title: Text(AppLocalizations.of(context)!.archiveVerb),
                          value: archived,
                          onChanged: (value) {
                            setState(() {
                              archived = value!;
                            });
                          },
                      ),
                    SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              editTodo(
                                  creationDate: creationDate,
                                  description: description,
                                  done: done,
                                  dueDate: dueDate,
                                  importance: importance,
                                  title: title,
                                  urgency: urgency);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
