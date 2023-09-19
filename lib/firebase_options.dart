// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDfVnJgiNRdDKojFwhpIFr1NQ9arw027HI',
    appId: '1:815757448387:web:f50ff985812aca0532fe76',
    messagingSenderId: '815757448387',
    projectId: 'todo-app-af32f',
    authDomain: 'todo-app-af32f.firebaseapp.com',
    storageBucket: 'todo-app-af32f.appspot.com',
    measurementId: 'G-H8EJRL951Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO09ZrL7dRpwCBb2cd2OiVY2s-1ugRAQs',
    appId: '1:815757448387:android:05cd5a477c6082c832fe76',
    messagingSenderId: '815757448387',
    projectId: 'todo-app-af32f',
    storageBucket: 'todo-app-af32f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOfb5ei7W0bgCNtcpVoHBBXl2W28arv0E',
    appId: '1:815757448387:ios:0998cab915993f1d32fe76',
    messagingSenderId: '815757448387',
    projectId: 'todo-app-af32f',
    storageBucket: 'todo-app-af32f.appspot.com',
    iosBundleId: 'com.example.todoeyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOfb5ei7W0bgCNtcpVoHBBXl2W28arv0E',
    appId: '1:815757448387:ios:28f5612503380caa32fe76',
    messagingSenderId: '815757448387',
    projectId: 'todo-app-af32f',
    storageBucket: 'todo-app-af32f.appspot.com',
    iosBundleId: 'com.example.todoeyApp.RunnerTests',
  );
}