import 'package:flutter/material.dart';
import 'package:todoey_app/navigation/bottom_nav.dart';
import 'package:todoey_app/screens/createUser/create_user.dart';
import 'package:todoey_app/screens/index/app_index_screen.dart';
import 'package:todoey_app/screens/users/users.dart';

class MyPageView extends StatefulWidget {
  final bool isAdmin; // Add this variable to hold the isAdmin status

  const MyPageView(
      {super.key, required this.isAdmin}); // Pass isAdmin as a parameter

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
        visible:
            widget.isAdmin, // Use the isAdmin passed from the parent widget
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
