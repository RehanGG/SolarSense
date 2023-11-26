import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solarsense/routes/app_routes.dart';

import '../../../shared/constants/constants.dart';

typedef SelectLocationFunction = void Function(LatLng);

class SelectLocation extends StatelessWidget {
  final String? locationName;
  final LatLng? selectedLocation;
  final SelectLocationFunction function;
  const SelectLocation(
      {Key? key,
      this.locationName,
      required this.function,
      this.selectedLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result =
            await Get.toNamed(Routes.MAP_VIEW, arguments: selectedLocation);
        if (result != null) {
          function(LatLng(result['lat'], result['lng']));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        width: double.infinity,
        decoration: BoxDecoration(
          border:
              Border.all(color: ColorConstants.primaryColor.withOpacity(0.2)),
          color: Colors.grey.withOpacity(0.1),
        ),
        margin: EdgeInsets.only(bottom: 8.h),
        child: Text(
          locationName == null ? 'Select Location' : locationName!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
      ),
    );
  }
}
