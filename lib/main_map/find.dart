import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/main_map/closelocation.dart';
import 'package:photogram/main_map/searchlocation.dart';
import 'package:photogram/main_map/main_screen.dart';
import 'package:photogram/wrapper.dart';

class Find extends StatefulWidget {
  const Find({Key? key}) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {
  final controller = PageController(
    initialPage: 0,
  );
  int shdwtmp = 0;
  @override
  Widget build(BuildContext context) {
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
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchLocation(),
                                          ),
                                        );
                                      },
                                      child: secondPageButton(width, height,
                                          "Konum Ara", "delivery1.png"),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CloseLocation(),
                                          ),
                                        );
                                      },
                                      child: secondPageButton(
                                          width,
                                          height,
                                          "Yakınımda Ki Konumları Bul",
                                          "loc.png"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
