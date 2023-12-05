import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/modules/map/controllers/map_controller.dart';
import 'package:solarsense/modules/map/state/map_state.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/widgets/loading_indicator.dart';

class MapView extends GetView<MapController> {
  const MapView({Key? key}) : super(key: key);

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
            'lat': controller.state.markerPosition.value.latitude,
            'lng': controller.state.markerPosition.value.longitude
          });
        },
        child: const Text(
          'Confirm',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget backButton() {
    return GestureDetector(
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
    );
  }

  Widget currentLocationIcon() {
    return GestureDetector(
      onTap: () {
        controller.updateLocation(LatLng(
            controller.state.currentPosition!.latitude,
            controller.state.currentPosition!.longitude));
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: ColorConstants.primaryColor),
        child: Icon(
          Icons.my_location_sharp,
          color: Colors.white,
          size: 20.w,
        ),
      ),
    );
  }

  Widget searchPlaces() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius: BorderRadius.circular(40.h)),
      width: double.infinity,
      child: ListTile(
        onTap: () {
          controller.searchPlace();
        },
        leading: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        title: Text(
          controller.state.searchLocationName.value ?? 'Search a location',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget topArea() {
    return Positioned(
      top: 50.h,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(),
            Expanded(
              child: searchPlaces(),
            ),
            currentLocationIcon(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.state.loading.isTrue) {
          return const Center(
            child: LoadingIndicator(),
          );
        }
        return Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('selectedLocation'),
                  position: controller.state.markerPosition.value,
                ),
              },
              onCameraMove: (CameraPosition position) {
                controller.state.markerPosition.value = position.target;
              },
              onMapCreated: (GoogleMapController controller) {
                this.controller.state.mapController = controller;
                this.controller.completeMap();
              },
              initialCameraPosition: const CameraPosition(
                target: MapState.default_location,
                zoom: 12.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
            confirmButton(),
            topArea(),
          ],
        );
      }),
    );
  }
}
