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

class InstantLoc extends StatefulWidget {
  const InstantLoc({Key? key}) : super(key: key);

  @override
  _InstantLoc createState() => _InstantLoc();
}

class _InstantLoc extends State<InstantLoc> {
  File? file;

  Map<String, dynamic>? locSelected;
  final _firestore = FirebaseFirestore.instance;
  LatLng? selectLoc;
  late GoogleMapController _controller;
  void _onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
  }

  loc.Location location = loc.Location();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      body: Container(
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
                                  AsyncSnapshot<Map<String, dynamic>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  return GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(snapshot.data!['Lat'],
                                            snapshot.data!['Lng']),
                                        zoom: 11),
                                    onMapCreated: _onMapCreated,
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
                        GestureDetector(
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
        builder: (context) => ShareImage(locSelected, File(path), 2),
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

  Future<Map<String, dynamic>> getLoc() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;
    String? adress;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Map();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return Map();
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

    return locSelected = {
      'Adress': adress,
      'Lat': currentloc.latitude,
      'Lng': currentloc.longitude,
      'administrativeArea': placeMark.administrativeArea.toString(),
      'isoCountryCode': placeMark.isoCountryCode.toString(),
      'locality': placeMark.locality.toString(),
      'name': placeMark.name.toString(),
      'postalCode': placeMark.postalCode.toString(),
      'street': placeMark.street.toString(),
      'subAdministrativeArea': placeMark.subAdministrativeArea.toString(),
      'subLocality': placeMark.subLocality.toString(),
      'subThoroughfare': placeMark.thoroughfare.toString(),
      'thoroughfare': placeMark.thoroughfare.toString()
    };

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   print("${currentLocation.latitude} : ${currentLocation.longitude}");
    // });
  }

  void changePoss(LatLng latLng) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latLng.latitude, latLng.longitude), zoom: 11),
      ),
    );
  }
}
