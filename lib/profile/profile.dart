import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photogram/main_map/find.dart';
import 'package:photogram/main_map/followAndFollowersPage.dart';
import 'package:photogram/main_map/keepAliveFutureBuilder.dart';
import 'package:photogram/main_map/share.dart';
import 'package:photogram/profile/settings.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/services/databasemanager.dart';
import 'package:photogram/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as riv;
import 'package:location/location.dart' as loc;

import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatefulWidget {
  Profile(this.uid);
  var uid;
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final controller = PageController(
    initialPage: 0,
  );
  List<Marker> locsMarkers = [];
  int shdwtmp = 0;
  late GoogleMapController _controller;
  void _onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
  }

  var tmp = 0;
  loc.Location location = loc.Location();
  riv.SMIBool? _possiton;

  void _onRiveInit(riv.Artboard artboard) {
    final controller =
        riv.StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _possiton = controller.findInput<bool>('Pressed') as riv.SMIBool;
    _possiton!.change(false);
  }

  void _firstAnimation() => _possiton?.change(false);
  void _secondAnimation() => _possiton?.change(true);

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> _userLocs =
        _firestore.collection('locs').where('uid', isEqualTo: widget.uid);
    CollectionReference _userPosts =
        _firestore.collection('posts').doc(widget.uid).collection('userPosts');
    final Stream<DocumentSnapshot> users =
        _firestore.collection('users').doc(widget.uid).snapshots();
    final authService = Provider.of<AuthenticationService>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        child: profilePage(
            height, width, authService, users, _userPosts, _userLocs),
      ),
    );
  }

  Widget profilePage(
      double height, double width, authService, users, _userPosts, _userLocs) {
    return Container(
      child: Stack(
        children: [
          bg(
            height,
            width,
            Color.fromRGBO(225, 189, 135, 1),
            Color.fromRGBO(101, 58, 226, 1),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: users,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Bir ??eyler ters gitti!");
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
                            widget.uid == AuthenticationService().getUser()
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileSettings(),
                                        ),
                                      );
                                    },

                                    // onTapDown: (detail) {
                                    //   shdwtmp = 1;
                                    // },
                                    // onTapUp: (detail) {
                                    //   shdwtmp = 0;
                                    // },
                                    onLongPress: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Wrapper()));
                                    },
                                    child:
                                        //profil foto??rafi k??sm??
                                        Container(
                                      width: width * 0.4,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: StreamBuilder<
                                                    DocumentSnapshot>(
                                                stream: isItFollow(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Something went wrong');
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                  }
                                                  if (snapshot.hasData &&
                                                      !snapshot.data!.exists) {
                                                    return Container(
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
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: getProfilePic(
                                                        data['mediaUrl'],
                                                      ),
                                                    );
                                                  }
                                                  return Container(
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
                                                          offset:
                                                              Offset(-9, -9),
                                                        ),
                                                        BoxShadow(
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.25),
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                          offset: Offset(9, 9),
                                                        ),
                                                      ],
                                                      color: Color.fromARGB(
                                                          255, 17, 195, 109),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: getProfilePic(
                                                      data['mediaUrl'],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      DatabaseManager()
                                          .controlFollowUser(widget.uid);
                                      // CollectionReference follow =
                                      //     FirebaseFirestore.instance
                                      //         .collection('follow');

                                      // FutureBuilder(
                                      //   future: follow
                                      //       .doc(AuthenticationService()
                                      //           .getUser())
                                      //       .collection("userid")
                                      //       .doc(widget.uid)
                                      //       .get(),
                                      //   builder: (BuildContext context,
                                      //       AsyncSnapshot snapshot) {
                                      //     if (snapshot.hasError) {
                                      //       return Text("Something went wrong");
                                      //     }

                                      //     if (snapshot.connectionState ==
                                      //         ConnectionState.waiting) {
                                      //       return Text("loading");
                                      //     }

                                      //     if (snapshot.hasData &&
                                      //         !snapshot.data!.exists) {
                                      //       DatabaseManager()
                                      //           .removeFollowUser(widget.uid);
                                      //       return Text("Kullan??c?? Kald??r??ld??");
                                      //     }
                                      //     DatabaseManager()
                                      //         .addFollowUser(widget.uid);
                                      //     return Text("kullan??c?? eklendi");
                                      //   },
                                      // );
                                    },
                                    onLongPress: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Wrapper()));
                                    },
                                    child:
                                        //profil foto??rafi k??sm??
                                        Container(
                                      width: width * 0.4,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Center(
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: StreamBuilder<
                                                    DocumentSnapshot>(
                                                stream: isItFollow(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Something went wrong');
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Container();
                                                  }
                                                  if (snapshot.hasData &&
                                                      !snapshot.data!.exists) {
                                                    return Container(
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
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      child: getProfilePic(
                                                        data['mediaUrl'],
                                                      ),
                                                    );
                                                  }
                                                  return Container(
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
                                                          offset:
                                                              Offset(-9, -9),
                                                        ),
                                                        BoxShadow(
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.25),
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                          offset: Offset(9, 9),
                                                        ),
                                                      ],
                                                      color: Color.fromARGB(
                                                          255, 17, 195, 109),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    child: getProfilePic(
                                                      data['mediaUrl'],
                                                    ),
                                                  );
                                                }),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          data['username'],
                                          style: GoogleFonts.sora(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowAndFollowers(
                                                      false, widget.uid),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream: DatabaseManager()
                                                      .getFollowerStream(
                                                          widget.uid),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (snapshot.hasError) {
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
                                                      snapshot.data!.size
                                                          .toString(),
                                                      style: GoogleFonts.sora(
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
                                                " takip??i",
                                                style: GoogleFonts.sora(
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
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowAndFollowers(
                                                      true, widget.uid),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: StreamBuilder<
                                                      QuerySnapshot>(
                                                  stream: DatabaseManager()
                                                      .getFollowStream(
                                                          widget.uid),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (snapshot.hasError) {
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
                                                      snapshot.data!.size
                                                          .toString(),
                                                      style: GoogleFonts.sora(
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
                                                style: GoogleFonts.sora(
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Stack(
                          children: [
                            Container(
                              width: width,
                              color: Color.fromRGBO(255, 255, 255, 0.4),
                            ),
                            FutureBuilder<QuerySnapshot>(
                              future: _userPosts.get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: infoTamplate(
                                              width,
                                              "Ana ekrana gitmek i??in profil resmine bas??l?? tutunuz",
                                              "OnTap"),
                                        ),
                                        Expanded(
                                          child: infoTamplate(
                                              width,
                                              "Profil ayarlar??na gitmek i??in profil resminize t??klay??n??z",
                                              "Click"),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container(
                                    child: Stack(
                                      children: [
                                        PageView(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          controller: controller,
                                          children: [
                                            ListView(
                                              padding: EdgeInsets.zero,
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                Map<String, dynamic> data =
                                                    document.data()!
                                                        as Map<String, dynamic>;
                                                var mediaUrl = data['mediaUrl'];
                                                return KeepAliveFutureBuilder(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('locs')
                                                        .doc(data['locId'])
                                                        .get(),
                                                    builder: (context,
                                                        AsyncSnapshot
                                                            snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            "Something went wrong");
                                                      }

                                                      if (snapshot.hasData &&
                                                          !snapshot
                                                              .data!.exists) {
                                                        return Text(
                                                            "Document does not exist");
                                                      }
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        Map<String, dynamic>
                                                            data = snapshot
                                                                    .data!
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                        var mediaLat =
                                                            data['Lat'];
                                                        var mediaLng =
                                                            data['Lng'];
                                                        var mediaId =
                                                            data['locId'];
                                                        var mediaLikeCount =
                                                            data['like'];
                                                        return FutureBuilder<
                                                            DocumentSnapshot>(
                                                          future:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(data[
                                                                      'uid'])
                                                                  .get(),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      DocumentSnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  "Bir ??eyler ters gitti");
                                                            }

                                                            if (snapshot
                                                                    .hasData &&
                                                                !snapshot.data!
                                                                    .exists) {
                                                              return Text(
                                                                  "Document does not exist");
                                                            }

                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .done) {
                                                              Map<String,
                                                                      dynamic>
                                                                  data =
                                                                  snapshot.data!
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>;
                                                              return content(
                                                                  height,
                                                                  width,
                                                                  mediaUrl,
                                                                  mediaId,
                                                                  mediaLikeCount,
                                                                  data[
                                                                      'mediaUrl'],
                                                                  data[
                                                                      'username'],
                                                                  "loc:" +
                                                                      mediaLat
                                                                          .toString() +
                                                                      "," +
                                                                      mediaLng
                                                                          .toString());
                                                            }

                                                            return Container();
                                                          },
                                                        );
                                                      }

                                                      return Container();
                                                    });
                                              }).toList(),
                                            ),
                                            Container(
                                              child: FutureBuilder(
                                                future: _userLocs.get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Bir ??eyler ters gitti!');
                                                  }
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text("Y??kleniyor..");
                                                  }

                                                  final allData = snapshot
                                                      .data!.docs
                                                      .map((doc) => doc.data()
                                                          as Map<String,
                                                              dynamic>)
                                                      .toList();
                                                  allData.forEach((contex) {
                                                    locsMarkers.add(
                                                      Marker(
                                                        markerId: MarkerId(
                                                            Uuid().v4()),
                                                        position: LatLng(
                                                            double.parse(
                                                                contex['Lat']),
                                                            double.parse(
                                                                contex['Lng'])),
                                                        infoWindow: InfoWindow(
                                                            title: contex[
                                                                'Adress'],
                                                            onTap: () async {
                                                              var latitude =
                                                                  contex['Lat'];
                                                              var longitude =
                                                                  contex['Lng'];
                                                              String googleUrl =
                                                                  'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                                              if (await canLaunch(
                                                                  googleUrl)) {
                                                                await launch(
                                                                    googleUrl);
                                                              } else {
                                                                throw 'Haritalar a????l??rken sorun meydana geldi.';
                                                              }
                                                            }),
                                                        onTap: () {},
                                                      ),
                                                    );
                                                  });

                                                  return FutureBuilder(
                                                    future: getLoc(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<LatLng>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        return GoogleMap(
                                                          mapType:
                                                              MapType.normal,
                                                          initialCameraPosition:
                                                              CameraPosition(
                                                                  target:
                                                                      snapshot
                                                                          .data!,
                                                                  zoom: 5),
                                                          onMapCreated:
                                                              _onMapCreated,
                                                          markers: locsMarkers
                                                              .toSet(),
                                                          myLocationEnabled:
                                                              true,
                                                        );
                                                      } else {
                                                        return Center(
                                                          child:
                                                              riv.RiveAnimation
                                                                  .asset(
                                                            'animations/delivery.riv',
                                                            fit: BoxFit.cover,
                                                            animations: [
                                                              'Example'
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: 65,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color.fromRGBO(0, 0, 0, 0.0),
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                                  Color.fromRGBO(0, 0, 0, 0.3),
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                                ],
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.zero,
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 2, sigmaY: 2),
                                                child: Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (tmp == 0) {
                                                        _secondAnimation();
                                                        controller.animateToPage(
                                                            1,
                                                            duration:
                                                                new Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves.ease);
                                                        tmp = 1;
                                                      } else {
                                                        _firstAnimation();
                                                        controller.animateToPage(
                                                            0,
                                                            duration:
                                                                new Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves.ease);
                                                        tmp = 0;
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      height: 65,
                                                      child: riv.RiveAnimation
                                                          .asset(
                                                        'animations/slide.riv',
                                                        fit: BoxFit.cover,
                                                        onInit: _onRiveInit,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
                              hintText: "Kimi Bulmak ??stiyorsun?",
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
                          width, height, "Payla??", "delivery-box.png"),
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
      mediaLikeCount, ppic, String uname, String loc) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: width,
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
                                child: getProfilePic(ppic),
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

  Container infoTamplate(double width, text, animation) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.only(top: 20, bottom: 20),
      color: Color.fromARGB(23, 94, 15, 230),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.sora(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 500 / 200,
            child: Container(
              width: width,
              child: riv.RiveAnimation.asset(
                "animations/profile.riv",
                fit: BoxFit.cover,
                animations: [animation],
              ),
            ),
          ),
        ],
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

  Future<LatLng> getLoc() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LatLng(0, 0);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return LatLng(0, 0);
      }
    }
    _locationData = await location.getLocation();
    LatLng currentloc =
        LatLng(_locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0);

    return currentloc;
  }

  isItFollow() {
    if (AuthenticationService().getUser() != null) {
      final Stream<DocumentSnapshot> _followStream = FirebaseFirestore.instance
          .collection('follow')
          .doc(AuthenticationService().getUser())
          .collection("userid")
          .doc(widget.uid)
          .snapshots();
      return _followStream;
    }
  }
}
