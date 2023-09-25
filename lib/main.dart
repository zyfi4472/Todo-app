import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey_app/firebase_options.dart';
import 'package:todoey_app/globals.dart';
import 'package:todoey_app/navigation/navigation_page_view.dart';
import 'package:todoey_app/views/login/login_screen.dart';
import 'cubit/task_data.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sharedPref = await SharedPreferences.getInstance();
  var isAdmin = sharedPref.getBool(isAdminKey);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskData(), // Replace with your actual data provider
      child: MyApp(isAdmin: isAdmin),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool? isAdmin;

  const MyApp({Key? key, this.isAdmin}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil here with the context argument
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return MaterialApp(
      navigatorKey: navigatorKey, // Set the navigatorKey
      home: FutureBuilder<bool>(
        future: checkAdminStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking admin status, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else {
            // final user = FirebaseAuth.instance.currentUser;

            // // Check if user is not null and isAdmin is true
            // final isAdmin = FirebaseAuth.instance.currentUser != null &&
            //     snapshot.data == true;

            // Use the null-aware operator to provide a default value
            final isAdmin = widget.isAdmin ?? false;

            // Return either MyPageView or LoginScreen based on the conditions
            return ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, child) {
                return ChangeNotifierProvider(
                  create: (context) => TaskData(),
                  child: MaterialApp(
                    home: isAdmin
                        ? MyPageView(isAdmin: isAdmin)
                        : const LoginScreen(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    var sharedPref = await SharedPreferences.getInstance();

    String? userId = sharedPref.getString(userIdKey);

    if (user == null) {
      return false;
    }

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final userData = await userDocRef.get();

    if (!userData.exists) {
      return false;
    }

    return userData.data()?['isAdmin'] ?? false;
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(isLoggedInKey);
    var isAdmin = sharedPref.getBool(isAdminKey);

    if (isLoggedIn != null) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => isLoggedIn
              ? MyPageView(isAdmin: isAdmin ?? false)
              : const LoginScreen(),
        ),
      );
    } else {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }
}
