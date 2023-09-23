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

  // void addTask(String newTaskTitle) {
  //   final task = TaskModel(
  //     name: newTaskTitle,
  //     deadline: '',
  //     priority: 'Medium',
  //     description: 'ksdk',
  //   );
  //   _tasks.add(task);
  //   notifyListeners();
  // }

  void addTask(String newTaskTitle, String priority, String deadline,
      String description, DocumentReference userReference) {
    final task = TaskModel(
      name: newTaskTitle,
      deadline: deadline,
      priority: priority,
      description: description,
    );

    // Call the addTaskToFirestore method to store the task in Firestore
    addTaskToFirestore(task, userReference);
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

  Future<void> addTaskToFirestore(
      TaskModel task, DocumentReference userReference) async {
    try {
      // Fetch the user's existing tasks
      final userDocSnapshot = await userReference.get();

      if (userDocSnapshot.exists) {
        final userData = userDocSnapshot.data() as Map<String, dynamic>;
        List<dynamic>? tasksList = userData['tasks'];

        // Update the tasks list with the new task
        if (tasksList == null) {
          tasksList = [task.toJson()];
        } else {
          tasksList.add(task.toJson());
        }

        // Update the tasks data in Firestore
        await userReference.update({'tasks': tasksList});
      } else {
        // If the user document doesn't exist, create it with the new task
        await userReference.set({
          'tasks': [task.toJson()]
        });
      }
    } catch (e) {
      // Handle errors, e.g., print or throw an exception
      if (kDebugMode) {
        print('Error adding task to Firestore: $e');
      }
    }
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
