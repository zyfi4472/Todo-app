import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../userDetails/user_details_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('User List')),
        automaticallyImplyLeading:
            false, // to remove the back arrow from appbar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data();
              final userName = userData['name'] ?? 'Unknown';
              final userEmail = userData['email'] ?? 'Unknown';

              final userReference = users[index].reference;

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailsScreen(userReference: userReference),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                    ),
                    child: ListTile(
                      title: Text(userName),
                      subtitle: Text(userEmail),
                      trailing: Icon(
                        Icons.arrow_circle_right,
                        color: Colors.lightBlueAccent,
                        size: 30.sp,
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
