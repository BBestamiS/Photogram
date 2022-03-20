import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:photogram/services/databasemanager.dart';

class Asd extends StatefulWidget {
  const Asd({Key? key}) : super(key: key);

  @override
  _Asd createState() => _Asd();
}

class _Asd extends State<Asd> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference _usersStream = _firestore.collection('locs');
    _getPlace();
    return Scaffold(
      body: Container(),
    );
  }

  void deneme(babaRef) async {}

  void _getPlace() async {
    try {
      List<Location> locations = await locationFromAddress("Golden Gate");
      print(locations);
    } catch (e) {
      print(e.toString());
    }
    List<Placemark> placemarks =
        await placemarkFromCoordinates(37.0618523, 36.2369856);

    Placemark placeMark = placemarks[0];
    String? street = placeMark.street;
    String? isoCountryCode = placeMark.isoCountryCode;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? subAdministrativeArea = placeMark.subAdministrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? thoroughfare = placeMark.thoroughfare;
    String? subThoroughfare = placeMark.subThoroughfare;
    // print(street);
    // print(isoCountryCode);
    // print(subLocality);
    // print(locality);
    // print(administrativeArea);
    // print(subAdministrativeArea);
    // print(postalCode);
    // print(country);
    // print(thoroughfare);
    // print(subThoroughfare);
    // print("subLocality");
  }
}
