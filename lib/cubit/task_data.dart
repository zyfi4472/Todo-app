import 'package:flutter/foundation.dart';

import 'dart:collection';
import '../data/model/task_model.dart';
import '../data/repository/taskRepo/tasks_repo.dart';

class TaskDataController {
  TaskRepository taskRepository = TaskRepository();
  TaskResultModel taskResultModel = TaskResultModel();

  List<TaskModel> _tasks = [];

  UnmodifiableListView<TaskModel> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void updateTask(TaskModel task) {
    task.toggleDone();
    // notifyListeners();
  }

  void deleteTask(TaskModel task) {
    // To delete a task
    _tasks.remove(task);
    // taskAuth.deleteTaskFromFirestore(task);
    // notifyListeners();
  }

  // Method to clear all tasks
  void clearTasks() {
    _tasks.clear();
    // notifyListeners();
  }

  Future<void> fetchAndSetTasks() async {
    try {
      final tasks =
          await taskRepository.fetchTasks(); // Fetch tasks using repository
      if (tasks != null) {
        _tasks = tasks;
        // notifyListeners(); // Notify listeners after updating _tasks
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching and setting tasks: $e');
      }
    }
  }
}
