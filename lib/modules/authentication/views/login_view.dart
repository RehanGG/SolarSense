import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:solarsense/modules/authentication/controllers/login_controller.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/widgets/auth_appbar.dart';
import 'package:solarsense/shared/widgets/password_form_field.dart';
import 'package:solarsense/shared/widgets/text_form_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  Widget _form() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 60.h, horizontal: 45.w),
      width: double.infinity,
      child: Column(
        children: [
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
          _loginButton(),
          SizedBox(height: 80.h),
          relatedWidgets(),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryColor,
          fixedSize: Size.fromWidth(120.w),
        ),
        onPressed: () {
          Get.focusScope?.unfocus();
          controller.loginUser();
        },
        child: const Text(
          'LOGIN',
          style: TextStyle(letterSpacing: 1.5, color: Colors.white),
        ));
  }

  Widget relatedWidgets() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.RESETPASS_VIEW);
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: ColorConstants.thirdColor,
                decoration: TextDecoration.underline,
                fontSize: 14.sp),
          ),
        ),
        Text.rich(
          TextSpan(
              text: 'New on SolarSense? ',
              style: TextStyle(fontSize: 13.sp),
              children: [
                TextSpan(
                    text: 'Sign Up!',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.offAllNamed(Routes.SIGNUP_VIEW);
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
          const AuthAppBar(text: 'LOGIN'),
          Expanded(child: SingleChildScrollView(child: _form())),
        ],
      ),
    );
  }
}
