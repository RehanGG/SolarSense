import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateAccountState {
  final TextEditingController fullName = TextEditingController();
  final Rx<LatLng?> selectedLocation = Rx(null);
  final Rx<String?> locationName = Rx(null);
  bool created = false;
}
