import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/create_new_account_controller.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/services/app_controller.dart';
import '../../../shared/widgets/auth_appbar.dart';
import '../../../shared/widgets/text_form_field.dart';
import '../widgets/select_location.dart';

class CreateNewAccountView extends GetView<CreateNewAccountController> {
  const CreateNewAccountView({Key? key}) : super(key: key);

  Widget _form() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 60.h, horizontal: 45.w),
      width: double.infinity,
      child: Column(
        children: [
          CustomTextField(
            controller: controller.state.fullName,
            hintText: 'Enter Full name',
          ),
          Obx(() {
            return SelectLocation(
              function: controller.getLocation,
              locationName: controller.state.locationName.value,
              selectedLocation: controller.state.selectedLocation.value,
            );
          }),
          SizedBox(
            height: 5.h,
          ),
          _signupButton(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _signupButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppController.to.state.currentTheme.value == ThemeMode.dark
                  ? ColorConstants.primaryDarkColor
                  : ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(160.w),
        ),
        onPressed: () {
          Get.focusScope?.unfocus();
          controller.createProfile();
        },
        child: const Text(
          'Create Profile',
          style: TextStyle(letterSpacing: 1.5, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.state.created,
      child: Scaffold(
        body: Column(
          children: [
            const AuthAppBar(text: 'Create Profile'),
            Expanded(
              child: SingleChildScrollView(
                child: _form(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
