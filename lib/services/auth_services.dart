import 'package:firebase_auth/firebase_auth.dart';

class AuthServives {
  static final _auth = FirebaseAuth.instance;

  static void logout() {
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
