import 'package:flutter/material.dart';

class TodoElement {
  String title;
  String? description;
  bool done;
  DateTime creationDate;
  DateTime? dueDate;
  EisenhowerMatrixCategory eisenhowerMatrixCategory;

  TodoElement({required this.title, required this.description, this.done = false, required this.eisenhowerMatrixCategory, required this.dueDate, required this.creationDate});

  Widget getIcon(){
    switch (eisenhowerMatrixCategory) {
      case EisenhowerMatrixCategory.urgentImportant:
        return const Icon(Icons.star);
      case EisenhowerMatrixCategory.urgentNotImportant:
        return const Icon(Icons.star_border);
      case EisenhowerMatrixCategory.notUrgentImportant:
        return const Icon(Icons.star_half);
      case EisenhowerMatrixCategory.notUrgentNotImportant:
        return const Icon(Icons.sunny);
    }
  }
}

enum EisenhowerMatrixCategory {
  urgentImportant,
  urgentNotImportant,
  notUrgentImportant,
  notUrgentNotImportant,
}