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
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:rive/rive.dart' as riv;

class CloseLocation extends StatefulWidget {
  const CloseLocation({Key? key}) : super(key: key);

  @override
  _CloseLocation createState() => _CloseLocation();
}

class _CloseLocation extends State<CloseLocation> {
  File? file;
  String asd = "1";
  Future? getMyLocInfos;
  List? myLocInfos;
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
                _locsStream = _firestore
                    .collection('locs')
                    .where('subAdministrativeArea', isEqualTo: myLocInfos![0])
                    .where('postalCode', isEqualTo: myLocInfos![1])
                    .snapshots();
                return StreamBuilder(
                  stream: _locsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Bir şeyler ters gitti!');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Yükleniyor..");
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
                          onTap: () {},
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

  void changePoss(LatLng latLng) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latLng.latitude, latLng.longitude), zoom: 11),
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
                      getNoFoundText(isItTrue, width),
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
                    ],
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
    );
  }

  getNoFoundText(isItTrue, width) {
    if (isItTrue == true) {
      return Container();
    } else {
      return Container(
        width: width * 1,
        height: 100,
        child: Center(
          child: Text("Yakınlarda konum bulunamadı!",
              style: GoogleFonts.sora(
                textStyle: TextStyle(
                  fontSize: 17,
                ),
              )),
        ),
      );
    }
  }
}
