import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class DatabaseManager {
  final _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();

  Future<void> addUser(String name, String surName, String nname, String uid) {
    CollectionReference users = _firestore.collection('users');
    return users
        .doc(uid)
        .set({
          'mediaUrl': null,
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

  Future<void> updateUser(
      String name, String surName, String nname, String uid, mediaUrl) {
    CollectionReference users = _firestore.collection('users');

    return users
        .doc(uid)
        .update({
          'mediaUrl': mediaUrl,
          'username': nname,
          'name': name,
          'surname': surName,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> addPost(
    String mediaUrl,
    String postId,
    String locId,
    String uniqLocId,
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
          'locId': locId,
          'uniqLocId': uniqLocId,
          'timestamp': timestamp,
          'uid': 'uid',
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add posts: $error"));
  }

  Future<void> addSavedLocs(
    List location,
    String description,
  ) {
    String postId = Uuid().v4();
    final auth.User? user = _firebaseAuth.currentUser;
    final uid = user!.uid;
    CollectionReference savedlocs = _firestore.collection('savedlocs');
    return savedlocs
        .doc(uid)
        .collection("userlocs")
        .doc(postId)
        .set({
          'Lat': location[1].latitude,
          'Lng': location[1].longitude,
          'Adress': location[0],
          'subAdministrativeArea': location[2],
          'administrativeArea': location[3],
          'name': location[4],
          'street': location[5],
          'isoCountryCode': location[6],
          'postalCode': location[7],
          'locality': location[8],
          'subLocality': location[9],
          'thoroughfare': location[10],
          'subThoroughfare': location[11],
          'description': description,
          'timestamp': timestamp,
          'postId': postId,
          'uid': uid,
        })
        .then((value) => print("Loc Added"))
        .catchError((error) => print("Failed to add location: $error"));
  }

  Future<void> addUniqLoc(List location, String postId, String uid) {
    CollectionReference uniqlocs = _firestore.collection('uniqlocs');
    return uniqlocs
        .doc(postId)
        .set({
          'Lat': location[1],
          'Lng': location[2],
          'Adress': location[0],
          'subAdministrativeArea': location[3],
          'administrativeArea': location[4],
          'name': location[5],
          'street': location[6],
          'isoCountryCode': location[7],
          'postalCode': location[8],
          'locality': location[9],
          'subLocality': location[10],
          'thoroughfare': location[11],
          'subThoroughfare': location[12],
          'timestamp': timestamp,
          'postId': postId,
          'uid': uid,
        })
        .then((value) => print("uniqLoc Added"))
        .catchError((error) => print("Failed to add uniq location: $error"));
  }

  Future<void> addLocs(List location, String postId, String uid) {
    CollectionReference locs = _firestore.collection('locs');
    return locs
        .doc(postId)
        .set({
          'Lat': location[1],
          'Lng': location[2],
          'Adress': location[0],
          'subAdministrativeArea': location[3],
          'administrativeArea': location[4],
          'name': location[5],
          'street': location[6],
          'isoCountryCode': location[7],
          'postalCode': location[8],
          'locality': location[9],
          'subLocality': location[10],
          'thoroughfare': location[11],
          'subThoroughfare': location[12],
          'timestamp': timestamp,
          'locId': postId,
          'uid': uid,
        })
        .then((value) => print("Loc Added"))
        .catchError((error) => print("Failed to add location: $error"));
  }
}
