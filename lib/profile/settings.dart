import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/auth_screens/home.dart';
import 'package:photogram/main_map/find.dart';
import 'package:photogram/main_map/main_screen.dart';
import 'package:photogram/main_map/share.dart';
import 'package:photogram/profile/profile.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/services/databasemanager.dart';
import 'package:photogram/services/imagemanager.dart';
import 'package:photogram/share/shareimage.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as riv;
import 'package:uuid/uuid.dart';

// Color.fromRGBO(255, 255, 255, 0.4)

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  _ProfileSettings createState() => _ProfileSettings();
}

class _ProfileSettings extends State<ProfileSettings> {
  UploadTask? task;
  File? file;
  Future? userFuture;
  TextEditingController userNName = TextEditingController();
  TextEditingController userSurname = TextEditingController();
  TextEditingController userName = TextEditingController();
  @override
  void initState() {
    super.initState();
    userFuture = _getUser();
  }

  _getUser() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthenticationService().getUser())
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    // final _firestore = FirebaseFirestore.instance;
    // CollectionReference users = _firestore.collection('users');

    final authService = Provider.of<AuthenticationService>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            bg(
              height,
              width,
              Color.fromRGBO(225, 189, 135, 1),
              Color.fromRGBO(101, 58, 226, 1),
            ),
            FutureBuilder(
              future: userFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Bir şeyler ters gitti!"));
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Center(child: Text("Dökümana ulaşılamıyor!"));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return SafeArea(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            height: availableHeight * 0.5,
                            width: width,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          selectFile();
                                        },
                                        child: Container(
                                          width: width * 0.55,
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            child: Center(
                                              child: AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.25),
                                                        blurRadius: 7,
                                                        spreadRadius: 1,
                                                        offset: Offset(-9, -9),
                                                      ),
                                                      BoxShadow(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.25),
                                                        blurRadius: 5,
                                                        spreadRadius: 1,
                                                        offset: Offset(9, 9),
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
                                      ),
                                      Container(
                                        width: width * 0.6,
                                        child: Center(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: StreamBuilder<
                                                              QuerySnapshot>(
                                                          stream: DatabaseManager()
                                                              .getFollowerStream(
                                                                  AuthenticationService()
                                                                      .getUser()),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Something went wrong');
                                                            }

                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Container();
                                                            }

                                                            return Text(
                                                              snapshot
                                                                  .data!.size
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          126,
                                                                          181,
                                                                          166,
                                                                          1),
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        " takipçi",
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: StreamBuilder<
                                                              QuerySnapshot>(
                                                          stream: DatabaseManager()
                                                              .getFollowStream(
                                                                  AuthenticationService()
                                                                      .getUser()),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      QuerySnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Something went wrong');
                                                            }

                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Container();
                                                            }

                                                            return Text(
                                                              snapshot
                                                                  .data!.size
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        " takip",
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: availableHeight * 0.5,
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: width * 0.9,
                                    margin:
                                        EdgeInsets.only(top: 30, bottom: 15),
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "İsim",
                                              style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: TextFormField(
                                            controller: userName,
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                height: 1.4,
                                                color: Colors.black,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: data['name'],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * 0.85,
                                      padding: EdgeInsets.only(
                                          bottom: 5, left: 5, right: 5),
                                      child: Text(
                                        "Soyisim",
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: width * 0.9,
                                      margin: EdgeInsets.only(bottom: 15),
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                      child: Center(
                                        child: TextFormField(
                                          controller: userSurname,
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              height: 1.4,
                                              color: Colors.black,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: data['surname'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: width * 0.9,
                                      padding: EdgeInsets.only(
                                          bottom: 5, left: 5, right: 5),
                                      child: Text(
                                        "Kullanıcı Adı",
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: width * 0.9,
                                      margin: EdgeInsets.only(bottom: 15),
                                      color: Color.fromRGBO(255, 255, 255, 0.4),
                                      child: Center(
                                        child: TextFormField(
                                          controller: userNName,
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              height: 1.4,
                                              color: Colors.black,
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: data['username'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    updateFile(data['name'], data['surname'],
                                        data['username']);
                                  },
                                  child: Container(
                                    height: 50,
                                    color: Color.fromRGBO(255, 255, 255, 0.4),
                                    child: Center(
                                      child: Text("Kaydet"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return Center(
                  child: riv.RiveAnimation.asset(
                    'animations/delivery.riv',
                    fit: BoxFit.cover,
                    animations: ['Example'],
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment(-0.95, -1),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Profile(AuthenticationService().getUser()),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40),
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
    );
  }

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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future updateFile(name, surName, nname) async {
    String tmpName;
    String tmpSurname;
    String userId = AuthenticationService().getUser();
    String tmpNName;
    if (file == null) {
      print("file boş -------------------------------------");
      if (userName.text == "") {
        tmpName = name;
      } else {
        tmpName = userName.text;
      }
      if (userSurname.text == "") {
        tmpSurname = surName;
      } else {
        tmpSurname = userSurname.text;
      }
      if (userNName.text == "") {
        tmpNName = nname;
      } else {
        tmpNName = userNName.text;
      }

      DatabaseManager().updateUser(tmpName, tmpSurname, tmpNName, userId, null);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      final destination = Uuid().v4();
      task = FirebaseApi.uploadFile(destination, file!);

      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      if (userName.text == "") {
        tmpName = name;
      } else {
        tmpName = userName.text;
      }
      if (userSurname.text == "") {
        tmpSurname = surName;
      } else {
        tmpSurname = userSurname.text;
      }
      if (userNName.text == "") {
        tmpNName = nname;
      } else {
        tmpNName = userNName.text;
      }

      DatabaseManager()
          .updateUser(tmpName, tmpSurname, tmpNName, userId, urlDownload);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  getProfilePic(mediaUrl) {
    if (file != null) {
      return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(file ?? File("")),
          ),
        ),
      );
    } else {
      if (mediaUrl == null) {
        return Container(
          margin: EdgeInsets.all(6),
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
}
