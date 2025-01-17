import 'package:flutter/material.dart';

class TodoElement {
  int? id;
  String title;
  String? description;
  bool done;
  bool archived;
  DateTime creationDate;
  DateTime? dueDate;
  EisenhowerMatrixCategory eisenhowerMatrixCategory;

  TodoElement({this.id, required this.title, required this.description, this.done = false, this.archived = false, required this.eisenhowerMatrixCategory, required this.dueDate, required this.creationDate});

  @override
  String toString() {
    return toMap().toString();
  }
  void setID(int newId){
    id = newId;
  }

  void markAsDone(){
    done = !done;
  }

  void markAsArchived(){
    archived = !archived;
  }

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

  String getUrgency() {
    if (eisenhowerMatrixCategory == EisenhowerMatrixCategory.urgentImportant || eisenhowerMatrixCategory == EisenhowerMatrixCategory.urgentNotImportant) {
      return 'urgent';
    }
    return 'notUrgent';
  }

  String getImportance() {
    if (eisenhowerMatrixCategory == EisenhowerMatrixCategory.urgentImportant || eisenhowerMatrixCategory == EisenhowerMatrixCategory.notUrgentImportant) {
      return 'important';
    }
    return 'unimportant';
  }

  DateTime? getDueDate(){
    return dueDate;
  }

  String? getDescription(){
    return description;
  }

  String categoryToString(){
    switch (eisenhowerMatrixCategory) {
      case EisenhowerMatrixCategory.urgentImportant:
        return 'Urgent and Important';
      case EisenhowerMatrixCategory.urgentNotImportant:
        return 'Urgent but not Important';
      case EisenhowerMatrixCategory.notUrgentImportant:
        return 'Important but not Urgent';
      case EisenhowerMatrixCategory.notUrgentNotImportant:
        return 'Not Urgent and not Important';
    }
  }

  static EisenhowerMatrixCategory stringToCategory(String category){
    switch (category) {
      case 'Urgent and Important':
        return EisenhowerMatrixCategory.urgentImportant;
      case 'Urgent but not Important':
        return EisenhowerMatrixCategory.urgentNotImportant;
      case 'Important but not Urgent':
        return EisenhowerMatrixCategory.notUrgentImportant;
      case 'Not Urgent and not Important':
        return EisenhowerMatrixCategory.notUrgentNotImportant;
      default:
        return EisenhowerMatrixCategory.urgentImportant;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description?? '',
      'done': done ? 1 : 0,
      'archived': archived ? 1 : 0,
      'creationDate': creationDate.toIso8601String(),
      'dueDate': dueDate != null? dueDate!.toIso8601String(): '',
      'eisenhowerMatrixCategory': categoryToString(),
    };
  }
}

enum EisenhowerMatrixCategory {
  urgentImportant,
  urgentNotImportant,
  notUrgentImportant,
  notUrgentNotImportant,
}