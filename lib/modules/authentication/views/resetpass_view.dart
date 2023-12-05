import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:solarsense/modules/authentication/controllers/resetpass_controller.dart';
import 'package:solarsense/shared/constants/constants.dart';

import '../../../shared/widgets/text_form_field.dart';

class ResetPassView extends GetView<ResetPassController> {
  const ResetPassView({Key? key}) : super(key: key);

  Widget _form() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
      width: double.infinity,
      child: Column(
        children: [
          CustomTextField(
            controller: controller.email,
            hintText: 'Enter Email',
          ),
          SizedBox(
            height: 5.h,
          ),
          _resetButton(),
        ],
      ),
    );
  }

  Widget _resetButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(120.w),
        ),
        onPressed: () {
          Get.focusScope?.unfocus();
          controller.resetUser();
        },
        child: const Text(
          'Reset',
          style: TextStyle(letterSpacing: 1.5, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _form()),
    );
  }
}
