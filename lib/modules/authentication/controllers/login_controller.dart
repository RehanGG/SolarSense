import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:solarsense/models/field_exception.dart';
import 'package:solarsense/modules/authentication/state/login_state.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:solarsense/shared/constants/utilities.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final LoginState state = LoginState();

  void validateFields() {
    if (state.email.text.trim().isEmpty) {
      throw const FieldException('Enter your email', 'Email');
    }
    if (state.password.text.isEmpty) {
      throw const FieldException('Enter the password', 'Password');
    }
  }

  void loginUser() async {
    showLoadingScreen();
    try {
      validateFields();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: state.email.text.trim(), password: state.password.text);
      hideLoadingScreen();
      Get.offAllNamed(Routes.LOADING_VIEW);
    } on FirebaseException catch (e) {
      hideLoadingScreen();
      if (e.code == 'user-not-found') {
        showGetSnackBar('Invalid Email', 'User account not found!');
      } else if (e.code == 'wrong-password') {
        showGetSnackBar(
            'Invalid Credentials', 'Invalid credentials specified.');
      } else {
        showGetSnackBar(e.code, e.message ?? "");
      }
    } on FieldException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.title, e.message);
    }
  }
}
