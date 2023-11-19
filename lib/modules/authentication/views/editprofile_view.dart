import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/editprofile_controller.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/text_form_field.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  Widget _form() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
      width: double.infinity,
      child: Column(
        children: [
          CustomTextField(
            controller: controller.fullName,
            hintText: 'Enter Full Name',
          ),
          SizedBox(
            height: 5.h,
          ),
          _updateButton(),
        ],
      ),
    );
  }

  Widget _updateButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(120.w),
        ),
        onPressed: () {
          Get.focusScope?.unfocus();
          controller.updateProfile();
        },
        child: const Text(
          'Save',
          style: TextStyle(letterSpacing: 1.5),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _form()),
    );
  }
}
