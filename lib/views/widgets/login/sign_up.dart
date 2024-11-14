import 'package:weather_app/views/widgets/login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app/firebase_auth/firebase_auth.dart';
import 'package:weather_app/views/widgets/login/sign_in.dart';

class SignupPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Welcome()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // child: GestureDetector(
          //   onTap: () {
          //     FocusScope.of(context).unfocus();
          //   },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Create an account, It's free ",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700]
                        ),
                      )
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      inputFile(controller: _emailController, label: "Email", validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Vui lòng nhập địa chỉ Email";
                        } else if(!value.contains("@")) {
                          return "Vui lòng nhập đúng định dạng email";
                        } else {
                          return null;
                        }
                      },),
                      inputFile(controller: _passwordController, label: "Mật khẩu", obscureText: true, validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Vui lòng nhập password";
                        } else if(value.length < 6) {
                          return "Vui lòng nhập đủ 6 kí tự password";
                        } else {
                          return null;
                        }
                      },),
                      inputFile(controller: _confirmpasswordController, label: "Xác nhận lại mật khẩu", obscureText: true, validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Vui lòng xác nhận password";
                        } else if(value != _passwordController.text) {
                          return "Mật khẩu xác nhận không khớp";
                        } else {
                          return null;
                        }
                      },),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () async {
                        if(_formKey.currentState!.validate()) {
                          User? user = await _auth.registerUserWithEmailAndPassword(
                              _emailController.text, _passwordController.text
                          );

                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Đã đăng ký thành công."),
                            ));

                            Navigator.push(context, MaterialPageRoute(builder: (context) => SigninPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Có lỗi đăng ký."),
                            ));
                          }
                        }

                      },
                      color: const Color(0xff0095FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Đăng ký",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Bạn đã có sẵn tài khoản?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SigninPage()));
                          },
                          child: const Text(
                            " Đăng nhập",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          )
                      )
                    ],
                  )
                ],
              ),
            ),
          // ),
        ),
      ),
    );
  }
}

Widget inputFile({label, obscureText = false, required TextEditingController controller, FormFieldValidator<String>? validator}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            )
        ),
      ),
      const SizedBox(height: 10,)
    ],
  );
}