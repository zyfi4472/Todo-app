import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowTasksScreen extends StatelessWidget {
  final DocumentReference userReference;

  const ShowTasksScreen({Key? key, required this.userReference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userReference.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('User document not found.'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final tasks = userData['tasks'] as List<dynamic>;

          if (tasks.isEmpty) {
            return const Center(
              child: Text('No tasks found.'),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index] as Map<String, dynamic>;
              final taskTitle = task['title'] ?? 'No Title';
              final isDone = task['isDone'] ?? false;

              return ListTile(
                title: Text(taskTitle),
                trailing: Checkbox(
                  value: isDone,
                  onChanged: (newValue) {
                    // Update the 'isDone' status in the user document's "tasks" array
                    // tasks[index]['isDone'] = newValue;
                    userReference.update({'tasks': tasks});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
