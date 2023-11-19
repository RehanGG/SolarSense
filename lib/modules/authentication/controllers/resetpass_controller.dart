import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solarsense/models/field_exception.dart';
import 'package:solarsense/shared/constants/utilities.dart';

class ResetPassController extends GetxController {
  static ResetPassController get to => Get.find();
  final TextEditingController email = TextEditingController();

  void resetUser() async {
    showLoadingScreen();
    try {
      if (email.text.trim().isEmpty) {
        throw const FieldException('Enter your email', 'Email');
      }
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      hideLoadingScreen();
      email.text = '';
      showGetSnackBar(
          'Success', 'Reset password instructions sent to your email!',
          variant: 'success');
    } on FirebaseException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.code, e.message ?? "");
    } on FieldException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.title, e.message);
    }
  }
}
