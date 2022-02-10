import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/main_map/find.dart';
import 'package:photogram/main_map/instantlocation.dart';
import 'package:photogram/main_map/share.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainScreen> {
  final controller = PageController(
    initialPage: 0,
  );
  int shdwtmp = 0;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final authService = Provider.of<AuthenticationService>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: PageView(
          controller: controller,
          children: [
            mainPage1(height, width, authService, users),
            mainPage2(height, width),
          ],
        ),
      ),
    );
  }

  String ppic(String name) {
    if (name == "hfjd") {
      return "ppic.png";
    } else if (name == "BeyazIt") {
      return "a.PNG";
    } else {
      return "searching.png";
    }
  }

  Widget mainPage1(
      double height, double width, authService, CollectionReference users) {
    return Container(
      child: Stack(
        children: [
          bg(
            height,
            width,
            Color.fromRGBO(225, 135, 135, 1),
            Color.fromRGBO(225, 189, 58, 1),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: width,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.20,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTapDown: (detail) {
                              setState(() {
                                shdwtmp = 1;
                              });
                            },
                            onTapUp: (detail) {
                              setState(() {
                                shdwtmp = 0;
                              });
                            },
                            onLongPress: () async {
                              await authService.signOut();
                            },
                            child: Container(
                              width: width * 0.4,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      decoration: boxshadow(shdwtmp),
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: users
                                            .doc(authService.getUser())
                                            .get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                "Bir şeyler ters gitti");
                                          }

                                          if (snapshot.hasData &&
                                              !snapshot.data!.exists) {
                                            return Text("Dokümana ulaşılamadı");
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            Map<String, dynamic> data =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            return Container(
                                              margin: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage("pics/" +
                                                      ppic("${data['name']}")),
                                                ),
                                              ),
                                            );
                                            // Text(
                                            //   "Hoşgeldin ${data['name']} ${data['surname']}",
                                            //   style: TextStyle(fontSize: 20),
                                            // );
                                          }

                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
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
                                        FutureBuilder<DocumentSnapshot>(
                                          future: users
                                              .doc(authService.getUser())
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Bir şeyler ters gitti");
                                            }

                                            if (snapshot.hasData &&
                                                !snapshot.data!.exists) {
                                              return Text(
                                                  "Dokümana ulaşılamadı");
                                            }

                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              Map<String, dynamic> data =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return Container(
                                                child: Text(
                                                  "${data['followers']}",
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          126, 181, 166, 1),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              // Text(
                                              //   "Hoşgeldin ${data['name']} ${data['surname']}",
                                              //   style: TextStyle(fontSize: 20),
                                              // );
                                            }

                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
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
                                        FutureBuilder<DocumentSnapshot>(
                                          future: users
                                              .doc(authService.getUser())
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Bir şeyler ters gitti");
                                            }

                                            if (snapshot.hasData &&
                                                !snapshot.data!.exists) {
                                              return Text(
                                                  "Dokümana ulaşılamadı");
                                            }

                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              Map<String, dynamic> data =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return Container(
                                                child: Text(
                                                  "${data['follow']}",
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              );
                                              // Text(
                                              //   "Hoşgeldin ${data['name']} ${data['surname']}",
                                              //   style: TextStyle(fontSize: 20),
                                              // );
                                            }

                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
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
                    content(width, 'c.jpg', 'b.JPEG', "bbs",
                        "loc: 40.175339, 29.172160"),
                    content(width, 'd.JPG', 'f.JPG', "technosor",
                        "loc: 36.480685, 36.241850"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
                      child: Container(
                        height: 45,
                        width: width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              hintText: "Kimi Bulmak İstiyorsun?",
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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

  Widget content(
      double width, String pic, String ppic, String uname, String loc) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: width,
            color: Color.fromRGBO(255, 255, 255, 0.4),
            child: Column(
              children: [
                Container(
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
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("pics/" + ppic),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          uname,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
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
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image(
                            image: AssetImage("pics/" + pic),
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
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("pics/heart.png"),
                          ),
                        ),
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
}
