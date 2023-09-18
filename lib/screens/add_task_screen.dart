import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String newTaskTitle = '';

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            TextButton(
              onPressed: () async {
                // Check if the user is authenticated
                if (user != null) {
                  // Reference to the user's tasks sub-collection
                  final userDocRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid);

                  // Update the user's document with the new task
                  await userDocRef.update({
                    'tasks': FieldValue.arrayUnion([
                      {
                        'title': newTaskTitle,
                      }
                    ])
                  });

                  // Notify the local task list (Provider)
                  Provider.of<TaskData>(context, listen: false)
                      .fetchTasksFromFirestore();

                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
