import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/services/databasemanager.dart';
import 'package:photogram/services/imagemanager.dart';
import 'package:photogram/share/instantloc.dart';
import 'package:photogram/share/savedloc.dart';
import 'package:uuid/uuid.dart';
import 'package:rive/rive.dart' as riv;

class ShareImage extends StatefulWidget {
  ShareImage(this.locinfos, this.file, this.page);
  Map<String, dynamic> locinfos;
  File file;
  int page;
  @override
  _ShareImage createState() => _ShareImage();
}

class _ShareImage extends State<ShareImage> {
  String? downUrl;
  File? file;
  bool? isItFirst;
  var tmp = 1;
  UploadTask? task;
  @override
  Widget build(BuildContext context) {
    if (tmp == 1) {
      file = widget.file;
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final _firestore = FirebaseFirestore.instance;
    CollectionReference _users = _firestore.collection('users');
    final Stream<QuerySnapshot> _uniqlocs = _firestore
        .collection('uniqlocs')
        .where('administrativeArea',
            isEqualTo: widget.locinfos['administrativeArea'].toString())
        .where('postalCode',
            isEqualTo: widget.locinfos['postalCode'].toString())
        .where('subAdministrativeArea',
            isEqualTo: widget.locinfos['subAdministrativeArea'].toString())
        .where('locality', isEqualTo: widget.locinfos['locality'].toString())
        .where('subLocality',
            isEqualTo: widget.locinfos['subLocality'].toString())
        .where('thoroughfare',
            isEqualTo: widget.locinfos['thoroughfare'].toString())
        .snapshots();

    return Scaffold(
      body: Stack(
        children: [
          bg(
            height,
            width,
            Color.fromRGBO(225, 135, 135, 1),
            Color.fromRGBO(226, 189, 58, 1),
          ),
          Container(
            color: Color.fromRGBO(255, 255, 255, 0.25),
          ),
          SafeArea(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      child: StreamBuilder(
                        stream: _uniqlocs,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Terslik Oluştu!');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              width: width * 1,
                              child: Center(
                                child: Container(),
                              ),
                            );
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            isItFirst = true;

                            return Stack(
                              children: [
                                Container(
                                  width: width * 1,
                                  child: Center(
                                    child: riv.RiveAnimation.asset(
                                      'animations/confetti.riv',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 1,
                                  child: Center(
                                    child: Text(
                                        "Bu konumda ilk sen paylaşım yapacaksın!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.sora(
                                          textStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            );
                          }
                          Map<String, dynamic>? data;
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                            data = document.data()! as Map<String, dynamic>;
                          }).toList();
                          isItFirst = false;
                          if (data!['uid'] ==
                              AuthenticationService().getUser()) {
                            return Stack(
                              children: [
                                Container(
                                  width: width * 1,
                                  child: Center(
                                    child: riv.RiveAnimation.asset(
                                      'animations/confetti.riv',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 1,
                                  child: Center(
                                    child: Text(
                                        "Bu konumda ilk sen paylaşım yaptın!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.sora(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                          ),
                                        )),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              width: width * 1,
                              child: FutureBuilder<DocumentSnapshot>(
                                future: _users.doc(data!['uid']).get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }

                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return Text("Document does not exist");
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> data = snapshot.data!
                                        .data() as Map<String, dynamic>;
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Center(
                                              child: AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            183,
                                                            174,
                                                            174,
                                                            0.25),
                                                        blurRadius: 5,
                                                        spreadRadius: 1,
                                                        offset: Offset(0, 0),
                                                      ),
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.25),
                                                        blurRadius: 5,
                                                        spreadRadius: 1,
                                                        offset: Offset(0, 0),
                                                      ),
                                                    ],
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: getProfilePic(
                                                    data['mediaUrl'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width * 1,
                                          child: Center(
                                            child: Text(
                                                "Bu konumda ilk sen paylaşımı " +
                                                    data['username']
                                                        .toString() +
                                                    " yaptı",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.sora(
                                                  textStyle: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    getImage(width),
                    GestureDetector(
                      onTap: () async {
                        uploadFile();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedLoc()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: width * 0.75,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(118, 240, 43, 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Dosyayı yükle",
                          style: GoogleFonts.roboto(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    task != null ? buildUploadStatus(task!) : Container(),
                  ],
                ),
                Align(
                  alignment: Alignment(-0.95, -1),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.page == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedLoc(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstantLoc(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 50,
                      height: 50,
                      child: Image(
                        image: AssetImage("pics/back.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
    final locId = Uuid().v4();
    final uniqLocId = Uuid().v4();
    String userId = AuthenticationService().getUser();
    List location = [];
    location.add(widget.locinfos['Adress'].toString());
    location.add(widget.locinfos['Lat'].toString());
    location.add(widget.locinfos['Lng'].toString());
    location.add(widget.locinfos['subAdministrativeArea'].toString());
    location.add(widget.locinfos['administrativeArea'].toString());
    location.add(widget.locinfos['name'].toString());
    location.add(widget.locinfos['street'].toString());
    location.add(widget.locinfos['isoCountryCode'].toString());
    location.add(widget.locinfos['postalCode'].toString());
    location.add(widget.locinfos['locality'].toString());
    location.add(widget.locinfos['subLocality'].toString());
    location.add(widget.locinfos['thoroughfare'].toString());
    location.add(widget.locinfos['subThoroughfare'].toString());
    if (isItFirst == true) {
      DatabaseManager().addUniqLoc(location, uniqLocId, userId);
      DatabaseManager().addLocs(location, locId, userId);
    } else {
      DatabaseManager().addLocs(location, locId, userId);
    }
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    if (isItFirst == true) {
      DatabaseManager().addPost(urlDownload, destination, locId, uniqLocId);
    } else {
      DatabaseManager().addPost(urlDownload, destination, locId, "");
    }
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

  Container bg(
      double height, double width, Color first_color, Color second_color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            first_color,
            second_color,
          ],
        ),
      ),
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
    );
  }

  getImage(width) {
    return Expanded(
      child: GestureDetector(
        onLongPress: () {
          tmp = 2;
          selectFile();
        },
        child: Container(
          margin: EdgeInsets.only(top: 20),
          width: width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        file ?? File(""),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  "*Resmi değiştirmek için, resme basılı tutun",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getProfilePic(mediaUrl) {
    if (mediaUrl == null) {
      return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: riv.RiveAnimation.asset(
          "animations/runner_boy.riv",
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(mediaUrl),
          ),
        ),
      );
    }
  }
}
