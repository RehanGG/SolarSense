import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarsense/shared/constants/utilities.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/services/app_controller.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  AppBar appBar() {
    return AppBar(
      backgroundColor: ColorConstants.primaryColor,
      title: const Text('Verify Email'),
      centerTitle: true,
    );
  }

  late final Timer timer;
  bool willPop = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setupVerification();
    });
    super.initState();
  }

  void setupVerification() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        setState(() {
          willPop = true;
        });
        this.timer.cancel();
        Get.back(result: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: willPop,
      child: Scaffold(
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please verify your email. Check your email for verification instructions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                  backgroundColor:
                      MaterialStateProperty.all(ColorConstants.accentColor),
                  fixedSize: MaterialStateProperty.all(
                      Size.fromWidth(MediaQuery.of(context).size.width * 0.7)),
                ),
                onPressed: () async {
                  showLoadingScreen();
                  try {
                    await FirebaseAuth.instance.currentUser!
                        .sendEmailVerification();
                    Get.back();
                    showGetSnackBar('Email Sent',
                        'Verification instructions sent to your email!',
                        variant: 'success');
                  } catch (error) {
                    Get.back();
                  }
                },
                child: const Text('Send Email Again',
                    style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  fixedSize: MaterialStateProperty.all(
                      Size.fromWidth(MediaQuery.of(context).size.width * 0.7)),
                ),
                onPressed: () {
                  timer.cancel();
                  AppController.to.signOutUser();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
