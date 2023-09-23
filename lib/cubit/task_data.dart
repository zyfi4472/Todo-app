import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'package:todoey_app/data/repository/tasks_repo.dart';
import 'dart:collection';
import '../data/model/task_model.dart';

class TaskData extends ChangeNotifier {
  final taskAuth = FirebaseAuthentication();
  TaskRepository taskRepository = TaskRepository();
  TaskResultModel taskResultModel = TaskResultModel();

  List<TaskModel> _tasks = [];

  UnmodifiableListView<TaskModel> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle, String priority, String deadline,
      String description, DocumentReference userReference) {
    final task = TaskModel(
      name: newTaskTitle,
      deadline: deadline,
      priority: priority,
      description: description,
    );

    // Call the addTaskToFirestore method to store the task in Firestore
    TaskRepository.addTaskToFirestore(task, userReference);
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(TaskModel task) {
    // To delete a task
    _tasks.remove(task);
    // taskAuth.deleteTaskFromFirestore(task);
    notifyListeners();
  }

  // Method to clear all tasks
  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }

  Future<void> fetchAndSetTasks() async {
    try {
      final tasks =
          await taskRepository.fetchTasks(); // Fetch tasks using repository
      if (tasks != null) {
        _tasks = tasks;
        notifyListeners(); // Notify listeners after updating _tasks
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching and setting tasks: $e');
      }
    }
  }
}
