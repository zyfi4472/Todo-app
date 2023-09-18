import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User List')),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator(); // Show a loading indicator
          }
          final users = snapshot.data!.docs; // List of user documents
          List<Widget> userListWidgets = [];

          for (var user in users) {
            final userData = user.data();
            final userName = userData['name'] ?? 'Unknown';
            final userEmail = userData['email'] ?? 'Unknown';

            userListWidgets.add(
              ListTile(
                title: Text(userName),
                subtitle: Text(userEmail),
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
