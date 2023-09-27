import 'package:flutter/material.dart';
import 'package:todoey_app/globals.dart';
import 'package:todoey_app/views/widgets/bottom_nav.dart';
import '../screens/createUser/create_user_screen.dart';
import '../screens/index/app_index_screen.dart';
import '../screens/users/users_screen.dart';

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
        children: const [
          AppIndexScreen(),
          UserListScreen(),
          CreateUserScreen(),
        ],
      ),
      bottomNavigationBar: Visibility(
        // Use the Visibility widget to conditionally show/hide the BottomNavBar
        visible: isAdminGlobal, // Use the isAdminGlobal variable
        child: BottomNavBar(
          currentIndex: _currentIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
