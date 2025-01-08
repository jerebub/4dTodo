import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:four_dimensional_todo/todo_element.dart';
import 'package:intl/intl.dart';

class TodoGeneratorForm extends StatefulWidget {
  final MyAppState appState;
  TodoGeneratorForm({super.key, required this.appState});

  @override
  State<TodoGeneratorForm> createState() => _TodoGeneratorFormState();
  // ignore: prefer_typing_uninitialized_variables
  var dueDate;
  var dateFormat = DateFormat('dd/MM/yyyy');
  var creationDate = DateTime.now();
  var urgency = 'urgent';
  var importance = 'important';
  var done = false;

  void saveTodo(String title, String description) {
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
    appState.todoList.add(newTodo);
  }
}

class _TodoGeneratorFormState extends State<TodoGeneratorForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    var dueDateString = 'No due date';
    if (widget.dueDate != null) {
      dueDateString = widget.dateFormat.format(widget.dueDate);
    }
    var creationDateString = widget.dateFormat.format(widget.creationDate);
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
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
                              // initialDate: widget.dueDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 9999999)),
                            );
                            if (newDate == null) return;
                            setState(() {
                              widget.dueDate = newDate;
                              dueDateString = widget.dateFormat.format(newDate);
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
                              initialDate: widget.creationDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 9999999)),
                            );
                            if (newDate == null) return;
                            setState(() {
                              widget.creationDate = newDate;
                              creationDateString =
                                  widget.dateFormat.format(newDate);
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
                        selected: {widget.urgency},
                        onSelectionChanged: (selected) {
                          setState(() {
                            widget.urgency = selected.first;
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
                        selected: {widget.importance},
                        onSelectionChanged: (selected) {
                          setState(() {
                            widget.importance = selected.first;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    CheckboxListTile(
                      title: Text('Mark as done'),
                      value: widget.done,
                      onChanged: (value) {
                        setState(() {
                          widget.done = value!;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              widget.saveTodo(titleController.text, descriptionController.text);
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
