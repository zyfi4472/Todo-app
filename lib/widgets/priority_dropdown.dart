import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todoey_app/globals.dart'; // Import globals.dart

class MyDropdownWidget extends StatefulWidget {
  const MyDropdownWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyDropdownWidgetState createState() => _MyDropdownWidgetState();
}

class _MyDropdownWidgetState extends State<MyDropdownWidget> {
  // Initialize with a valid option
  // static String selectedValue = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: const Color(0XFFFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              // spreadRadius: 2, // Spread radius
              blurRadius: 5.r, // Blur radius
              offset: const Offset(0, 3), // Offset in the (x, y) direction
            ),
          ],
        ),
        width: 130.w,
        height: 30.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: selectedValue, // Use selectedValue from globals.dart
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'High',
                child: Text(
                  'High',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              DropdownMenuItem(
                value: 'Medium',
                child: Text(
                  'Medium',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              DropdownMenuItem(
                value: 'Low',
                child: Text(
                  'Low',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ), // Icon to display
            underline: Container(), // Remove the underline
            isExpanded: true, // Allow the dropdown to expand horizontally
            dropdownColor: Colors.white, // Change this color
          ),
        ),
      ),
    );
  }
}
