import 'package:flutter/painting.dart';

const Color dark = Color(0xFF3D3D3D);
const Color light = Color(0xFFFFFFFF);
const Color primary = Color(0xFF50B967);
const Color border = Color(0xFFA6AAAE);
const Color scaffold = Color(0xFFF7F9FB);

const String defaultImage =
    "https://firebasestorage.googleapis.com/v0/b/motopickup-353120.appspot.com/o/user-images%2Favatar-1.jpeg?alt=media&token=e5a7eff1-1265-42ed-81b1-30a7e56712da";
  final regExp = RegExp(
      r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
      "'" // <-- ' is added to the expression
      ']');