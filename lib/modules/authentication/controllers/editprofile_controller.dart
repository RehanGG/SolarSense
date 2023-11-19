import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/services/app_controller.dart';

import '../../../models/field_exception.dart';
import '../../../shared/constants/utilities.dart';

class EditProfileController extends GetxController {
  static EditProfileController get to => Get.find();
  final TextEditingController fullName = TextEditingController(
      text: AppController.to.state.appUser.value!.fullName);

  void updateProfile() async {
    showLoadingScreen();
    try {
      if (fullName.text.isEmpty) {
        throw const FieldException('Enter your full name', 'Name');
      }
      await FirebaseFirestore.instance
          .collection(FirestoreConstants.USERS)
          .doc(AppController.to.state.appUser.value!.userId)
          .update({'fullname': fullName.text});

      AppController.to.state.appUser.value = AppController
          .to.state.appUser.value!
          .copyWith({'fullname': fullName.text});
      hideLoadingScreen();
      showGetSnackBar('Success', 'Profile Updated Successfully!',
          variant: 'success');
    } on FirebaseException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.code, e.message ?? "");
    } on FieldException catch (e) {
      hideLoadingScreen();
      showGetSnackBar(e.title, e.message);
    }
  }
}
