// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../model/task_model.dart';
import '../../../views/widgets/flutter_toast.dart';

abstract class FirebaseAuthRepo {
  Future<User?> signIn(String email, String password);
  Future<User?> CreateUser(String email, String password, String name);
  deleteTaskFromFirestore(TaskModel task);
}

class FirebaseAuthentication implements FirebaseAuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> CreateUser(String email, String password, String name) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser.user != null) {
        // User has been created, now store additional user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.user!.uid)
            .set({
          'name': name,
          'email': email,
          'isAdmin': false,
          // Add other user properties here
        });

        return newUser.user;
      } else {
        return null;
      }
    } catch (error) {
      // Handle sign-up errors
      // print('Sign-up error: $error');
      showFlutterToast('Error creating user: $error');

      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      // Handle sign-in errors
      if (kDebugMode) {
        showFlutterToast('Sign-in error: $error');
      }
      return null;
    }
  }

  @override
  void deleteTaskFromFirestore(TaskModel task) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          final tasksData = userDocSnapshot.data() as Map<String, dynamic>;
          List<dynamic>? tasksList = tasksData['tasks'];

          if (tasksList != null) {
            // Find the task to delete by comparing the task name
            final taskToDelete = tasksList.firstWhere(
              (taskData) => taskData['title'] == task.name,
              orElse: () => null,
            );

            if (taskToDelete != null) {
              tasksList.remove(taskToDelete);

              // Update the 'tasks' field in Firestore with the modified tasks list
              await userDocRef.update({'tasks': tasksList});

              // // Notify listeners to update the local task list
              // _tasks.remove(task);
              // notifyListeners();
            }
          }
        }
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print("Error deleting task from Firestore: $e");
      // }
    }
  }
}
