import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarsense/shared/constants/constants.dart';

import '../../../shared/widgets/loading_indicator.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            const LoadingIndicator(),
            SizedBox(height: 10.h),
            Text(
              'Charging the Solar Journey...',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstants.secondaryColor,
                  fontSize: 18.sp,
                  letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
