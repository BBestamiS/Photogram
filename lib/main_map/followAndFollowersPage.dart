import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/main_map/searchlocation.dart';
import 'package:photogram/main_map/main_screen.dart';
import 'package:photogram/profile/profile.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/share/instantloc.dart';
import 'package:photogram/share/savedloc.dart';
import 'package:photogram/wrapper.dart';
import 'package:rive/rive.dart' as riv;

import '../services/databasemanager.dart';

class FollowAndFollowers extends StatefulWidget {
  FollowAndFollowers(this.isItFollow, this.uid);
  var isItFollow;
  var uid;
  @override
  _FollowAndFollowers createState() => _FollowAndFollowers();
}

class _FollowAndFollowers extends State<FollowAndFollowers> {
  final controller = PageController(
    initialPage: 0,
  );
  int shdwtmp = 0;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final Query<Map<String, dynamic>> _usersStream;
    if (widget.isItFollow) {
      print("follow kısmına girdiiiiiiiiiiiiiiiiiii");
      _usersStream = FirebaseFirestore.instance
          .collection('follow')
          .doc(widget.uid)
          .collection("userid");
    } else {
      print("follower kısmına girdiiiiiiiiiiiiiiiiiii");
      print("kullanıcı id'si = " + widget.uid);
      _usersStream = FirebaseFirestore.instance
          .collection('follower')
          .doc(widget.uid)
          .collection("userid");
    }

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Wrap(
          children: [
            Container(
              height: height,
              child: Stack(
                children: [
                  bg(
                    height,
                    width,
                    Color.fromRGBO(135, 155, 225, 1),
                    Color.fromRGBO(172, 226, 58, 1),
                  ),
                  Container(
                    color: Color.fromRGBO(255, 255, 255, 0.25),
                  ),
                  SafeArea(
                    child: Stack(
                      children: [
                        FutureBuilder<QuerySnapshot>(
                          future: _usersStream
                              .orderBy('timestamp', descending: true)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Bir şeyler ters gitti');
                            }
                            if (snapshot.data != null) {
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    "Hiç kullanıcı bulunamadı!",
                                    style: GoogleFonts.sora(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            return Container(
                              margin: EdgeInsets.only(top: 70),
                              child: ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;

                                  return ListTile(
                                    title: FutureBuilder<DocumentSnapshot>(
                                        future:
                                            users.doc(data['followid']).get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return Text("Something went wrong");
                                          }

                                          if (snapshot.hasData &&
                                              !snapshot.data!.exists) {
                                            return Text(
                                                "Document does not exist");
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> data =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile(data['uid']),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                width: width,
                                                height: 100,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Center(
                                                          child: AspectRatio(
                                                            aspectRatio: 1 / 1,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            0.25),
                                                                    blurRadius:
                                                                        7,
                                                                    spreadRadius:
                                                                        1,
                                                                    offset:
                                                                        Offset(
                                                                            -9,
                                                                            -9),
                                                                  ),
                                                                  BoxShadow(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0.25),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        1,
                                                                    offset:
                                                                        Offset(
                                                                            9,
                                                                            9),
                                                                  ),
                                                                ],
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                              child:
                                                                  getProfilePic(
                                                                data[
                                                                    'mediaUrl'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(data['username']),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Takip ",
                                                              style: GoogleFonts.sora(
                                                                  textStyle: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                            ),
                                                            StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: DatabaseManager()
                                                                    .getFollowStream(
                                                                        data[
                                                                            'uid']),
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
                                                                        .data!
                                                                        .size
                                                                        .toString(),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Takipçi ",
                                                              style: GoogleFonts.sora(
                                                                  textStyle: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                            ),
                                                            StreamBuilder<
                                                                    QuerySnapshot>(
                                                                stream: DatabaseManager()
                                                                    .getFollowerStream(
                                                                        data[
                                                                            'uid']),
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
                                                                        .data!
                                                                        .size
                                                                        .toString(),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                          return Text("loading");
                                        }),
                                  );
                                }).toList(),
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
                                  builder: (context) => Profile(widget.uid),
                                ),
                              );
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
            ),
          ],
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

  Widget secondPageButton(
      double width, double height, String text, String pic) {
    return Center(
      child: Container(
        height: 300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width * 0.85,
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        offset: Offset(8, 8),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        offset: Offset(-8, -8),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(196, 196, 196, 1),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment(0, 0.20),
                        child: Container(
                          child: Text(
                            text,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.1, -1),
              child: Column(
                children: [
                  Container(
                    width: 190,
                    height: 190,
                    child: Image(
                      image: AssetImage("pics/" + pic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
