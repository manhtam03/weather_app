import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUserWithEmailAndPassword(String strEmail, String strPassword) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: strEmail, password: strPassword);
      return credential.user;
    } catch (err) {
      print("Co loi tao user: $err");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(String strEmail, String strPassword) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: strEmail, password: strPassword);
      return credential.user;
    } catch (err) {
      print("Co loi dang nhap: $err");
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print("Co loi dang xuat: $err");
    }
  }
}