import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarsense/shared/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstants.primaryColor.withOpacity(0.2)),
        color: Colors.grey.withOpacity(0.1),
      ),
      margin: EdgeInsets.only(bottom: 8.h),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
