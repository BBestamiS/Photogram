import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photogram/main_map/find.dart';
import 'package:photogram/main_map/main_screen.dart';

class CloseLocation extends StatefulWidget {
  @override
  _GoogleMapsViewState createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<CloseLocation> {
  List<Marker> customMarkers = [];
  void createLoc() {
    customMarkers.add(
      Marker(
        markerId: MarkerId("asdd"),
        position: LatLng(37.4020, -122.0040),
        infoWindow: InfoWindow(title: '37.4020, -122.0040'),
        onTap: () {
          setState(() {
            text = "37.4020, -122.0040";
          });
        },
      ),
    );
    customMarkers.add(
      Marker(
        markerId: MarkerId("asddd"),
        position: LatLng(37.4620, -122.0440),
        infoWindow: InfoWindow(title: '37.4620, -122.0440'),
        onTap: () {
          setState(() {
            text = "37.4620, -122.0440";
          });
        },
      ),
    );
    customMarkers.add(
      Marker(
        markerId: MarkerId("asd"),
        position: LatLng(37.4620, -122.1040),
        infoWindow: InfoWindow(title: '37.4620, -122.1040'),
        onTap: () {
          setState(() {
            text = "37.4620, -122.1040";
          });
        },
      ),
    );
  }

  // Set<Polyline> _polylines = Set<Polyline>();
  // List<LatLng> polylineCoordinates = [];
  // late PolylinePoints polylinePoints;

  var text = "Konumlar Bulundu";
  List myListLng = [37.44123123];
  late LocationData _currentPosition;
  LatLng first_coor = LatLng(37.4220, -122.0840);
  int count = 1;
  // late LatLng second_coor;
  // late LatLng third_coor;
  // late LatLng fourth_coor;

  LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  late GoogleMapController _controller;

  Location location = Location();

  void _onMapCreated(GoogleMapController _cntrl) {
    _controller = _cntrl;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(l.latitude ?? 30, l.longitude ?? 30), zoom: 15)));
    });
  }

  void _onMapCreated1(GoogleMapController _cntrl) {
    // setPolylines();
  }

  // void setPolylines() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       "AIzaSyB5eCqGMAi7FT1IYfTuyxgLLTSbfuQEeLc",
  //       PointLatLng(, longitude),
  //       PointLatLng(latitude, longitude));
  // }

  @override
  void initState() {
    // polylinePoints = PolylinePoints();
    super.initState();
    getLoc();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    createLoc();
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Expanded(
              //   child: Center(
              //     child: Container(
              //       child: GoogleMap(
              //         mapType: MapType.normal,
              //         initialCameraPosition: CameraPosition(
              //             target: _initialcameraposition, zoom: 20),
              //         onMapCreated: _onMapCreated,
              //         markers: customMarkers.toSet(),
              //         myLocationEnabled: true,
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Center(
                  child: Container(
                    child: GoogleMap(
                      // polylines: _polylines,
                      mapType: MapType.normal,
                      initialCameraPosition:
                          CameraPosition(target: first_coor, zoom: 11),
                      onMapCreated: _onMapCreated1,
                      markers: customMarkers.toSet(),
                      circles: _createCircle(),
                      myLocationEnabled: true,
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromRGBO(226, 189, 58, 1),
                width: width,
                height: 120,
                child: Row(
                  children: [
                    Container(
                        width: width,
                        height: 120,
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment(-0.95, 0),
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
                                  width: 50,
                                  height: 50,
                                  child: Image(
                                    image: AssetImage("pics/back.png"),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                text,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              // Center(
              //   child: Text("Markers"),
              // ),
              // Expanded(
              //   child: Center(
              //     child: Container(
              //       child: GoogleMap(
              //         mapType: MapType.normal,
              //         initialCameraPosition:
              //             CameraPosition(target: first_coor, zoom: 10),
              //         onMapCreated: _onMapCreated1,
              //         markers: customMarkers.toSet(),
              //         circles: _createCircle(),
              //         myLocationEnabled: true,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment(-0.90, -0.95),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("pics/loc.png"),
                    ),
                  ),
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Set<Marker> _createMarker() {
  //   return <Marker>[
  //     customMarkers.forEach((element) {
  //       print(element);
  //     }),
  //   ].toSet();
  // }

  Set<Circle> _createCircle() {
    return <Circle>[
      Circle(
        circleId: CircleId("asda"),
        center: first_coor,
        radius: 10000,
        fillColor: Color.fromRGBO(66, 165, 245, 0.2),
      )
    ].toSet();
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.latitude} : ${currentLocation.longitude}");
      if (count == 2) {
        this.first_coor = LatLng(
            _currentPosition.latitude ?? 0, _currentPosition.longitude ?? 0);
        count++;
      }
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition = LatLng(
            _currentPosition.latitude ?? 0, _currentPosition.longitude ?? 0);
      });
    });
  }
}
