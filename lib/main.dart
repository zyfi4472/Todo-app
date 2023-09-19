import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todoey_app/firebase_options.dart';
import 'package:todoey_app/screens/login/login_screen.dart';

import 'models/task_data.dart';
import 'navigation/navigation_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  final user = FirebaseAuth.instance.currentUser;
  bool showSpiner = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAdminStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking admin status, show a loading indicator
          return const Center(child: CircularProgressIndicator());
          // You can replace this with any loading widget you prefer
        } else {
          // Check if user is not null and isAdmin is true
          final isAdmin = user != null && snapshot.data == true;

          if (user != null) {
            // if isAdmin is true, show the MyPageView
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

  // Your checkAdminStatus method remains unchanged

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
