import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

  final storage = FlutterSecureStorage();


final LoginFirstText = GoogleFonts.rubik(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(30, 49, 72, 1),
);
final  LoginSecondText =GoogleFonts.rubik(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1,
  color: Color.fromRGBO(115, 124, 134, 1),
);
final TopTextfield=GoogleFonts.roboto(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Color.fromRGBO(164, 175, 189, 1),
);
final InputTextField= GoogleFonts.rubik(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Color.fromRGBO(164, 175, 189, 1)
);
final RegisterText=GoogleFonts.rubik(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(238, 111, 66, 1),
  height: 2,
);
final ErorrInternet = GoogleFonts.rubik(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(153, 27, 27, 1)
);
bool isLoading = false;

