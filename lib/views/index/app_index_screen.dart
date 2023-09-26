import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoey_app/globals.dart';
import 'package:todoey_app/services/local_auth_service.dart';
import '../../cubit/task_data.dart';
import '../../widgets/tasks_list.dart';
import '../login/login_screen.dart';

class AppIndexScreen extends StatefulWidget {
  const AppIndexScreen({super.key});
  @override
  State<AppIndexScreen> createState() => _AppIndexScreenState();
}

class _AppIndexScreenState extends State<AppIndexScreen> {
  late Future<void> _initializeTaskData;
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    // Call fetchAndSetTasks before displaying the screen
    _initializeTaskData =
        Provider.of<TaskData>(context, listen: false).fetchAndSetTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: FutureBuilder<void>(
        future: _initializeTaskData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Todoey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0.sp,
                              fontWeight: FontWeight.w700,
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
                              radius: 25.0.r,
                              child: Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 25.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       final authenticate = await LocalAuth.authenticate();
                      //       setState(() {
                      //         authenticated = authenticate;
                      //       });
                      //     },
                      //     child: const Text('Authenticate')),
                      // if (authenticated) const Text('Local auth successful'),
                      // if (authenticated)
                      //   ElevatedButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           authenticated = false;
                      //         });
                      //       },
                      //       child: const Text('Cancel auth')),
                      SizedBox(height: 10.h),
                      Text(
                        '  You have ${Provider.of<TaskData>(context).taskCount} Tasks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
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
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            );
          }
        },
      ),
    );
  }

  void resetAppState(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    Provider.of<TaskData>(context, listen: false).clearTasks();
    auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
    sharedPrefGlobal.clear();
  }
}
