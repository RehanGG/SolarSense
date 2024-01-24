import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/modules/dashboard/views/pvgis_view.dart';
import 'package:solarsense/shared/services/app_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/app_drawer.dart';
import 'package:get/get.dart';

enum CalculationState {
  Select,
  Selected,
  Calculate,
}

class CalculateSpotView extends StatefulWidget {
  const CalculateSpotView({Key? key}) : super(key: key);

  @override
  State<CalculateSpotView> createState() => _CalculateSpotViewState();
}

class _CalculateSpotViewState extends State<CalculateSpotView> {
  Map<String, dynamic> currentState = {
    'state': CalculationState.Select,
  };

  AppBar appBar() {
    return AppBar(
      backgroundColor: ColorConstants.primaryColor,
      title: const Text('Calculate Spot'),
      actions: [
        if (currentState['state'] == CalculationState.Calculate)
          IconButton(
              onPressed: () {
                setState(() {
                  currentState['state'] = CalculationState.Select;
                  currentState.remove('selectedLocation');
                });
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 30.w,
              ))
      ],
      centerTitle: true,
    );
  }

  Widget _selectLoc() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(200.w),
        ),
        onPressed: () async {
          late final LatLng selectLoc;
          if (currentState.containsKey('selectedLocation')) {
            selectLoc = currentState['selectedLocation'];
          } else {
            selectLoc = LatLng(
                AppController.to.state.appUser.value!.location.coordinates.lat,
                AppController
                    .to.state.appUser.value!.location.coordinates.long);
          }

          final result =
              await Get.toNamed(Routes.MAP_VIEW, arguments: selectLoc);
          if (result != null) {
            currentState['selectedLocation'] =
                LatLng(result['lat'], result['lng']);
            currentState['state'] = CalculationState.Selected;
            setState(() {});
          }
        },
        child: const Text(
          'Select Location',
          style: TextStyle(letterSpacing: 1.5, color: Colors.white),
        ));
  }

  Widget _calculateLoc() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(200.w),
        ),
        onPressed: () async {
          setState(() {
            currentState['state'] = CalculationState.Calculate;
          });
        },
        child: const Text(
          'Calculate',
          style: TextStyle(letterSpacing: 1.5, color: Colors.white),
        ));
  }

  Widget content() {
    if (currentState['state'] == CalculationState.Select ||
        currentState['state'] == CalculationState.Selected) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select the location to continue...',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            _selectLoc(),
            if (currentState['state'] == CalculationState.Selected)
              _calculateLoc(),
          ],
        ),
      );
    }
    return PVGChartPage(
      lat: (currentState['selectedLocation'] as LatLng).latitude,
      lng: (currentState['selectedLocation'] as LatLng).longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        index: 3,
      ),
      appBar: appBar(),
      body: content(),
    );
  }
}
