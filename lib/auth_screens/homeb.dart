import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:photogram/auth_screens/signup/signup.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:provider/provider.dart';

class HomeScreenb extends StatefulWidget {
  const HomeScreenb({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<HomeScreenb> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Hoşgeldin BeyazIt SarIkaya",
                style: TextStyle(fontSize: 20),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await authService.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Signup()));
              },
              child: Container(
                child: Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w300,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
