import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/modules/authentication/state/create_account_state.dart';

import '../../../models/field_exception.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/constants/utilities.dart';

class CreateNewAccountController extends GetxController {
  final CreateAccountState state = CreateAccountState();

  void validateFields() {
    if (state.fullName.text.isEmpty) {
      throw const FieldException('Enter your full name', 'Full Name');
    }
    if (state.selectedLocation.value == null) {
      throw const FieldException('Select your location', 'Location');
    }
    //Validations checks
    if (!isValidFullName(state.fullName.text)) {
      throw const FieldException('Enter correct name', 'Invalid Format');
    }
  }

  void createProfile() async {
    showLoadingScreen();
    try {
      validateFields();
      final user = FirebaseAuth.instance.currentUser!;
      final Map<String, dynamic> data = {
        'fullname': state.fullName.text,
        'email': user.email,
        'location': {
          'name': state.locationName.value!,
          'coords': {
            'lat': state.selectedLocation.value!.latitude,
            'lng': state.selectedLocation.value!.longitude
          }
        }
      };
      await FirebaseFirestore.instance
          .collection(FirestoreConstants.USERS)
          .doc(user.uid)
          .set(data);
      hideLoadingScreen();
      state.created = true;
      Get.back(result: data);
    } on FirebaseException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.code, e.message ?? "");
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

  @override
  void onInit() {
    super.onInit();
    state.fullName.text = FirebaseAuth.instance.currentUser!.displayName ?? '';
  }
}
