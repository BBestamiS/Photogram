import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/services/databasemanager.dart';
import 'package:photogram/services/imagemanager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  _SavedLocState createState() => _SavedLocState();
}

class _SavedLocState extends State<Ads> {
  String? downUrl;
  File? file;
  UploadTask? task;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);

    final fileName = file != null ? basename(file!.path) : 'Dosya seçilmedi!';
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(file ?? File("")),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  selectFile();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.red,
                  child: Center(
                    child: Text("dosya seç"),
                  ),
                ),
              ),
              Text(fileName),
              GestureDetector(
                onTap: () {
                  uploadFile();
                },
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.red,
                  child: Center(
                    child: Text("dosya yükle"),
                  ),
                ),
              ),
              task != null ? buildUploadStatus(task!) : Container(),
              GestureDetector(
                onTap: () async {},
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.red,
                  child: Center(
                    child: Text("dosya yükle"),
                  ),
                ),
              ),
              // FutureBuilder(
              //   future: posts.doc(authService.getUser()).get(),
              //   builder: (BuildContext context,
              //       AsyncSnapshot<DocumentSnapshot> snapshot) {
              //     if (snapshot.hasError) {
              //       return Text("Something went wrong");
              //     }

              //     if (snapshot.hasData && !snapshot.data!.exists) {
              //       return Text("Document does not exist");
              //     }

              //     if (snapshot.connectionState == ConnectionState.done) {
              //       Map<String, dynamic> data =
              //           snapshot.data!.data() as Map<String, dynamic>;
              //       return Text(
              //           "Media URL : ${data['']}");
              //     }

              //     return Text("loading");
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;
    final destination = Uuid().v4();

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    DatabaseManager().addPost(urlDownload, destination, "", "");
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
