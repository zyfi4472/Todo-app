import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../addTask/add_task_screen.dart';

class UserDetailsScreen extends StatelessWidget {
  final DocumentReference userDocReference;

  const UserDetailsScreen({Key? key, required this.userDocReference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User Details')),
        // automaticallyImplyLeading:
        //     false, // to remove the back arrow from appbar
        actions: [
          // Add task button in the app bar
          GestureDetector(
            onTap: () {
              // Open the AddTaskScreen as a bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: AddTaskScreen(
                      userDocReference: userDocReference,
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.add_circle_outline,
                size: 30.r,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDocReference.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Display a message if the user document is not found
            return const Center(
              child: Text('User document not found.'),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final tasks = (userData['tasks'] as List<dynamic>?) ?? [];
          final userName = userData['name'] as String;

          if (tasks.isEmpty) {
            // Display a message if no tasks are found
            return const Center(
              child: Text('No tasks found.'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15),
                child: Center(
                  child: Text(
                    userName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index] as Map<String, dynamic>;
                    final taskTitle = task['title'] ?? 'No Title';
                    final isDone = task['isDone'] ?? false;

                    return Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      child: ListTile(
                        title: Text(taskTitle),
                        trailing: Checkbox(
                          value: isDone,
                          onChanged: (newValue) {
                            // Update the 'isDone' status in the user document's "tasks" array

                            // tasks[index]['isDone'] = newValue;

                            userDocReference.update({'tasks': tasks});
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
