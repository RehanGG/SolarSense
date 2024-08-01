import 'package:flutter/material.dart';

abstract class ColorConstants {
  ColorConstants._();

  static const Color primaryColor = Color.fromRGBO(11, 0, 77, 1);
  static const Color secondaryColor = Color.fromRGBO(27, 116, 187, 1);
  static const Color thirdColor = Color.fromRGBO(40, 168, 228, 1);
  static const Color accentColor = Color.fromRGBO(251, 175, 63, 1);
  static const Color errorContainerColor = Color.fromRGBO(229, 9, 20, 1);

  //Dark
  static const Color primaryDarkColor = Color.fromRGBO(57, 54, 70, 1);
}

abstract class FirestoreConstants {
  FirestoreConstants._();
  static const String USERS = 'users';
  static const String REPORT = 'report';
}
