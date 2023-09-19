import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoey_app/widgets/custom_dialogue.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('No data loaded');
            return const CircularProgressIndicator(); // Show a loading indicator
          }
          final users = snapshot.data!.docs; // List of user documents
          List<Widget> userListWidgets = [];

          for (var user in users) {
            final userData = user.data();
            final userName =
                userData['name'] ?? 'Unknown'; // Display the user's name
            final userEmail = userData['email'] ?? 'Unknown';

            userListWidgets.add(
              GestureDetector(
                onTap: () {
                  // Pass the user reference to the UserOptionsDialog
                  final userReference = user.reference;
                  showDialog(
                    context: context,
                    builder: (context) => UserOptionsDialog(
                      userReference: userReference,
                    ),
                  );
                },
                child: ListTile(
                  title: Text(userName), // Display the user's name here
                  subtitle: Text(userEmail),
                  trailing: const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                ),
              ),
            );
          }

          return ListView(
            children: userListWidgets,
          );
        },
      ),
    );
  }
}
