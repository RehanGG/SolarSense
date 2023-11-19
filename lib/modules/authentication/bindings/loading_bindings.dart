import 'package:get/get.dart';
import 'package:solarsense/modules/authentication/controllers/loading_controller.dart';

class LoadingBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<LoadingController>(LoadingController());
  }
}
