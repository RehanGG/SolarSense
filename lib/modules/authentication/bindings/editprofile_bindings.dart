import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/editprofile_controller.dart';

class EditProfileBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<EditProfileController>(EditProfileController());
  }
}
