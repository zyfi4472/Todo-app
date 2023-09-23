import 'package:json_annotation/json_annotation.dart';
// part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  late String name;
  late String description;
  late String priority;
  late String deadline;
  // late bool isDone;

  TaskModel({
    required this.name,
    required this.description,
    required this.deadline,
    required this.priority,
  });
  // this.isDone = false,

  void toggleDone() {
    // isDone = !isDone;
  }

  TaskModel.fromJson(Map<String, dynamic> json) {
    name = json['title'];
    description = json['description'];
    // Convert Firestore Timestamp to DateTime
    // final timestamp = json['deadline'] as Timestamp?;
    deadline = json['deadline'];
    // ignore: prefer_null_aware_operators
    // (timestamp != null ? timestamp.toDate().toLocal().toString() : null)!;
    priority = json['priority'];
    // isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = name;
    data['description'] = description;
    data['deadline'] = deadline;
    data['priority'] = priority;
    // data['isDone'] = isDone;

    return data;
  }

  // factory TaskModel.fomJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  // Map<String, dynamic> toJson(TaskModel task) => _$TaskToJson(this);
}

class TaskResultModel {
  List<TaskModel>? tasks;

  TaskResultModel({this.tasks});

  TaskResultModel.fromJson(List<dynamic> json) {
    tasks = <TaskModel>[]; // Using a list literal
    for (var task in json) {
      tasks!.add(TaskModel.fromJson(task));
      // print(task);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tasks != null) {
      data['tasks'] = tasks!.map((task) => task.toJson()).toList();
    }
    return data;
  }
}
