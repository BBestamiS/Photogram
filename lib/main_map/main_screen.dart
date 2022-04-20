import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/main_map/find.dart';
import 'package:photogram/main_map/findAccount.dart';
import 'package:photogram/main_map/keepAliveFutureBuilder.dart';
import 'package:photogram/main_map/share.dart';
import 'package:photogram/profile/profile.dart';
import 'package:photogram/profile/settings.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as riv;

import '../services/databasemanager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  final controller = PageController(
    initialPage: 0,
  );
  TextEditingController searchController = TextEditingController();
  int shdwtmp = 0;
  Query<Map<String, dynamic>> _userPosts =
      FirebaseFirestore.instance.collection('locs');
  var tmp = 0;
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    CollectionReference _timeline = _firestore
        .collection('follow')
        .doc(AuthenticationService().getUser())
        .collection('userid');

    final Stream<DocumentSnapshot> users = _firestore
        .collection('users')
        .doc(AuthenticationService().getUser())
        .snapshots();
    final authService = Provider.of<AuthenticationService>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          mainPage1(height, width, authService, users, _timeline),
          mainPage2(height, width),
        ],
      ),
    );
  }

  Widget mainPage1(double height, double width, authService, users, _timeline) {
    return Stack(
      children: [
        bg(
          height,
          width,
          Color.fromRGBO(225, 135, 135, 1),
          Color.fromRGBO(225, 189, 58, 1),
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: users,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Bir şeyler ters gitti!");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Container(
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.20,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(
                                      AuthenticationService().getUser()),
                                ),
                              );
                            },
                            // onTapDown: (detail) {
                            //   shdwtmp = 1;
                            // },
                            // onTapUp: (detail) {
                            //   shdwtmp = 0;
                            // },
                            onLongPress: () async {
                              await authService.signOut();
                            },
                            child:
                                //profil fotoğrafi kısmı
                                Container(
                              width: width * 0.4,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: boxshadow(shdwtmp),
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
                                padding: EdgeInsets.only(top: 40, bottom: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: DatabaseManager()
                                                  .getFollowerStream(
                                                      AuthenticationService()
                                                          .getUser()),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Something went wrong');
                                                }

                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                }

                                                return Text(
                                                  snapshot.data!.size
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          126, 181, 166, 1),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        Container(
                                          child: Text(
                                            " takipçi",
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
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
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: DatabaseManager()
                                                  .getFollowStream(
                                                      AuthenticationService()
                                                          .getUser()),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Something went wrong');
                                                }

                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container();
                                                }

                                                return Text(
                                                  snapshot.data!.size
                                                      .toString(),
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          126, 181, 166, 1),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                        Container(
                                          child: Text(
                                            " takip",
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
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
                    FutureBuilder<QuerySnapshot>(
                        future: _timeline.get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }

                          List followIdList = snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            data = document.data()! as Map<String, dynamic>;
                            return data;
                          }).toList();
                          List userIdList = [];
                          if (tmp == 0) {
                            for (var i = 0; i < followIdList.length; i++) {
                              userIdList
                                  .add(followIdList[i]['followid'].toString());
                            }
                            tmp = 1;
                          }

                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return Flexible(
                                child: Container(
                                  width: width,
                                  color: Color.fromRGBO(255, 255, 255, 0.4),
                                  child: Center(
                                    child: Text(
                                      "Paylaşımları görebilmek için, birilerini takip etmelisin",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return FutureBuilder<QuerySnapshot>(
                              future: _userPosts
                                  .where('uid', whereIn: userIdList)
                                  .orderBy('timestamp', descending: true)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Flexible(
                                      child: Container(
                                        width: width,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.4),
                                        child: Center(
                                          child: Text(
                                            "Bir paylaşım bulunamadı",
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Flexible(
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.zero,
                                      children: snapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;

                                        var mediaLat = data['Lat'];
                                        var mediaLng = data['Lng'];
                                        var mediaUrl = data['mediaUrl'];
                                        var mediaId = data['locId'];
                                        var mediaLikeCount = data['like'];
                                        return KeepAliveFutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(data['uid'])
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Bir şeyler ters gitti");
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
                                              return Container(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.4),
                                                child: content(
                                                    height,
                                                    width,
                                                    mediaUrl,
                                                    mediaId,
                                                    mediaLikeCount,
                                                    data['mediaUrl'],
                                                    data['username'],
                                                    data['uid'],
                                                    "loc:" +
                                                        mediaLat.toString() +
                                                        "," +
                                                        mediaLng.toString()),
                                              );
                                            }

                                            return Container();
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                                return Flexible(
                                    child: Center(
                                  child: CircularProgressIndicator(),
                                ));
                              },
                            );
                          }
                          return Flexible(
                            child: Container(
                              width: width,
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                              child: Center(
                                child: Text(
                                  "Veriler getirilken bir hata meydana geldi",
                                  style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget mainPage2(double height, double width) {
    return Wrap(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: width * 0.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: searchController,
                                style: TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  hintText: "Kimi Bulmak İstiyorsun?",
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FindAccount(searchController.text),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 45,
                              width: width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green,
                              ),
                              child: Center(
                                  child: Text(
                                "Bul",
                                style: GoogleFonts.sora(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18)),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Share(),
                          ),
                        );
                      },
                      child: secondPageButton(
                          width, height, "Paylaş", "delivery-box.png"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Find(),
                          ),
                        );
                      },
                      child: secondPageButton(
                          width, height, "Bul", "searching.png"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget secondPageButton(
      double width, double height, String text, String pic) {
    return Center(
      child: Container(
        height: 280,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width * 0.85,
                  height: 180,
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
                  Image(
                    image: AssetImage("pics/" + pic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(double height, double width, String pic, String mediaId,
      mediaLikeCount, ppic, String uname, String uid, String loc) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: width,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(uid),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.2,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Color.fromRGBO(183, 174, 174, 0.25),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(-5, -5),
                                    ),
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: getProfilePic(ppic),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        uname,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image(
                            image: NetworkImage(pic),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              DatabaseManager().controlLike(mediaId);
                            },
                            child: StreamBuilder<QuerySnapshot>(
                                stream: DatabaseManager().isItLiked(
                                    AuthenticationService().getUser(), mediaId),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.length == 0) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      padding: EdgeInsets.all(5),
                                      child: Image(
                                          image: AssetImage("pics/heart.png")),
                                    );
                                  }
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    padding: EdgeInsets.all(5),
                                    child: riv.RiveAnimation.asset(
                                      "animations/like.riv",
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: DatabaseManager().getLikeStream(mediaId),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Text(data['like'].toString());
                            },
                          ),
                        ],
                      ),
                      Container(
                        child: Text(
                          loc,
                          style: GoogleFonts.roboto(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration boxshadow(int shdwtmp) {
    if (shdwtmp == 0) {
      shdwtmp = 1;
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.25),
            blurRadius: 7,
            spreadRadius: 1,
            offset: Offset(-9, -9),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(9, 9),
          ),
        ],
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(100),
      );
    } else {
      shdwtmp = 0;
      return BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(183, 174, 174, 0.25),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(100),
      );
    }
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
