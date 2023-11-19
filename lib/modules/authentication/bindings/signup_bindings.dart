import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/signup_controller.dart';

class SignupBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SignupController>(SignupController());
  }
}
