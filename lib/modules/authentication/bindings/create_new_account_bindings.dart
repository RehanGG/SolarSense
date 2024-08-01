import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/create_new_account_controller.dart';

class CreateNewAccountBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<CreateNewAccountController>(CreateNewAccountController());
  }
}
