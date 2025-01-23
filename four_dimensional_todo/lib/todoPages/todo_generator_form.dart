import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:four_dimensional_todo/todo_element.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TodoGeneratorForm extends StatefulWidget {
  const TodoGeneratorForm({super.key});

  @override
  State<TodoGeneratorForm> createState() => _TodoGeneratorFormState();
}

class _TodoGeneratorFormState extends State<TodoGeneratorForm> {
  final _formKey = GlobalKey<FormState>();

  // ignore: prefer_typing_uninitialized_variables
  var dueDate;
  var dateFormat = DateFormat('dd/MM/yyyy');
  var creationDate = DateTime.now();
  var urgency = 'urgent';
  var importance = 'important';
  var done = false;
  // ignore: prefer_typing_uninitialized_variables
  var title;
  // ignore: prefer_typing_uninitialized_variables
  var description;

  void saveTodo({required String title, String? description, required String urgency, required String importance, DateTime? dueDate, bool done=false, DateTime? creationDate}) {
    creationDate ??= DateTime.now();
    var appState = context.read<MyAppState>();
    //determine the eisenhower matrix category
    var eisenhowerMatrixCategory = EisenhowerMatrixCategory.urgentImportant;
    if (urgency == 'urgent' && importance == 'important') {
      eisenhowerMatrixCategory = EisenhowerMatrixCategory.urgentImportant;
    } else if (urgency == 'urgent' && importance == 'unimportant') {
      eisenhowerMatrixCategory = EisenhowerMatrixCategory.urgentNotImportant;
    } else if (urgency == 'notUrgent' && importance == 'important') {
      eisenhowerMatrixCategory = EisenhowerMatrixCategory.notUrgentImportant;
    } else if (urgency == 'notUrgent' && importance == 'unimportant') {
      eisenhowerMatrixCategory = EisenhowerMatrixCategory.notUrgentNotImportant;
    }
    var newTodo = TodoElement(
      title: title,
      description: description,
      done: done,
      eisenhowerMatrixCategory: eisenhowerMatrixCategory,
      dueDate: dueDate,
      creationDate: creationDate,
    );
    // adding todo to todoList
    appState.addTodoElement(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    var dueDateString = AppLocalizations.of(context)!.noDueDate;
    if (dueDate != null) {
      dueDateString = dateFormat.format(dueDate);
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
                              creationDateString =
                                  dateFormat.format(newDate);
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
                    SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              saveTodo(title: title, description: description, urgency: urgency, importance: importance, dueDate: dueDate, done: done, creationDate: creationDate);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.submit),
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
