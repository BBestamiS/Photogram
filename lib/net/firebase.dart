import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(
    String userNName, String userName, String userSurname) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  users.add({
    'userNName': userNName,
    'userName': userName,
    'userSurName': userSurname,
    'uid': uid,
  });
  return;
}
