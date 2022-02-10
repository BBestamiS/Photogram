import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photogram/auth_screens/signup/signup.dart';
import 'package:photogram/main_map/instantlocation.dart';
import 'package:photogram/main_map/main_screen.dart';
import 'package:photogram/main_map/share.dart';
import 'package:photogram/models/user_model.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/wrapper.dart';
import 'package:provider/provider.dart';

class ShareLoc extends StatefulWidget {
  const ShareLoc({Key? key}) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<ShareLoc> {
  final controller = PageController(
    initialPage: 0,
  );
  int shdwtmp = 0;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _locsStream =
        _firestore.collection('locs').snapshots();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthenticationService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return Signup();
          } else {
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
                                            StreamBuilder(
                                              stream: _locsStream,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                if (snapshot.hasError) {
                                                  return Text(
                                                      'Bir şeyler ters gitti!');
                                                }

                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Text("Yükleniyor..");
                                                }
                                                if (snapshot
                                                    .data!.docs.isEmpty) {
                                                  return Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 200,
                                                          child: Image(
                                                            image: AssetImage(
                                                                "pics/locadd.png"),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          child: Text(
                                                            "Kayıtlı konum bulunamadı",
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return Text(snapshot.data!.docs
                                                    .toString());
                                              },
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
                                          builder: (context) => Share(),
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
          // return user == null ? Signup() : HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
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
}
