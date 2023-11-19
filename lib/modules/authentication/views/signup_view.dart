import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:solarsense/modules/authentication/controllers/signup_controller.dart';
import 'package:solarsense/shared/widgets/auth_appbar.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/password_form_field.dart';
import '../../../shared/widgets/text_form_field.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

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
          CustomTextField(
            controller: controller.state.email,
            hintText: 'Enter Email',
          ),
          PasswordFormField(
              controller: controller.state.password,
              hintText: 'Enter Password'),
          SizedBox(
            height: 5.h,
          ),
          _signupButton(),
          SizedBox(height: 60.h),
          relatedWidgets(),
        ],
      ),
    );
  }

  Widget _signupButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(120.w),
        ),
        onPressed: () {
          Get.focusScope?.unfocus();
          controller.signupUser();
        },
        child: const Text(
          'SIGNUP',
          style: TextStyle(letterSpacing: 1.5),
        ));
  }

  Widget relatedWidgets() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
              text: 'Already signed up? ',
              style: TextStyle(fontSize: 14.sp),
              children: [
                TextSpan(
                    text: 'Log In!',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.offAllNamed(Routes.LOGIN_VIEW);
                      },
                    style: const TextStyle(
                      color: ColorConstants.thirdColor,
                      decoration: TextDecoration.underline,
                    ))
              ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AuthAppBar(text: 'SIGNUP'),
          Expanded(
            child: SingleChildScrollView(
              child: _form(),
            ),
          )
        ],
      ),
    );
  }
}
