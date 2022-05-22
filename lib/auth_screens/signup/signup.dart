import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:photogram/auth_screens/home.dart';
import 'package:photogram/auth_screens/login/login.dart';
import 'package:photogram/services/authentication_service.dart';
import 'package:photogram/net/firebase.dart';
import 'package:photogram/wrapper.dart';
import 'package:provider/src/provider.dart';

import 'error_messages.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _key = GlobalKey();
  TextEditingController userNName = TextEditingController();
  TextEditingController userPass = TextEditingController();
  TextEditingController userSurname = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  var screenTmp = 0;
  var errorName = '';
  var errorSurName = '';
  var errorPass = '';
  var errorNName = '';
  var errorEmail = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;
    var safeAreaHeigh = height - padding.top - padding.bottom;
    var safeAreaBg = height - padding.top;
    final authService = Provider.of<AuthenticationService>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: select_screen(
                height, width, safeAreaBg, safeAreaHeigh, authService),
          ),
        ),
      ),
    );
  }

  Stack select_screen(double height, double width, double safeAreaBg,
      double safeAreaHeigh, authService) {
    if (screenTmp == 0) {
      return first_page(height, width, safeAreaBg, safeAreaHeigh, authService);
    } else {
      return second_page(height, width, safeAreaBg, safeAreaHeigh, authService);
    }
  }

  Stack first_page(double height, double width, double safeAreaBg,
      double safeAreaHeigh, authService) {
    return Stack(
      children: <Widget>[
        bg(
          height,
          width,
          safeAreaBg,
          Color.fromRGBO(255, 213, 64, 1),
          Color.fromRGBO(182, 58, 226, 1),
        ),
        earth(height, width),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              hi(width, safeAreaHeigh, Color.fromRGBO(5, 255, 0, 1)),
              Container(
                width: width,
                height: safeAreaHeigh * 0.90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    firstInfo(width, height),
                    firstPageinputMaxHeight(height, width, authService),
                    loginInfo(width, height),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Stack second_page(double height, double width, double safeAreaBg,
      double safeAreaHeigh, authService) {
    return Stack(
      children: <Widget>[
        bg(
          height,
          width,
          safeAreaBg,
          Color.fromRGBO(64, 255, 94, 1),
          Color.fromRGBO(58, 74, 226, 1),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              secondPageHi(width, safeAreaHeigh, Color.fromRGBO(23, 51, 94, 1)),
              Container(
                width: width,
                height: safeAreaHeigh * 0.90,
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    secondPageInfo(width, height),
                    Expanded(child: Container()),
                    secondPageinputMaxHeight(height, width, authService),
                    Expanded(child: Container()),
                    loginInfo(width, height),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget firstPageinputMaxHeight(double height, double width, authService) {
    if (height < 900) {
      return Expanded(
        child: Container(
          child: form(width, height, authService),
        ),
      );
    } else {
      return Container(
        height: 400,
        child: form(width, height, authService),
      );
    }
  }

  Widget secondPageinputMaxHeight(double height, double width, authService) {
    if (height < 900) {
      return Container(
        height: height * 0.6,
        child: form(width, height, authService),
      );
    } else {
      return Container(
        height: 400,
        child: form(width, height, authService),
      );
    }
  }

  double containerMargin(double width, double height) {
    if (width * 0.75 > 400) {
      return 350;
    } else {
      return width * 0.65;
    }
  }

  Form form(double width, double height, authService) {
    return Form(
      key: _key,
      child: Container(
        width: width * 0.75,
        constraints: BoxConstraints(maxWidth: 500),
        child: Container(
          child: select_form(width, authService),
        ),
      ),
    );
  }

  Column select_form(double width, authService) {
    if (screenTmp == 0) {
      return firstPageForm(width, authService);
    } else {
      return secondPageForm(width, authService);
    }
  }

  Column firstPageForm(double width, authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(237, 237, 237, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(6, 6, 6, 0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 1),
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
                onChanged: (text) {
                  if (text == '') {
                    setState(() {
                      errorNName = 'emptyNName';
                    });
                  } else {
                    setState(() {
                      errorNName = '';
                    });
                  }
                },
                controller: userNName,
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
                  hintText: "Kullanıcı Adı",
                ),
              ),
            ),
            ErrorMessages().showNNameError(errorNName),
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(237, 237, 237, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(6, 6, 6, 0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 1),
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
                onChanged: (text) {
                  if (text == '') {
                    setState(() {
                      errorPass = 'emptyPass';
                    });
                  } else if (text.length < 6) {
                    setState(() {
                      errorPass = 'invalidLength';
                    });
                  } else {
                    setState(() {
                      errorPass = '';
                    });
                  }
                },
                controller: userPass,
                obscureText: true,
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
                  hintText: "Parola",
                ),
              ),
            ),
            ErrorMessages().showPassError(errorPass),
          ],
        ),
        GestureDetector(
          onTap: () async {
            if (userNName.text == '') {
              setState(() {
                errorNName = 'emptyNName';
              });
            }
            if (userPass.text == '') {
              setState(() {
                errorPass = 'emptyPass';
              });
            }
            if (_key.currentState != null &&
                errorPass == '' &&
                errorNName == '') {
              setState(() {
                screenTmp = 1;
              });
            }
          },
          child: Container(
            width: width * 0.75,
            height: 55,
            decoration: BoxDecoration(
              color: Color.fromRGBO(118, 240, 43, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              "Tamamdır",
              style: GoogleFonts.roboto(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column secondPageForm(double width, authService) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(237, 237, 237, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(6, 6, 6, 0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 1),
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
                onChanged: (text) {
                  if (text == '') {
                    setState(() {
                      errorEmail = 'emptyEmail';
                    });
                  } else if (!EmailValidator.validate(userEmail.text)) {
                    setState(() {
                      errorEmail = 'invalidEmail';
                    });
                  } else {
                    setState(() {
                      errorEmail = '';
                    });
                  }
                },
                controller: userEmail,
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
                  hintText: "E-Posta",
                ),
              ),
            ),
            ErrorMessages().showEmailError(errorEmail),
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(237, 237, 237, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(6, 6, 6, 0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 1),
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
                onChanged: (text) {
                  if (text == '') {
                    setState(() {
                      errorName = 'emptyName';
                    });
                  } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(text)) {
                    setState(() {
                      errorName = 'invalidName';
                    });
                  } else {
                    setState(() {
                      errorName = '';
                    });
                  }
                },
                controller: userName,
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
                  hintText: "İsim",
                ),
              ),
            ),
            ErrorMessages().showNameError(errorName),
            Container(
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(237, 237, 237, 1),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(6, 6, 6, 0.4),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 1),
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
                controller: userSurname,
                onChanged: (text) {
                  if (text == '') {
                    setState(() {
                      errorSurName = 'emptySurName';
                    });
                  } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(text)) {
                    setState(() {
                      errorSurName = 'invalidSurName';
                    });
                  } else {
                    setState(() {
                      errorSurName = '';
                    });
                  }
                },
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
                  hintText: "Soyisim",
                ),
              ),
            ),
            ErrorMessages().showSurNameError(errorSurName),
          ],
        ),
        GestureDetector(
          onTap: () async {
            if (userEmail.text == '') {
              setState(() {
                errorEmail = 'emptyEmail';
              });
            }
            if (userName.text == '') {
              setState(() {
                errorName = 'emptyName';
              });
            }
            if (userSurname.text == '') {
              setState(() {
                errorSurName = 'emptySurName';
              });
            }

            if (_key.currentState != null &&
                errorEmail == '' &&
                errorName == '' &&
                errorSurName == '') {
              await authService.createUserWithEmailAndPassword(
                userEmail.text,
                userPass.text,
                userName.text,
                userSurname.text,
                userNName.text,
              );
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wrapper()));
            } else {
              print("Hata oluştu!");
            }
          },
          child: Container(
            width: width * 0.75,
            height: 55,
            decoration: BoxDecoration(
              color: Color.fromRGBO(118, 240, 43, 1),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              "Aramıza Hoşgeldin!",
              style: GoogleFonts.roboto(
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double infoTextFontSize(double width) {
    if (width > 500) {
      return 25;
    } else {
      return width * 0.05;
    }
  }

  Container firstInfo(double width, double height) {
    return Container(
      margin: EdgeInsets.only(
        top: containerMargin(width, height),
      ),
      child: Text(
        "1 dk’dan kısa sürede kayıt olabilirsin",
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: infoTextFontSize(width),
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Container secondPageInfo(double width, double height) {
    return Container(
      width: width * 0.75,
      child: Text(
        "Seni aramızda görmek için sabırsızlanıyoruz 😁",
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: infoTextFontSize(width),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Container loginInfo(double width, double height) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "Hesabın mı var? ",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: infoTextFontSize(width),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Wrapper()));
            },
            child: Container(
              child: Text(
                "Giriş Yap!",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: infoTextFontSize(width),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container hi(double width, double safeAreaHeigh, Color dotColor) {
    return Container(
      width: width,
      height: safeAreaHeigh * 0.10,
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Text(
              "Merhaba",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              " .",
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: dotColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container secondPageHi(double width, double safeAreaHeigh, Color dotColor) {
    return Container(
      width: width,
      height: safeAreaHeigh * 0.10,
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Row(
                  children: [
                    Text(
                      "Merhaba",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      " .",
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: dotColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  screenTmp = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image(
                    image: AssetImage('pics/back.png'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  double earthPossition(double width) {
    if (width * 0.75 > 400) {
      return -95;
    } else {
      return -(width * 0.15);
    }
  }

  Positioned earth(double height, double width) {
    return Positioned(
      top: height * 0.05,
      right: earthPossition(width),
      child: Container(
        width: width * 0.75,
        constraints: BoxConstraints(maxWidth: 400),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Image(
            image: AssetImage('pics/Earth.png'),
          ),
        ),
      ),
    );
  }

  Container bg(double height, double width, double safeAreaBg,
      Color first_color, Color second_color) {
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
      child: Container(
        width: width,
        height: safeAreaBg * 0.90,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromRGBO(255, 255, 255, 0.5),
              Color.fromRGBO(255, 255, 255, 0.2),
            ],
          ),
        ),
      ),
    );
  }
}
