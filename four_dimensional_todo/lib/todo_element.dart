class TodoElement {
  String title;
  String description;
  bool done;
  DateTime creationDate = DateTime.now();
  DateTime? doneDate;
  EisenhowerMatrixCategory eisenhowerMatrixCategory;

  TodoElement({required this.title, required this.description, this.done = false, required this.eisenhowerMatrixCategory});
}

enum EisenhowerMatrixCategory {
  urgentImportant,
  urgentNotImportant,
  notUrgentImportant,
  notUrgentNotImportant,
}