import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:photogram/main_map/share.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/share/shareimage.dart';
import 'package:photogram/share/shareloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:rive/rive.dart' as riv;

class SavedLoc extends StatefulWidget {
  const SavedLoc({Key? key}) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<SavedLoc> {
  File? file;
  List<Marker> locsMarkers = [];
  Map<String, dynamic>? locSelected;
  final _firestore = FirebaseFirestore.instance;
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
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthenticationService>(context);
    _locsStream = _firestore
        .collection('savedlocs')
        .doc(authService.getUser())
        .collection('userlocs')
        .snapshots();
    return Scaffold(
      body: StreamBuilder(
        stream: _locsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir şeyler ters gitti!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Yükleniyor..");
          }
          if (snapshot.data!.docs.isEmpty) {
            return getPage(false, height, width, snapshot);
          }
          return getPage(true, height, width, snapshot);
        },
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

  Future selectFile(locSelected) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareImage(locSelected, File(path), 1),
      ),
    );
  }

  Future<String> getAdress(lat, lng) async {
    String? adress;
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark placeMark = placemarks[0];
    adress = placeMark.administrativeArea.toString() +
        "/" +
        placeMark.country.toString().toUpperCase();

    return adress;
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

  void changePoss(LatLng latLng) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latLng.latitude, latLng.longitude), zoom: 11),
      ),
    );
  }

  getText(data) {
    locsMarkers.add(
      Marker(
        markerId: MarkerId(Uuid().v4()),
        position: LatLng(data['Lat'], data['Lng']),
        infoWindow: InfoWindow(title: data['Adress']),
        onTap: () {},
      ),
    );
    return Text(
      data['subAdministrativeArea'],
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getPage(isItTrue, height, width, otherSnap) {
    return Container(
      child: Container(
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
                          child: FutureBuilder(
                            future: getLoc(),
                            builder: (BuildContext context,
                                AsyncSnapshot<LatLng> snapshot) {
                              if (snapshot.hasData) {
                                return GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: CameraPosition(
                                      target: snapshot.data!, zoom: 11),
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
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: height * 0.42,
                          child: whichPage(isItTrue, otherSnap),
                        ),
                      ),
                      trueText(isItTrue, width),
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
                  trueSmallIcon(isItTrue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget truePage(snapshot) {
    return Container(
      child: ListView(
        children: snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return ListTile(
            title: Container(
              margin: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  changePoss(LatLng(data['Lat'], data['Lng']));
                  setState(() {
                    locSelected = data;
                  });
                },
                child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(data['description']),
                        ),
                        Container(
                          child: getText(data),
                        ),
                      ],
                    )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget trueSmallIcon(isItTrue) {
    if (isItTrue == true) {
      return Align(
        alignment: Alignment(0.95, -1),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShareLoc(),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: 50,
            height: 50,
            child: Image(
              image: AssetImage("pics/locadd.png"),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget trueText(isItTrue, width) {
    if (isItTrue == true) {
      return locSelected != null
          ? GestureDetector(
              onTap: () {
                selectFile(locSelected!);
              },
              child: Container(
                width: width * 1,
                height: 70,
                color: Color.fromRGBO(118, 240, 43, 1),
                child: Center(
                  child: Text(
                    "Resim Seç",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: width * 1,
              height: 70,
              child: Center(
                child: Text(
                  "Bir konum seçiniz",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
    }
    return Container();
  }

  Widget falsePage(snapshot) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ShareLoc()));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: Image(
                image: AssetImage("pics/locadd.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Kayıtlı konum bulunamadı",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  whichPage(isItTrue, snapshot) {
    if (isItTrue == true) {
      return truePage(snapshot);
    } else {
      return falsePage(snapshot);
    }
  }
}
