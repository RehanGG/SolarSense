import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../shared/services/app_controller.dart';

class ReportState {
  final Rx<int> currentStep = Rx(0);

  final TextEditingController installationPrice = TextEditingController();
  final TextEditingController electricityCost = TextEditingController();
  final TextEditingController panelCapacity = TextEditingController();

  final Rx<DateTime?> installationDate = Rx(null);

  final Rx<LatLng?> selectedLocation = Rx(LatLng(
      AppController.to.state.appUser.value!.location.coordinates.lat,
      AppController.to.state.appUser.value!.location.coordinates.long));
  final Rx<String?> locationName =
      Rx(AppController.to.state.appUser.value!.location.locationName);

  final RxBool generatePdf = true.obs;

  Map<String, dynamic> weatherData = {};
  Map<String, dynamic> modelData = {};

  bool isChanged = false;
}
