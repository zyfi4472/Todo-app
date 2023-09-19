import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todoey_app/authetication/authentication.dart';
import 'package:todoey_app/reuseableComponents/email_field_widget.dart';
import 'package:todoey_app/reuseableComponents/flutter_toast.dart';
import 'package:todoey_app/reuseableComponents/password_field_widget.dart';
import 'package:todoey_app/screens/login/login_screen.dart';

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
              const Text(
                'Create new user',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 10),
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
              SizedBox(
                width: 200,
                height: 50,
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
      // print('all fields are provided');

      try {
        final auth = Authentication();
        final newUser = await auth.CreateUser(email!, password!, name!);

        // ignore: unnecessary_null_comparison
        if (newUser != null) {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
          // print('SignUp successful');
        } else {
          // Handle the case where newUser is null
          showFlutterToast("Sign-up failed. Please try again.");
        }
      } catch (error) {
        // Sign-Up failed, handle the error here.
        showFlutterToast("Sign-up failed. $error");
      }

      setState(() {
        showSpiner = false;
        email = null;
        password = null;
      });
    }
  }
}
