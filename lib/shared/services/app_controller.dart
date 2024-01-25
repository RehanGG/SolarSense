import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:solarsense/shared/services/app_state.dart';

class AppController extends GetxService {
  static AppController get to => Get.find();

  final AppState state = AppState();

  void signOutUser() {
    FirebaseAuth.instance.signOut();

    Get.offAllNamed(Routes.LOGIN_VIEW);
    state.appUser.value = null;
  }

  void switchTheme() {
    state.currentTheme.value = state.currentTheme.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
