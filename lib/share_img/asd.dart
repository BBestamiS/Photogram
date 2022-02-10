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
    final Stream<QuerySnapshot> _usersStream = _firestore
        .collection('users')
        .orderBy('timestamp', descending: true)
        .limit(30)
        .snapshots();

    return Scaffold(
      body: Container(
        child: Center(
          child: StreamBuilder(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['surname']),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  void deneme(babaRef) async {}

  void _getPlace() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(41.227968, 28.979350);
    print(placemarks);
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
