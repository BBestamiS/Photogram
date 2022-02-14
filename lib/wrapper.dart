import 'package:flutter/material.dart';
import 'package:photogram/auth_screens/login/login.dart';
import 'package:photogram/auth_screens/signup/signup.dart';
import 'package:photogram/main_map/main_screen.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/share_img/asd.dart';
import 'package:photogram/share_img/saved_loc.dart';
import 'package:provider/provider.dart';

import 'auth_screens/home.dart';
import 'models/user_model.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return Login();
          } else {
            return MainScreen();
          }
          // return user == null ? Signup() : HomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
