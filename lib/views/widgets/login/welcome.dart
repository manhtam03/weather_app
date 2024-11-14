// import 'package:weather_app/views/homepage.dart';
import 'package:weather_app/views/screen/homepage.dart';
import 'package:weather_app/views/widgets/login/sign_up.dart';
import 'package:weather_app/views/widgets/login/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return HomePage();
          return const HomePage();
        } else {
          return Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                          },
                          child: const Text(
                            "Welcome",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "hello!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/welcome.png")
                          )
                      ),
                    ),

                    Column(
                      children: <Widget>[
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SigninPage()));
                          },
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          ),
                        ),

                        const SizedBox(height:20),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                          },
                          color: const Color(0xff0095FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),

                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );

  }
}