// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'package:todoey_app/navigation/navigation_page_view.dart';
import 'package:todoey_app/reuseableComponents/email_field_widget.dart';
import 'package:todoey_app/reuseableComponents/password_field_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../reuseableComponents/flutter_toast.dart';

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
      backgroundColor: Colors.lightBlueAccent,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Todo App',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              EmailTextField(
                onChanged: (newValue) {
                  email = newValue;
                },
              ),
              SizedBox(height: 10.h),
              PasswordTextField(
                onChanged: (newValue) {
                  password = newValue;
                },
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  // Add login logic here
                  signIn();
                },
                child: const Text('Login'),
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
        // Sign-in was successful
        final isAdmin = await checkAdminStatus(user.uid);

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyPageView(isAdmin: isAdmin)),
        );
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
      print("Error checking admin status: $e");
      return false;
    }
  }
}
