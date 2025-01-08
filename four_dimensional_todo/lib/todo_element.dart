class TodoElement {
  String title;
  String? description;
  bool done;
  DateTime creationDate;
  DateTime? dueDate;
  EisenhowerMatrixCategory eisenhowerMatrixCategory;

  TodoElement({required this.title, required this.description, this.done = false, required this.eisenhowerMatrixCategory, required this.dueDate, required this.creationDate});
}

enum EisenhowerMatrixCategory {
  urgentImportant,
  urgentNotImportant,
  notUrgentImportant,
  notUrgentNotImportant,
}