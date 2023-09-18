import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> CreateUser(String email, String password, String name) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser.user != null) {
        // User has been created, now store additional user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.user!.uid)
            .set({
          'name': name,
          'email': email,
          'isAdmin':false,
          // Add other user properties here
        });

        return newUser.user;
      } else {
        return null;
      }
    } catch (error) {
      // Handle sign-up errors
      // print('Sign-up error: $error');

      return null;
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      // Handle sign-in errors
      print('Sign-in error: $error');
      return null;
    }
  }
}
