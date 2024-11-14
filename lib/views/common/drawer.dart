import 'package:flutter/material.dart';
import 'package:weather_app/views/widgets/login/welcome.dart';
import 'package:weather_app/firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
            ],
            stops: [0.5, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            ListTile(
              title: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Quản lý vị trí",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Welcome()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.6),
                ),
                child: const Text(
                  "Đăng xuất",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}