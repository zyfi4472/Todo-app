import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoey_app/data/model/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> fetchTasks() async {
    final user = FirebaseAuth.instance.currentUser;

    print('inside fetchTasks');
    try {
      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDocSnapshot = await userDocRef.get(); // Await the snapshot
        print(userDocSnapshot);

        if (userDocSnapshot.exists) {
          print('snapshot exist');

          final userData = userDocSnapshot.data();
          print(userData);

          if (userData != null && userData.containsKey('tasks')) {
            final tasksList = userData['tasks'] as List<dynamic>;

            if (tasksList != null) {
              return tasksList.map((taskData) {
                print(taskData);
                return Task.fomJson(taskData); // Use your fromJson method
              }).toList();
            }
          }
        }
      }
    } catch (e) {
      // Handle errors, e.g., print or throw an exception
      print('Error fetching tasks: $e');
    }

    return []; // Return an empty list if there are no tasks or an error occurs
  }
}
