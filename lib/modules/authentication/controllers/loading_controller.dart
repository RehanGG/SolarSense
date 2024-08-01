import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:solarsense/models/field_exception.dart';
import 'package:solarsense/models/user_profile_model.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/services/app_controller.dart';

class LoadingController extends GetxController {
  static LoadingController get to => Get.find();

  @override
  void onInit() {
    Get.engine.addPostFrameCallback((_) {
      loadUser();
    });
    super.onInit();
  }

  //Initially Load user from Firestore
  Future<void> loadUserFromFirestore() async {
    late final Map<String, dynamic> data;

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection(FirestoreConstants.USERS)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    if (!snapshot.exists) {
      data = await createUser();
    } else {
      data = snapshot.data()!;
    }

    final UserProfileModel user =
        UserProfileModel.fromJson(data, FirebaseAuth.instance.currentUser!.uid);
    AppController.to.state.appUser.value = user;
  }

  Future<Map<String, dynamic>> createUser() async {
    try {
      final result = await Get.toNamed(Routes.CREATE_NEW_ACCOUNT);
      return result;
    } catch (_) {
      return await createUser();
    }
  }

  //Verify Email
  Future<void> verifyEmail() async {
    try {
      final bool result = await Get.toNamed(Routes.VERIFY_EMAIL_VIEW);
      if (result != true) {
        await verifyEmail();
      }
    } catch (error) {
      await verifyEmail();
    }
  }

  void loadUser() async {
    try {
      await loadUserFromFirestore();
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        await verifyEmail();
      }
      Get.offAllNamed(Routes.DASHBOARD_VIEW);
    } catch (_) {
      Get.offAllNamed(Routes.LOGIN_VIEW);
    }
  }
}
