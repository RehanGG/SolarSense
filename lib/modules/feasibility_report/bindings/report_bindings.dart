import 'package:get/get.dart';
import 'package:solarsense/modules/feasibility_report/controllers/report_controller.dart';

class ReportBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<ReportController>(ReportController());
  }
}
