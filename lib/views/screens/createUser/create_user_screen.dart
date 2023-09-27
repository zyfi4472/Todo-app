import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../cubit/authentication/createUser/cubit/create_user_cubit.dart';
import '../../widgets/flutter_toast.dart';
import '../../widgets/input_field_widget.dart';

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
        backgroundColor: const Color(0XFFFFFFFF),
        body: BlocListener<CreateUserCubit, CreateUserState>(
          listener: (context, state) async {
            if (state is CreateUserSuccess) {
              showFlutterToast("User Created Successfully");
            } else if (state is CreateUserError) {
              // Handle  error and show a toast or error message
              showFlutterToast("User creation unsuccessful. Please try again.");
            }
          },
          child: ModalProgressHUD(
            inAsyncCall: showSpiner,
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
                    'Create new user',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0XFF393349),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  InputField(
                    heading: 'Full name',
                    labelText: 'Wafiullah Salarzai',
                    icon: const Icon(Icons.person),
                    onChanged: (newValue) {
                      name = newValue;
                    },
                  ),
                  SizedBox(height: 10.h),
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
                            createUser();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0.r), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text('Create'),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void createUser() async {
    if (email?.isEmpty != false) {
      showFlutterToast("Please fill in email field");
    } else if (password?.isEmpty != false) {
      showFlutterToast("Please fill in password field");
    } else if (name?.isEmpty != false) {
      showFlutterToast("Please fill in name field");
    } else {
      // Call the createUser method from the CreateUserCubit
      context.read<CreateUserCubit>().createUser(email!, password!, name!);

      // Delay the reset of email and password to null
      await Future.delayed(
        const Duration(seconds: 3), // Adjust the delay time as needed
      );

      setState(() {
        email = null;
        password = null;
        showSpiner = false;
      });
    }
  }
}
