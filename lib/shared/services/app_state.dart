import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solarsense/models/user_profile_model.dart';

class AppState {
  final Rx<UserProfileModel?> appUser = Rx(null);
  final Rx<ThemeMode> currentTheme = ThemeMode.system.obs;

  bool loadingWillPop = true;
}
