import 'package:flutter/material.dart';

import 'constants.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: ColorConstants.primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
  ),
);

final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: ColorConstants.primaryDarkColor,
      titleTextStyle: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
    ));
