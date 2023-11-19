import 'package:get/get.dart';
import 'package:solarsense/shared/services/app_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController());
  }
}
