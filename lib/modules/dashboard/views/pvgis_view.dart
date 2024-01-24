import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/widgets/loading_indicator.dart';

import '../../../shared/services/pvgisapi.dart';

class PVGChartPage extends StatefulWidget {
  final double lat;
  final double lng;

  const PVGChartPage({super.key, required this.lat, required this.lng});

  @override
  State<PVGChartPage> createState() => _PVGChartPageState();
}

class _PVGChartPageState extends State<PVGChartPage> {
  late final PVGsAPI pvgsAPIPower;
  late final PVGsAPI pvgsAPIIrradiance;
  bool isLoadingPower = true;
  bool isLoadingIrradiance = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //Fetch Data
  Future<void> fetchData() async {
    pvgsAPIPower = PVGsAPI(
      urlToRead:
          'https://re.jrc.ec.europa.eu/api/seriescalc?lat=${widget.lat}&lon=${widget.lng}&optimalangles=1&outputformat=json&startyear=2010&endyear=2015&pvtechchoice=CIS&pvcalculation=1&peakpower=1&loss=1',
      pv: true,
    );
    pvgsAPIIrradiance = PVGsAPI(
      urlToRead:
          'https://re.jrc.ec.europa.eu/api/seriescalc?lat=${widget.lat}&lon=${widget.lng}&optimalangles=1&outputformat=json&startyear=2010&endyear=2015&pvtechchoice=CIS&pvcalculation=1&peakpower=1&loss=1',
      pv: false,
    );

    await Future.wait([
      pvgsAPIPower.fetchData(),
      pvgsAPIIrradiance.fetchData(),
    ]);

    setState(() {
      isLoadingPower = false;
      isLoadingIrradiance = false;
    });
  }

  Widget _dataContainer(String text, value) {
    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
      color: ColorConstants.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingPower || isLoadingIrradiance) {
      return const Center(
        child: LoadingIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child:
                    _dataContainer('Latitude', widget.lat.toStringAsFixed(5)),
              ),
              Expanded(
                child:
                    _dataContainer('Longitude', widget.lng.toStringAsFixed(5)),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _dataContainer(
                    'Optimal Inclination', '${pvgsAPIPower.value[0]}°'),
              ),
              Expanded(
                child: _dataContainer(
                    'Optimal Orientation', '${pvgsAPIPower.value[1]}° S'),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          buildChart(
            pvgsAPIPower.data,
            pvgsAPIPower.pv ? 'Daily Mean Power' : 'Daily Mean Irradiance',
          ),
          buildChart(
            pvgsAPIIrradiance.data,
            pvgsAPIIrradiance.pv ? 'Daily Mean Power' : 'Daily Mean Irradiance',
          ),
        ],
      ),
    );
  }

  Widget buildChart(List<FlSpot> data, String chartTitle) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Text(
            chartTitle,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    colors: [
                      ColorConstants.secondaryColor,
                      ColorConstants.primaryColor
                    ],
                    barWidth: 2,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                // borderData: FlBorderData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
