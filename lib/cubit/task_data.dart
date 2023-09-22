import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'dart:collection';

import '../data/model/task_model.dart';

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
    final task = Task(
        name: newTaskTitle,
        deadline: '',
        priority: 'Medium',
        description: 'ksdk');
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
    // if (kDebugMode) {
    print('Fetching Tasks');
    // }
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
        print('User not null');

        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          print('userDocSnapshot exists');

          final tasksData = userDocSnapshot.data() as Map<String, dynamic>;
          // print('Tasks Data: $tasksData'); // Print the entire map for debugging
          final List<dynamic>? tasksList = tasksData['tasks'];

          if (tasksList != null) {
            _tasks = tasksList.map((taskData) {
              final deadlineTimestamp = taskData['deadline'] as Timestamp?;
              final deadline = deadlineTimestamp != null
                  ? DateFormat('dd-MM-yyyy').format(deadlineTimestamp.toDate())
                  : 'No Deadline';
              print(
                  'Task Deadline: $deadline'); // Print the deadline value for debugging
              return Task(
                name: taskData['title'],
                description: taskData['description'],
                priority: taskData['priority'],
                deadline: deadline,
              );
            }).toList();

            notifyListeners(); // Notify listeners after updating _tasks
          }
        }
      }
      // if (kDebugMode) {
      print('Tasks Fetched');
      // }
    } catch (e) {
      // if (kDebugMode) {
      print("Error fetching data: $e");
      // }
    }
  }
}
