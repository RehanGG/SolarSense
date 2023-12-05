import 'package:get/get.dart';
import 'package:solarsense/modules/map/controllers/map_controller.dart';

class MapBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<MapController>(MapController());
  }
}
