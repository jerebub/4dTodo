import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:four_dimensional_todo/todo_element.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TodoGeneratorForm extends StatefulWidget {
  const TodoGeneratorForm({super.key});

  @override
  State<TodoGeneratorForm> createState() => _TodoGeneratorFormState();
  // ignore: prefer_typing_uninitialized_variables
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
    var eisenhoverMatrixCategory = EisenhowerMatrixCategory.urgentImportant;
    if (urgency == 'urgent' && importance == 'important') {
      eisenhoverMatrixCategory = EisenhowerMatrixCategory.urgentImportant;
    } else if (urgency == 'urgent' && importance == 'unimportant') {
      eisenhoverMatrixCategory = EisenhowerMatrixCategory.urgentNotImportant;
    } else if (urgency == 'notUrgent' && importance == 'important') {
      eisenhoverMatrixCategory = EisenhowerMatrixCategory.notUrgentImportant;
    } else if (urgency == 'notUrgent' && importance == 'unimportant') {
      eisenhoverMatrixCategory = EisenhowerMatrixCategory.notUrgentNotImportant;
    }
    var newTodo = TodoElement(
      title: title,
      description: description,
      done: done,
      eisenhowerMatrixCategory: eisenhoverMatrixCategory,
      dueDate: dueDate,
      creationDate: creationDate,
    );
    // adding todo to todoList
    appState.addTodoElement(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    var dueDateString = 'No due date';
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
                      decoration: const InputDecoration(labelText: 'Title'),
                      autofocus: true,
                      initialValue: title,
                      onChanged: (value) => title = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
                        const Text('Due Date: '),
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
                        const Text('Creation Date: '),
                        TextButton(
                          onPressed: () async {
                            var newDate = await showDatePicker(
                              context: context,
                              initialDate: creationDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 9999999)),
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
                        segments: const <ButtonSegment>[
                          ButtonSegment(
                            label: Text('Urgent'),
                            value: 'urgent',
                          ),
                          ButtonSegment(
                            label: Text('Not Urgent'),
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
                        segments: const <ButtonSegment>[
                          ButtonSegment(
                            label: Text('Important'),
                            value: 'important',
                          ),
                          ButtonSegment(
                            label: Text('Unimportant'),
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
                      title: Text('Mark as done'),
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
                        child: const Text('Submit'),
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
