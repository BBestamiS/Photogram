import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseManager {
  final _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();

  Future<void> addUser(String name, String surName, String nname, String uid) {
    CollectionReference users = _firestore.collection('users');
    return users
        .doc(uid)
        .set({
          'username': nname,
          'name': name,
          'surname': surName,
          'follow': 0,
          'followers': 0,
          'timestamp': timestamp,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addPost(
    String mediaUrl,
    String postId,
  ) {
    final auth.User? user = _firebaseAuth.currentUser;
    final uid = user!.uid;
    CollectionReference posts = _firestore.collection('posts');
    return posts
        .doc(uid)
        .collection("userPosts")
        .doc(postId)
        .set({
          'mediaUrl': mediaUrl,
          'postId': postId,
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
