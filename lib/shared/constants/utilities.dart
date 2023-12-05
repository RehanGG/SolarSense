import 'package:flutter/material.dart';
import 'package:solarsense/shared/services/app_controller.dart';
import 'package:solarsense/shared/widgets/loading_screen.dart';
import 'package:get/get.dart';
import '../widgets/transparent_route.dart';
import 'constants.dart';

//Validations
bool isValidEmail(String email) {
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@[A-Za-z0-9]+(\.[A-Za-z]{2,})$');

  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');

  return passwordRegex.hasMatch(password);
}

bool isValidFullName(String fullName) {
  final RegExp fullNameRegex = RegExp(r"^[A-Za-z\s\'\-]+$");
  return fullNameRegex.hasMatch(fullName);
}

//LOADING SCREEN
void showLoadingScreen() async {
  AppController.to.state.loadingWillPop = false;
  Navigator.push(Get.context!,
      TransparentRoute(builder: (context) => const LoadingScreen()));
}

void hideLoadingScreen() async {
  if (!AppController.to.state.loadingWillPop) {
    AppController.to.state.loadingWillPop = true;
    Navigator.pop(Get.context!);
  }
}

//

void showGetSnackBar(String title, String message,
    {String variant = 'error'}) async {
  await Get.closeCurrentSnackbar();
  final GetSnackBar snackBar = GetSnackBar(
    duration: const Duration(seconds: 3),
    title: title,
    message: message,
    backgroundColor:
        variant == 'error' ? ColorConstants.errorContainerColor : Colors.green,
    icon: Icon(
      variant == 'error' ? Icons.error : Icons.check_circle,
      color: Colors.white,
    ),
  );
  Get.showSnackbar(snackBar);
}
