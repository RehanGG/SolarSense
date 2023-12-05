import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState {
  static const LatLng default_location =
      LatLng(33.67715534264639, 73.06801369657997);
  final RxBool loading = true.obs;
  late final GoogleMapController mapController;
  Position? currentPosition;
  final Rx<String?> searchLocationName = Rx(null);
  final Rx<LatLng> markerPosition = Rx(default_location);
}
