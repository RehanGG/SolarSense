import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:solarsense/models/field_exception.dart';
import 'package:solarsense/modules/authentication/state/signup_state.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/constants/utilities.dart';

class SignupController extends GetxController {
  static SignupController get to => Get.find();

  final SignupState state = SignupState();

  void validateFields() {
    if (state.fullName.text.isEmpty) {
      throw const FieldException('Enter your full name', 'Full Name');
    }
    if (state.email.text.trim().isEmpty) {
      throw const FieldException('Enter your email', 'Email');
    }
    if (state.password.text.isEmpty) {
      throw const FieldException('Enter the password', 'Password');
    }
  }

  void signupUser() async {
    showLoadingScreen();
    try {
      validateFields();
      final UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: state.email.text.trim(), password: state.password.text);
      await FirebaseFirestore.instance
          .collection(FirestoreConstants.USERS)
          .doc(user.user!.uid)
          .set({
        'fullname': state.fullName.text,
        'email': state.email.text.trim(),
      });
      hideLoadingScreen();
      Get.offAllNamed(Routes.LOADING_VIEW);
    } on FirebaseException catch (e) {
      hideLoadingScreen();
      if (e.code == 'weak-password') {
        showGetSnackBar('Weak Password',
            'Your password is weak, please enter a strong password.');
      } else if (e.code == 'email-already-in-use') {
        showGetSnackBar('Email In-Use', 'Specified Email is already in use.');
      } else {
        showGetSnackBar(e.code, e.message ?? "");
      }
    } on FieldException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.title, e.message);
    }
  }
}
