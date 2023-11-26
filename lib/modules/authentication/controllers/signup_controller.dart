import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    if (state.selectedLocation.value == null) {
      throw const FieldException('Select your location', 'Location');
    }
    //Validations checks
    if (!isValidFullName(state.fullName.text)) {
      throw const FieldException('Enter correct name', 'Invalid Format');
    }
    if (!isValidEmail(state.email.text.trim())) {
      throw const FieldException(
          'Please enter the correct email address', 'Invalid Format');
    }
    if (!isValidPassword(state.password.text)) {
      throw const FieldException(
          'Enter password with at-least \n\nOne Special Character \nOne Capital Letter\nAnd Minimum length of 8 letters',
          'Invalid Format');
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
        'location': {
          'name': state.locationName.value!,
          'coords': {
            'lat': state.selectedLocation.value!.latitude,
            'lng': state.selectedLocation.value!.longitude
          }
        }
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

  void getLocation(LatLng selectedLocation) async {
    showLoadingScreen();
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation.latitude, selectedLocation.longitude);
      final String? country = placemarks[0].country;
      final String? city = placemarks[0].locality;

      if (country == null || city == null) {
        throw Exception();
      }
      state.selectedLocation.value = selectedLocation;
      state.locationName.value = '$city, $country';
      hideLoadingScreen();
    } catch (e) {
      hideLoadingScreen();
      state.selectedLocation.value = null;
      state.locationName.value = null;
      showGetSnackBar('Invalid Location', 'Please select correct location');
    }
  }
}
