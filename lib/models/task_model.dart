class Task {
  final String name;
  final String description;
  final String priority;
  String deadline;
  bool isDone;

  Task(
      {required this.name,
      required this.description,
      required this.deadline,
      required this.priority,
      this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
