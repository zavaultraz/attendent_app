import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  //add note
  Future<void> addNote(String title, String imageUrl, String content) async {
    String? userId = _auth.currentUser!.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("notes")
          .add({
        "title": title,
        "imageUrl": imageUrl,
        "content": content,
        "userId": userId,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

//get note
  Stream<QuerySnapshot> getNotes() {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("notes")
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  //delete note
  Future<void> deleteNote(String noteId) async {
    String? userId = _auth.currentUser!.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("notes")
          .doc(noteId)
          .delete();
    }
  }

  //update note
  Future<void> updateNote(
      String noteId, String title, String content, String imageUrl) async {
    String? userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("notes")
        .doc(noteId)
        .update({
      "title": title,
      "imageUrl": imageUrl,
      "content": content,
    });
  }

  Future<void> forgotPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Email cannot be empty");
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send reset password");
    }
  }

  Future<void> loadProfile() async{
    String? userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(userId).get();
  }

  Future<void> updateProfile(
      String name, String lastname) async {
    String? userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({
      "name": name,
      "lastname": lastname,
    });
  }

  Future<void> UploadProfileImage(String imageUrl) async{
    String? userId = _auth.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profileImage' : imageUrl
    });
  }

  Future<void> verfyEmail()async{
    if(_auth.currentUser != null && !_auth.currentUser!.emailVerified){
      await _auth.currentUser!.sendEmailVerification();

    }
  }


}
