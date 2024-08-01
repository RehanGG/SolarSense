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

import '../../../shared/services/app_controller.dart';

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
          signInWithGoogle(),
          SizedBox(height: 80.h),
          relatedWidgets(),
        ],
      ),
    );
  }

  Widget signInWithGoogle() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurple)),
      onPressed: () {
        controller.loginGoogle();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage(
              'assets/google.png',
            ),
            radius: 10.h,
          ),
          SizedBox(
            width: 10.w,
          ),
          const Text(
            'Sign in with Google',
            style: TextStyle(
                fontSize: 15.0, letterSpacing: 1.0, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              AppController.to.state.currentTheme.value == ThemeMode.dark
                  ? ColorConstants.primaryDarkColor
                  : ColorConstants.primaryColor,
          fixedSize: const Size.fromWidth(double.maxFinite),
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
