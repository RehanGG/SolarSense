import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/constants.dart';
import '../services/app_controller.dart';

class AuthAppBar extends StatelessWidget {
  final String text;
  const AuthAppBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
      width: double.infinity,
      color: AppController.to.state.currentTheme.value == ThemeMode.dark
          ? ColorConstants.primaryDarkColor
          : ColorConstants.primaryColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Image.asset(
              'assets/icon.png',
              height: 100.h,
            ),
            Text(
              'SolarSense',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
