import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<HomeScreen> {
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
              child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(authService.getUser()).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Bir şeyler ters gitti");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("Dokümana ulaşılamadı");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Text(
                      "Hoşgeldin ${data['name']} ${data['surname']}",
                      style: TextStyle(fontSize: 20),
                    );
                  }

                  return Text("loading");
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                await authService.signOut();
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
