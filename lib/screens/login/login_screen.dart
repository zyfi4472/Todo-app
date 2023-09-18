// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'package:todoey_app/reuseableComponents/email_field_widget.dart';
import 'package:todoey_app/reuseableComponents/password_field_widget.dart';
import 'package:todoey_app/screens/signup_screen.dart';
import 'package:todoey_app/screens/tasks_screen.dart';
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
      // print('email and pass provided');

      final auth = Authentication();
      final user = await auth.signIn(email!, password!);

      if (user != null) {
        // Sign-in was successful
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksScreen(),
          ),
        );
        // print('Login successful');
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
              const Text(
                'Todo App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              EmailTextField(
                onChanged: (newValue) {
                  email = newValue;
                },
              ),
              const SizedBox(height: 10),
              PasswordTextField(
                onChanged: (newValue) {
                  password = newValue;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add login logic here
                  signIn();
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
