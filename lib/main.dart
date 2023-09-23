import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoey_app/firebase_options.dart';
import 'package:todoey_app/navigation/navigation_page_view.dart';
import 'package:todoey_app/views/login/login_screen.dart';

import 'cubit/task_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Get the current user
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAdminStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking admin status, show a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else {
          // Check if user is not null and isAdmin is true
          final isAdmin = user != null && snapshot.data == true;

          if (user != null) {
            // If isAdmin is true, show the MyPageView
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, child) {
                return ChangeNotifierProvider(
                  create: (context) => TaskData(),
                  child: MaterialApp(
                    home: MyPageView(isAdmin: isAdmin),
                  ),
                );
              },
            );
          }
          // Default return when no condition matches
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return ChangeNotifierProvider(
                create: (context) => TaskData(),
                child: const MaterialApp(
                  home: LoginScreen(),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<bool> checkAdminStatus() async {
    // Reference to the user's document in Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    // Get the user's data from Firestore
    final userData = await userDocRef.get();

    if (!userData.exists) {
      // User document doesn't exist in Firestore
      return false;
    }

    // Check the isAdmin field
    final isAdmin = userData.data()?['isAdmin'] ?? false;

    return isAdmin;
  }
}
