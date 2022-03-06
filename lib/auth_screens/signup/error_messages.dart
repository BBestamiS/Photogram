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

  Widget showNameError(String error) {
    if (error == 'emptyName') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'İsim Boş Kalamaz!',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (error == 'invalidName') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Geçerli İsim Giriniz!',
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

  Widget showSurNameError(String error) {
    if (error == 'emptySurName') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Soyisim Boş Kalamaz!',
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (error == 'invalidSurName') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Geçerli Soyisim Giriniz!',
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
    } else if (error == 'invalidLength') {
      return Container(
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Text(
          'Parola daha uzun olmalı!',
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
