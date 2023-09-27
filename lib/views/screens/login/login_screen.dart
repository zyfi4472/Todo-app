// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'package:todoey_app/globals.dart';
import 'package:todoey_app/views/navigation/navigation_page_view.dart';
import 'package:todoey_app/views/widgets/input_field_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../widgets/flutter_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email, password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                width: 120,
                height: 120,
                'images/todoLogo.png',
              ),
              Text(
                'Todo App',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF393349),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0XFF393349),
                ),
              ),
              SizedBox(height: 20.h),
              InputField(
                heading: 'Email',
                labelText: 'user@email.com',
                icon: const Icon(Icons.email),
                onChanged: (newValue) {
                  email = newValue;
                },
              ),
              SizedBox(height: 10.h),
              InputField(
                icon: const Icon(Icons.lock_outline_rounded),
                heading: 'Password',
                labelText: '********',
                obscureText: true,
                onChanged: (newValue) {
                  password = newValue;
                },
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0.r), // Adjust the radius as needed
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    setState(() {
      showSpinner = true;
    });

    if (email?.isEmpty != false || password?.isEmpty != false) {
      setState(() {
        showSpinner = false;
      });
      showFlutterToast("Please fill in both email and password fields");
    } else {
      final auth = FirebaseAuthentication();
      final user = await auth.signIn(email!, password!);

      if (user != null) {
        String userId = user.uid;

        // Reference to the user's tasks sub-collection
        // final userDocRef =
        //     FirebaseFirestore.instance.collection('users').doc(userId);

        // Sign-in was successful
        final isAdmin = await checkAdminStatus(userId);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyPageView(),
          ),
        );

        sharedPrefGlobal.setBool(isLoggedInKey, true);
        sharedPrefGlobal.setString(userIdKey, userId);
        sharedPrefGlobal.setBool(isAdminKey, isAdmin);

        isLoggedInGlobal = true;
        userIdGlobal = userId;
        isAdminGlobal = isAdmin;
        // userDocReferanceGlobal = userDocRef;
      } else {
        // Handle sign-in failure
        showFlutterToast("Login unsuccessful. Please try again.");
      }

      setState(() {
        showSpinner = false;
        email = null;
        password = null;
      });
    }
  }

  Future<bool> checkAdminStatus(String userId) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      final userData = await userDocRef.get();

      if (userData.exists) {
        final isAdmin = userData.data()?['isAdmin'] ?? false;
        return isAdmin;
      } else {
        return false; // User document not found
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking admin status: $e");
      }
      return false;
    }
  }
}
