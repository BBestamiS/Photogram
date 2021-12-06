import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _key = GlobalKey();
  TextEditingController userName = TextEditingController();
  TextEditingController userPass = TextEditingController();
  var validate_state_count = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;
    var safeAreaHeigh = height - padding.top - padding.bottom;
    var safeAreaBg = height - padding.top;
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
            child: Stack(
              children: <Widget>[
                bg(height, width, safeAreaBg),
                earth(height, width),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      hi(width, safeAreaHeigh),
                      Container(
                        width: width,
                        height: safeAreaHeigh * 0.90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            firstInfo(width, height),
                            inputMaxHeight(height, width),
                            loginInfo(width, height),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputMaxHeight(double height, double width) {
    if (height < 900) {
      return Expanded(
        child: Container(
          child: form(width, height),
        ),
      );
    } else {
      return Container(
        height: 400,
        child: form(width, height),
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

  AutovalidateMode validate_state() {
    if (validate_state_count == 0) {
      return AutovalidateMode.disabled;
    } else {
      return AutovalidateMode.always;
    }
  }

  Form form(double width, double height) {
    return Form(
      autovalidateMode: validate_state(),
      key: _key,
      child: Container(
        width: width * 0.75,
        constraints: BoxConstraints(maxWidth: 500),
        child: Container(
          child: Column(
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
                      // autovalidateMode: AutovalidateMode.always,
                      controller: userName,

                      validator: (value) {
                        if (value != null && value.length > 5) {
                          return null;
                        } else {
                          return "error";
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
                        hintText: "Kullanıcı Adı",
                      ),
                    ),
                  ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'geçerli';
                        } else {
                          return null;
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
                ],
              ),
              GestureDetector(
                onTap: () {
                  print(_key.currentState);
                  if (_key.currentState != null &&
                      _key.currentState!.validate()) {
                    print("object");
                  } else {
                    print("asd");
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
          ),
        ),
      ),
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
          Container(
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
        ],
      ),
    );
  }

  Container hi(double width, double safeAreaHeigh) {
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
                  color: Color.fromRGBO(5, 255, 0, 1),
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

  Container bg(double height, double width, double safeAreaBg) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color.fromRGBO(255, 213, 64, 1),
            Color.fromRGBO(182, 58, 226, 1),
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
