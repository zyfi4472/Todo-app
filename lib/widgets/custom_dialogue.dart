import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoey_app/screens/addTask/add_task_screen.dart';
import 'package:todoey_app/screens/showTasks/show_tasks.dart';

class UserOptionsDialog extends StatelessWidget {
  final DocumentReference userReference;

  const UserOptionsDialog({Key? key, required this.userReference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowTasksScreen(
                    userReference: userReference,
                  ),
                ),
              );
            },
            child: const Text('View Tasks'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Add a new task for the selected user
              Navigator.pop(context); // Close the dialog
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: AddTaskScreen(
                      userReference: userReference,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
