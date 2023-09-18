import 'package:flutter/material.dart';
import 'package:todoey_app/navigation/bottom_nav.dart';
import 'package:todoey_app/screens/tasks_screen.dart';
import 'package:todoey_app/screens/users/users.dart';

import '../screens/createUser/create_user.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyPageViewState createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onPageChanged(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          TasksScreen(),
          UserListScreen(),
          const CreateUserScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
