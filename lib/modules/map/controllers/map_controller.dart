import 'package:flutter/cupertino.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/modules/map/state/map_state.dart';

import '../../../shared/constants/utilities.dart';

class MapController extends GetxController {
  final MapState state = MapState();

  @override
  void onInit() {
    Get.engine.addPostFrameCallback((timeStamp) {
      setupMap();
    });
    super.onInit();
  }

  void setupMap() async {
    try {
      //Check location service
      if (!(await Geolocator.isLocationServiceEnabled())) {
        showGetSnackBar('Location Service',
            'Location services are not enabled on your device');
        throw Exception();
      }
      //Check location permissions
      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        showGetSnackBar(
            'Location Service', 'Location permissions are denied forever');
      }
      state.currentPosition = await Geolocator.getCurrentPosition();
    } catch (_) {
    } finally {
      state.loading.value = false;
    }
  }

  //On map load complete
  void completeMap() {
    //Check if location is already selected
    final arguments = Get.arguments;
    if (arguments != null) {
      final LatLng selectedLocation = Get.arguments as LatLng;
      updateLocation(selectedLocation);
    } else {
      if (state.currentPosition != null) {
        final LatLng latlng = LatLng(
            state.currentPosition!.latitude, state.currentPosition!.longitude);
        updateLocation(latlng);
      } else {
        updateLocation(MapState.default_location);
      }
    }
  }

  //Change map camera location
  void updateLocation(LatLng latlng) {
    state.markerPosition.value = latlng;
    //Animate map
    state.mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 15.0),
      ),
    );
  }

  //search places
  void searchPlace() async {
    final place = await PlacesAutocomplete.show(
        context: Get.context!,
        apiKey: 'AIzaSyD9qD3wenmtkSlG9S35yKD02TBsjbwzars',
        mode: Mode.overlay,
        types: [],
        strictbounds: false,
        onError: (err) {
          debugPrint(err.errorMessage);
        });

    if (place != null) {
      state.searchLocationName.value = place.description.toString();
      final plist = GoogleMapsPlaces(
        apiKey: "AIzaSyD9qD3wenmtkSlG9S35yKD02TBsjbwzars",
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      final detail = await plist.getDetailsByPlaceId(place.placeId ?? "0");
      final geometry = detail.result.geometry!;
      final latLng = LatLng(geometry.location.lat, geometry.location.lng);
      updateLocation(latLng);
    }
  }
}
