// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../cubit/authentication/login/cubit/login_cubit.dart';
import '../../../globals.dart';
import '../../navigation/navigation_page_view.dart';
import '../../widgets/flutter_toast.dart';
import '../../widgets/input_field_widget.dart';

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
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccessState) {
            String userId = state.user.uid;

            // Sign-in was successful
            final isAdmin = await checkAdminStatus(userId);
            // Set user-related data in your global variables or preferences here
            sharedPrefGlobal.setBool(isLoggedInKey, true);
            sharedPrefGlobal.setString(userIdKey, userId);
            sharedPrefGlobal.setBool(isAdminKey, isAdmin);

            // Navigate to the next screen on successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyPageView(),
              ),
            );

            // ... other data
          } else if (state is LoginErrorState) {
            // Handle login error and show a toast or error message
            showFlutterToast("Login unsuccessful. Please try again.");
          }
        },
        child: ModalProgressHUD(
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
      // Call the login method from the LoginCubit
      context.read<LoginCubit>().login(email!, password!);

      // Clear the fields
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
