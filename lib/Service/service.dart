import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (kDebugMode) {
        print("User: ${userCredential.user}");
      }

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return null;
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (kDebugMode) {
        print("User: ${userCredential.user}");
      }

      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  get currentUser => _auth.currentUser;
}