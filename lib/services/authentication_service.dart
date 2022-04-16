import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:photogram/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photogram/services/databasemanager.dart';

class AuthenticationService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  getUser() {
    if (_firebaseAuth.currentUser != null) {
      final auth.User? user = _firebaseAuth.currentUser;
      final uid = user!.uid;
      return uid;
    }
  }

  User? _userFormFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    print('******************************************');
    print(user.uid);
    print(user.email);
    return User(user.uid, user.email);
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFormFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFormFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String surName,
    String nname,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await DatabaseManager().addUser(name, surName, nname, credential.user!.uid);
    return _userFormFirebase(credential.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
  // final FirebaseAuth _firebaseAuth;
  // AuthenticationService(this._firebaseAuth);

  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Future<String?> signIn(String email, String password) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     return 'Signed in';
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }

  // Future<String?> signUp(String email, String password) async {
  //   try {
  //     await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return 'Signed up';
  //   } on FirebaseAuthException catch (e) {
  //     return e.message;
  //   }
  // }
}
