import 'dart:io';
import 'package:weather_app/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weather_app/views/widgets/login/welcome.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyDj-Q4Dt-dt-MVMHLQhZEI-NKOpqJMmKg8',
          appId: '1:920866101325:android:a4e698e37557565b60a404',
          messagingSenderId: '920866101325', 
          projectId: 'weatherapp-22e4e',
        ))
      : await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
