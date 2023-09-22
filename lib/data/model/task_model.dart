import 'package:json_annotation/json_annotation.dart';
part 'task_model.g.dart';

@JsonSerializable()
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

  factory Task.fomJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson(Task task) => _$TaskToJson(this);
}
