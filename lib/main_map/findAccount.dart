import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/main_map/searchlocation.dart';
import 'package:photogram/main_map/main_screen.dart';
import 'package:photogram/profile/profile.dart';
import 'package:photogram/share/instantloc.dart';
import 'package:photogram/share/savedloc.dart';
import 'package:photogram/wrapper.dart';
import 'package:rive/rive.dart' as riv;

class FindAccount extends StatefulWidget {
  FindAccount(this.searchText);
  var searchText;
  @override
  _FindAccount createState() => _FindAccount();
}

class _FindAccount extends State<FindAccount> {
  final controller = PageController(
    initialPage: 0,
  );
  int shdwtmp = 0;
  @override
  Widget build(BuildContext context) {
    final Query<Map<String, dynamic>> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("username", isGreaterThanOrEqualTo: widget.searchText);
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
                          future: _usersStream.get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Bir şeyler ters gitti');
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
                                    title: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Profile(data['uid'], 0),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: width,
                                        height: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
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
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0.25),
                                                            blurRadius: 7,
                                                            spreadRadius: 1,
                                                            offset:
                                                                Offset(-9, -9),
                                                          ),
                                                          BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.25),
                                                            blurRadius: 5,
                                                            spreadRadius: 1,
                                                            offset:
                                                                Offset(9, 9),
                                                          ),
                                                        ],
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: getProfilePic(
                                                        data['mediaUrl'],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(data['username']),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                              fontSize: 15)),
                                                    ),
                                                    Text(data['follow']
                                                        .toString()),
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
                                                              fontSize: 15)),
                                                    ),
                                                    Text(data['followers']
                                                        .toString()),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                  builder: (context) => Wrapper(),
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
