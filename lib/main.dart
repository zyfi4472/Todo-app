import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoey_app/cubit/task/cubit/task_cubit.dart';
import 'package:todoey_app/data/repository/tasks_repo.dart';
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
  // Create an instance of TaskRepo
  final TaskRepo taskRepo = TaskRepository();

  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    await getSharedPreferanceValues();
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(taskRepo),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Set the navigatorKey
        home: FutureBuilder<bool>(
          future: Future.value(
              widget.isAdmin ?? false), // Use the isAdmin value directly
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While checking admin status, show a loading indicator
              return const Center(child: CircularProgressIndicator());
            } else {
              // Use the null-aware operator to provide a default value
              final isAdmin = widget.isAdmin ?? false;

              // Return either MyPageView or LoginScreen based on the conditions
              return ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (_, child) {
                  return MaterialApp(
                    home: isAdmin ? const MyPageView() : const LoginScreen(),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void whereToGo() async {
    if (!isLoggedInGlobal) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyPageView(),
        ),
      );
    }
  }

  getSharedPreferanceValues() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(isLoggedInKey);
    var isAdmin = sharedPref.getBool(isAdminKey);
    var userId = sharedPref.getString(userIdKey);

    sharedPrefGlobal = sharedPref;
    isLoggedInGlobal = isLoggedIn ?? false;
    isAdminGlobal = isAdmin ?? false;
    userIdGlobal = userId ?? 'null';

    print('is Logged In : $isLoggedInGlobal');
    print('user id : $userIdGlobal');
    print('is Admin : $isAdminGlobal');
  }
}
