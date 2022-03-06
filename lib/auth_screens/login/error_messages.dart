import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorMessages {
  Widget showNNameError(String error) {
    if (error == 'emptyNName') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Kullanıcı Adı Boş Kalamaz!',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget showPassError(String error) {
    if (error == 'emptyPass') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Parola Boş Kalamaz!',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget showEmailError(String error) {
    if (error == 'emptyEmail') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'E-Posta Boş Kalamaz!',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (error == 'invalidEmail') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Geçerli E-Posta Giriniz!',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
