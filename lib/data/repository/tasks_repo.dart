import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todoey_app/data/model/task_model.dart';

abstract class TaskRepo {
  Future<List<TaskModel>?> fetchTasks();
  Future<void> addTaskToFirestore(
      TaskModel task, DocumentReference userReference);
}

class TaskRepository implements TaskRepo {
  Future<List<TaskModel>?> fetchTasks() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDocSnapshot = await userDocRef.get(); // Await the snapshot
        // print(userDocSnapshot);

        if (userDocSnapshot.exists) {
          final userData = userDocSnapshot.data();
          // print(userData);

          if (userData != null && userData.containsKey('tasks')) {
            final tasksList = userData['tasks'] as List<dynamic>?;

            if (tasksList != null) {
              List<TaskModel>? tasks =
                  TaskResultModel.fromJson(tasksList).tasks;

              // print(tasksList);
              return tasks;
            }
          }
        }
      }
    } catch (e) {
      // Handle errors, e.g., print or throw an exception
      if (kDebugMode) {
        print('Error fetching tasks: $e');
      }
    }

    return []; // Return an empty list if there are no tasks or an error occurs
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
}
