import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/models/user_profile_model.dart';
import 'package:solarsense/modules/authentication/state/editprofile_state.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/services/app_controller.dart';

import '../../../models/field_exception.dart';
import '../../../shared/constants/utilities.dart';

class EditProfileController extends GetxController {
  static EditProfileController get to => Get.find();
  final EditProfileState state = EditProfileState();

  void validateData() {
    if (state.fullName.text.isEmpty) {
      throw const FieldException('Enter your full name', 'Name');
    }
    if (state.selectedLocation.value == null) {
      throw const FieldException('Select your location', 'Location');
    }
    if (!isValidFullName(state.fullName.text)) {
      throw const FieldException('Enter correct name', 'Invalid Format');
    }
  }

  void updateProfile() async {
    showLoadingScreen();
    try {
      validateData();

      await FirebaseFirestore.instance
          .collection(FirestoreConstants.USERS)
          .doc(AppController.to.state.appUser.value!.userId)
          .update({
        'fullname': state.fullName.text,
        'location': {
          'name': state.locationName.value!,
          'coords': {
            'lat': state.selectedLocation.value!.latitude,
            'lng': state.selectedLocation.value!.longitude
          }
        }
      });

      final UserLocation location = UserLocation.fromJson({
        'name': state.locationName.value!,
        'coords': {
          'lat': state.selectedLocation.value!.latitude,
          'lng': state.selectedLocation.value!.longitude
        }
      });

      AppController.to.state.appUser.value = AppController
          .to.state.appUser.value!
          .copyWith({'fullname': state.fullName.text, 'location': location});
      hideLoadingScreen();
      showGetSnackBar('Success', 'Profile Updated Successfully!',
          variant: 'success');
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
}
