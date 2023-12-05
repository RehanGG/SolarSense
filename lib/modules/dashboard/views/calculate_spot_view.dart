import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:solarsense/shared/constants/utilities.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/app_drawer.dart';

class CalculateSpotView extends StatefulWidget {
  const CalculateSpotView({Key? key}) : super(key: key);

  @override
  State<CalculateSpotView> createState() => _CalculateSpotViewState();
}

class _CalculateSpotViewState extends State<CalculateSpotView> {
  GoogleMapController? mapController;
  LatLng? markerPosition;
  Map<String, dynamic>? optimalData;

  AppBar appBar() {
    return AppBar(
      backgroundColor: ColorConstants.primaryColor,
      title: const Text('Calculate Spot'),
      centerTitle: true,
    );
  }

  Widget dataColumn() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inputs:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          Text(
              'Input Latitude: ${optimalData!['inputs']['location']['latitude']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Input Latitude: ${optimalData!['inputs']['location']['longitude']}',
              style: TextStyle(fontSize: 13.sp)),
          Text('Elevation: ${optimalData!['inputs']['location']['elevation']}',
              style: TextStyle(fontSize: 13.sp)),
          SizedBox(
            height: 30.h,
          ),
          Text(
            'Outputs:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
          Text(
              'Global horizontal solar radiation: ${optimalData!['outputs']['hourly'][0]['Gb(i)']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Direct horizontal solar radiation ${optimalData!['outputs']['hourly'][0]['Gd(i)']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Diffuse horizontal solar radiation ${optimalData!['outputs']['hourly'][0]['Gr(i)']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Solar height / Elevation angle : ${optimalData!['outputs']['hourly'][0]['H_sun']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Temperature at 2 meters above the ground: ${optimalData!['outputs']['hourly'][0]['T2m']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Wind speed at 10 meters above the ground: ${optimalData!['outputs']['hourly'][0]['WS10m']}',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Optical Orientation: ${optimalData!['inputs']['mounting_system']['fixed']['azimuth']['value']} degrees',
              style: TextStyle(fontSize: 13.sp)),
          Text(
              'Optical Inclination: ${optimalData!['inputs']['mounting_system']['fixed']['slope']['value']} degrees',
              style: TextStyle(fontSize: 13.sp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        index: 3,
      ),
      appBar: appBar(),
      body: optimalData == null
          ? GoogleMap(
              markers: (markerPosition == null)
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId("selectedLocation"),
                        position: markerPosition!,
                      ),
                    },
              onCameraMove: (CameraPosition position) {
                // Update marker position as the camera moves
                setState(() {
                  markerPosition = position.target;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.7749, -122.4194), // Initial map center
                zoom: 12.0, // Initial zoom level
              ),
            )
          : dataColumn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            optimalData == null ? ColorConstants.primaryColor : Colors.red,
        onPressed: () async {
          if (optimalData != null) {
            setState(() {
              optimalData = null;
            });
            return;
          }
          //TODO: CHANGE LATER
          showLoadingScreen();
          try {
            final String apiUrl =
                'https://re.jrc.ec.europa.eu/api/seriescalc?lat=${markerPosition?.latitude}&lon=${markerPosition?.longitude}&startyear=2010&endyear=2015&peakpower=1&loss=10&pvcalculation=1&components=1&tracking=0&optimalangles=1&angle=0&aspect=180&outputformat=json';

            final response = await http.get(Uri.parse(apiUrl));

            if (response.statusCode == 200) {
              setState(() {
                optimalData = json.decode(response.body);
              });
            } else {
              throw Exception('Failed to load solar information');
            }
          } catch (_) {
          } finally {
            hideLoadingScreen();
          }
        },
        child: optimalData == null
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : Text(
                'X',
                style: TextStyle(fontSize: 25.sp),
              ),
      ),
    );
  }
}
