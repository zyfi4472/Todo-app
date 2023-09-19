import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'dart:collection';
import 'package:todoey_app/models/task.dart';

class TaskData extends ChangeNotifier {
  final taskAuth = FirebaseAuthentication();
  List<Task> _tasks = [];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
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

  Future<void> fetchTasksFromFirestore() async {
    print('Fetching Tasks');
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          final tasksData = userDocSnapshot.data() as Map<String, dynamic>;
          final List<dynamic>? tasksList = tasksData['tasks'];

          if (tasksList != null) {
            _tasks = tasksList.map((taskData) {
              return Task(name: taskData['title']);
            }).toList();

            notifyListeners(); // Notify listeners after updating _tasks
          }
        }
      }
      print('Tasks Fetched');
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
