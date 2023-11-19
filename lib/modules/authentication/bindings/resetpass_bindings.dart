import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/resetpass_controller.dart';

class ResetPassBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ResetPassController>(ResetPassController());
  }
}
