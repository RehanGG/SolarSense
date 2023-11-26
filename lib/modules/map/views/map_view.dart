import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/constants/utilities.dart';
import 'package:solarsense/shared/widgets/loading_indicator.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const LatLng default_location =
      LatLng(33.67715534264639, 73.06801369657997);

  bool loading = true;
  GoogleMapController? mapController;
  LatLng? markerPosition = default_location;

  Position? currentPosition;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setupMap();
    });
    super.initState();
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
      currentPosition = await Geolocator.getCurrentPosition();
    } catch (_) {
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void completeMap() {
    //Check if location is already selected
    final arguments = Get.arguments;
    if (arguments != null) {
      final LatLng selectedLocation = Get.arguments as LatLng;
      updateLocation(selectedLocation);
    } else {
      if (currentPosition != null) {
        final LatLng latlng =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);
        updateLocation(latlng);
      } else {
        updateLocation(default_location);
      }
    }
  }

  void updateLocation(LatLng latlng) {
    markerPosition = latlng;
    //Animate map
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 15.0),
      ),
    );
  }

  Widget confirmButton() {
    return Positioned(
      bottom: 30.h,
      left: 60.w,
      right: 60.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.accentColor),
        onPressed: () {
          Get.back(result: {
            'lat': markerPosition!.latitude,
            'lng': markerPosition!.longitude
          });
        },
        child: const Text('Confirm'),
      ),
    );
  }

  Widget backButton() {
    return Positioned(
      top: 50.h,
      left: 13.w,
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: ColorConstants.primaryColor),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20.w,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: LoadingIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  markers: markerPosition == null
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('selectedLocation'),
                            position: markerPosition!,
                          ),
                        },
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      markerPosition = position.target;
                    });
                  },
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    completeMap();
                  },
                  initialCameraPosition: const CameraPosition(
                    target: default_location,
                    zoom: 12.0,
                  ),
                  myLocationEnabled: true,
                ),
                confirmButton(),
                backButton(),
              ],
            ),
    );
  }
}
