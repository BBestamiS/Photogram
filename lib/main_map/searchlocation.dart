import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:photogram/main_map/find.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:rive/rive.dart' as riv;

import '../profile/profile.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({Key? key}) : super(key: key);

  @override
  _SearchLocation createState() => _SearchLocation();
}

class _SearchLocation extends State<SearchLocation> {
  File? file;
  String asd = "1";
  Future? getMyLocInfos;
  Future? _locsFuture;
  List? myLocInfos;
  List<Marker> locsMarkers = [];
  Map<String, dynamic>? locSelected;
  CollectionReference _locRef = FirebaseFirestore.instance.collection('locs');
  TextEditingController searchLoc = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  var searchLocText = "";
  var markerImageUrl = "";
  late Stream<QuerySnapshot> _locsStream;
  LatLng? selectLoc;
  late GoogleMapController _controller;
  void _onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
  }

  loc.Location location = loc.Location();
  @override
  void initState() {
    super.initState();
    _locsFuture = _locRef.get();
    getMyLocInfos = getLoc().then((value) =>
        getAdress(value.latitude, value.longitude)
            .then((value) => myLocInfos = value));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
          FutureBuilder(
            future: getMyLocInfos,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _locsStream = _firestore.collection('locs').snapshots();
                return FutureBuilder(
                  future: _locsFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Text('Bir şeyler ters gitti!');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return getPage(false, height, width, snapshot);
                    }
                    final allData = snapshot.data!.docs
                        .map((doc) => doc.data() as Map<String, dynamic>)
                        .toList();
                    allData.forEach((contex) {
                      locsMarkers.add(
                        Marker(
                          markerId: MarkerId(Uuid().v4()),
                          position: LatLng(double.parse(contex['Lat']),
                              double.parse(contex['Lng'])),
                          infoWindow: InfoWindow(
                              title: contex['Adress'],
                              onTap: () async {
                                var latitude = contex['Lat'];
                                var longitude = contex['Lng'];
                                String googleUrl =
                                    'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                if (await canLaunch(googleUrl)) {
                                  await launch(googleUrl);
                                } else {
                                  throw 'Haritalar açılırken sorun meydana geldi.';
                                }
                              }),
                          onTap: () {
                            searchLocText = "";
                            markerImageUrl = contex['mediaUrl'];
                            setState(() {});
                          },
                        ),
                      );
                    });

                    return getPage(true, height, width, snapshot);
                  },
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
        ],
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

  Future<List> getAdress(lat, lng) async {
    String? postalCode;
    String? subAdministrativeArea;
    List? adressInfos = [];
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark = placemarks[0];
    subAdministrativeArea = placeMark.subAdministrativeArea.toString();
    postalCode = placeMark.postalCode.toString();
    adressInfos.add(subAdministrativeArea);
    adressInfos.add(postalCode);

    return adressInfos;
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

  void changePoss() async {
    if (searchLocText != '') {
      try {
        List<Location> locations = await locationFromAddress(searchLocText);
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(locations[0].latitude, locations[0].longitude),
                zoom: 11),
          ),
        );
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget getPage(isItTrue, height, width, otherSnap) {
    return Container(
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
          SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: height,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Flexible(
                            child: FutureBuilder(
                              future: getLoc(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<LatLng> snapshot) {
                                if (snapshot.hasData) {
                                  return GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                        target: snapshot.data!, zoom: 5),
                                    onMapCreated: _onMapCreated,
                                    markers: locsMarkers.toSet(),
                                    myLocationEnabled: true,
                                  );
                                } else {
                                  return Center(
                                    child: riv.RiveAnimation.asset(
                                      'animations/delivery.riv',
                                      fit: BoxFit.cover,
                                      animations: ['Example'],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          searchLocText == ''
                              ? Container()
                              : FutureBuilder(
                                  future: getSearchImages(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Bir şeyler ters gitti');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Flexible(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    }

                                    if (snapshot.data.docs.toString() == "[]") {
                                      return Flexible(
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                                "Aranan konumda paylaşım yapılmadı",
                                                style: GoogleFonts.sora(
                                                  textStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        ),
                                      );
                                    }

                                    return Flexible(
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        children: snapshot.data!.docs
                                            .map<Widget>(
                                                (DocumentSnapshot document) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;
                                          var mediaUrl = data['mediaUrl'];
                                          var mediaLat = data['Lat'];
                                          var mediaLng = data['Lng'];
                                          return FutureBuilder<
                                              DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(data['uid'])
                                                .get(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    "Something went wrong");
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
                                                return content(
                                                  height,
                                                  width,
                                                  mediaUrl,
                                                  data['mediaUrl'],
                                                  data['username'],
                                                  "loc:" +
                                                      mediaLat.toString() +
                                                      "," +
                                                      mediaLng.toString(),
                                                  data['uid'],
                                                );
                                              }

                                              return Container();
                                            },
                                          );
                                          // FutureBuilder(
                                          //     future:
                                          // FirebaseFirestore.instance
                                          //         .collection('users')
                                          //         .doc(data['uid'])
                                          //         .get(),
                                          //     builder: (context, snapshot) {
                                          //       return content(
                                          //           height,
                                          //           width,
                                          //           mediaUrl,
                                          //           data['mediaUrl'],
                                          //           data['username'],
                                          //           "loc:" +
                                          //               mediaLat.toString() +
                                          //               "," +
                                          //               mediaLng.toString());
                                          //     });
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                          markerImageUrl == ''
                              ? Container()
                              : Container(
                                  height: height * 0.5,
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Image(
                                        image: NetworkImage(markerImageUrl),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(237, 237, 237, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(6, 6, 6, 0.4),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: Offset(4, 4),
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: Offset(-4, -4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              height: 55,
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: TextFormField(
                                controller: searchLoc,
                                style: GoogleFonts.sora(
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
                                  hintText: "Konum Ara",
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  markerImageUrl = "";
                                  searchLocText = searchLoc.text;
                                  changePoss();
                                  setState(() {});
                                },
                                child: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    height: 50,
                                    width: 100,
                                    child: Center(
                                      child: Text("Ara",
                                          style: GoogleFonts.sora(
                                            textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(-0.95, -1),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Find(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 45),
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

  Future getSearchImages() async {
    try {
      List<Location> locations = await locationFromAddress(searchLocText);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locations[0].latitude, locations[0].longitude);

      Placemark placeMark = placemarks[0];
      String? subAdministrativeArea = placeMark.subAdministrativeArea;
      String? postalCode = placeMark.postalCode;
      Future<QuerySnapshot<Map<String, dynamic>>> _locRef = FirebaseFirestore
          .instance
          .collection('locs')
          .where('subAdministrativeArea', isEqualTo: subAdministrativeArea)
          .where('postalCode', isEqualTo: postalCode)
          .get();
      return _locRef;
    } catch (e) {
      print("Aranan konum bulunamdı");
    }
  }

  Widget content(double height, double width, String pic, ppic, String uname,
      String loc, String uid) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: width,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (AuthenticationService().getUser() == uid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(uid, 1),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(uid, 0),
                        ),
                      );
                    }
                  },
                  child: Container(
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
                ),
                Container(
                  width: width,
                  height: height * 0.5,
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
