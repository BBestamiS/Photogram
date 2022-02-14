import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as loc;
import 'package:photogram/main_map/share.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/services/databasemanager.dart';
import 'package:photogram/share/savedloc.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShareLoc extends StatefulWidget {
  const ShareLoc({Key? key}) : super(key: key);

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<ShareLoc> {
  loc.Location location = loc.Location();
  final controller = PageController(
    initialPage: 0,
  );
  TextEditingController description = TextEditingController();
  int shdwtmp = 0;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _locsStream =
        _firestore.collection('locs').snapshots();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      body: SingleChildScrollView(
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
                            child: FutureBuilder<List>(
                              future: getLoc(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        snapshot.data![0].toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 40, right: 40),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color:
                                              Color.fromRGBO(237, 237, 237, 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(6, 6, 6, 0.4),
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(4, 4),
                                            ),
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
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
                                          controller: description,
                                          style: GoogleFonts.roboto(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20,
                                              height: 1.4,
                                              color: Colors.black,
                                            ),
                                          ),
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Açıklama",
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          DatabaseManager().addSavedLocs(
                                              snapshot.data!, description.text);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SavedLoc()));
                                        },
                                        child: Container(
                                          width: width * 0.75,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(118, 240, 43, 1),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Konumu Kaydet",
                                            style: GoogleFonts.roboto(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                              builder: (context) => SavedLoc(),
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
      ),
    );
  }

  Future<List> getLoc() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;
    String? adress;
    List locInfos = [];

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return locInfos;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return locInfos;
      }
    }
    _locationData = await location.getLocation();
    LatLng currentloc =
        LatLng(_locationData.latitude ?? 0.0, _locationData.longitude ?? 0.0);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentloc.latitude, currentloc.longitude);
    Placemark placeMark = placemarks[0];
    adress = placeMark.locality.toString() +
        " " +
        placeMark.subAdministrativeArea.toString() +
        " " +
        placeMark.administrativeArea.toString() +
        "/" +
        placeMark.country.toString().toUpperCase();
    locInfos.add(adress);
    locInfos.add(currentloc);
    locInfos.add(placeMark.subAdministrativeArea.toString());
    locInfos.add(placeMark.administrativeArea.toString());
    locInfos.add(placeMark.name.toString());
    locInfos.add(placeMark.street.toString());
    locInfos.add(placeMark.isoCountryCode.toString());
    locInfos.add(placeMark.postalCode.toString());
    locInfos.add(placeMark.locality.toString());
    locInfos.add(placeMark.subLocality.toString());
    locInfos.add(placeMark.thoroughfare.toString());
    locInfos.add(placeMark.subThoroughfare.toString());

    return locInfos;

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   print("${currentLocation.latitude} : ${currentLocation.longitude}");
    // });
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
