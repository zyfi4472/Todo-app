import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/task_data.dart';
import '../../widgets/tasks_list.dart';
import '../login/login_screen.dart';

// ignore: must_be_immutable
class AppIndexScreen extends StatefulWidget {
  const AppIndexScreen({super.key});
  @override
  State<AppIndexScreen> createState() => _AppIndexScreenState();
}

class _AppIndexScreenState extends State<AppIndexScreen> {
  late Future<void> _initializeTaskData;

  @override
  void initState() {
    super.initState();

    // Initialize _initializeTaskData with the async initialization
    _initializeTaskData =
        Provider.of<TaskData>(context, listen: false).fetchTasksFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: FutureBuilder<void>(
        future: _initializeTaskData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Initialization is complete, you can safely access the TaskData provider now
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    left: 30.0,
                    right: 30.0,
                    bottom: 30.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30.0.r,
                            child: Icon(
                              Icons.list,
                              size: 30.0.r,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                print('signout clicked');
                              }
                              resetAppState(
                                  context); // Call the reset method when signing out
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30.0.r,
                              child: Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 30.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0.h),
                      Text(
                        'Todoey',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${Provider.of<TaskData>(context).taskCount} Tasks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0.r),
                        topRight: Radius.circular(20.0.r),
                      ),
                    ),
                    child: const TasksList(),
                  ),
                ),
              ],
            );
          } else {
            // Return a loading indicator or some other widget while waiting for initialization
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Method to reset the app's state
  void resetAppState(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // Clear any app-specific data or state here
    Provider.of<TaskData>(context, listen: false).clearTasks();

    // Sign out the user
    _auth.signOut();

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
