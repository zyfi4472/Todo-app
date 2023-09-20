import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'package:todoey_app/reuseableComponents/email_field_widget.dart';
import 'package:todoey_app/reuseableComponents/flutter_toast.dart';
import 'package:todoey_app/reuseableComponents/password_field_widget.dart';

import '../login/login_screen.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  String? email, password, name;
  bool showSpiner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Create new user',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  onChanged: (newValue) {
                    name = newValue;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
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
              SizedBox(
                width: 200.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    createUser();
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createUser() async {
    if (email?.isEmpty != false ||
        password?.isEmpty != false ||
        name?.isEmpty != false) {
      setState(() {
        showSpiner = false;
      });
      showFlutterToast("Please fill in all fields");
    } else {
      try {
        final auth = FirebaseAuthentication();
        final newUser = await auth.CreateUser(email!, password!, name!);

        if (newUser != null) {
          showFlutterToast('User created successfully');
        } else {
          showFlutterToast("Sign-up failed. Please try again.");
        }
      } catch (error) {
        showFlutterToast("Sign-up failed. $error");
      }

      // Delay the reset of email and password to null
      await Future.delayed(
          const Duration(milliseconds: 200)); // Adjust the delay time as needed

      setState(() {
        email = null;
        password = null;
        showSpiner = false;
      });
    }
  }
}
