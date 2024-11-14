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
    apiKey: "AIzaSyA2zodN5GACQsY3z07_BD700XjM3vOhlM8",
    authDomain: "weatherapp-22e4e.firebaseapp.com",
    projectId: "weatherapp-22e4e",
    storageBucket: 'weatherapp-22e4e.appspot.com',
    // storageBucket: "weatherapp-22e4e.firebasestorage.app",
    messagingSenderId: "920866101325",
    appId: "1:920866101325:web:9458e9c7e59b318a60a404",
    measurementId: "G-GHW3JEDJ82"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDj-Q4Dt-dt-MVMHLQhZEI-NKOpqJMmKg8',
    appId: '1:920866101325:android:a4e698e37557565b60a404',
    messagingSenderId: '920866101325',
    projectId: 'weatherapp-22e4e',
    storageBucket: 'weatherapp-22e4e.appspot.com',
  );
}