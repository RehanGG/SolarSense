import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/services/app_controller.dart';

class EditProfileState {
  final TextEditingController fullName = TextEditingController(
      text: AppController.to.state.appUser.value!.fullName);
  final Rx<LatLng?> selectedLocation = Rx(LatLng(
      AppController.to.state.appUser.value!.location.coordinates.lat,
      AppController.to.state.appUser.value!.location.coordinates.long));
  final Rx<String?> locationName =
      Rx(AppController.to.state.appUser.value!.location.locationName);
}
