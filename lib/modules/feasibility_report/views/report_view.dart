import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarsense/modules/feasibility_report/controllers/report_controller.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/text_form_field.dart';
import '../../authentication/widgets/select_location.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({Key? key}) : super(key: key);

  Widget _locationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your location:'),
        SizedBox(
          height: 5.h,
        ),
        Obx(() {
          return SelectLocation(
            function: controller.getLocation,
            locationName: controller.state.locationName.value,
            selectedLocation: controller.state.selectedLocation.value,
          );
        }),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  Widget _solarWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          inputText: TextInputType.number,
          controller: controller.state.installationPrice,
          hintText: 'Enter Installation Cost of Solar Panel',
        ),
        CustomTextField(
          inputText: TextInputType.number,
          controller: controller.state.electricityCost,
          hintText: 'Enter Electricity Cost (in kWh)',
        ),
        CustomTextField(
          inputText: TextInputType.number,
          controller: controller.state.panelCapacity,
          hintText: 'Enter Solar Panel Capacity (in kWh)',
        ),
        Obx(() {
          return GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: Get.context!,
                initialDate: controller.state.installationDate.value,
                firstDate: DateTime(1995, 8),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                controller.state.installationDate.value = picked;
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
              decoration: BoxDecoration(
                border: Border.all(
                    color: ColorConstants.primaryColor.withOpacity(0.2)),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Text(
                controller.state.installationDate.value == null
                    ? 'Select Installation Date'
                    : '${controller.state.installationDate.value!.year}-${controller.state.installationDate.value!.month}-${controller.state.installationDate.value!.day}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        })
      ],
    );
  }

  List<Step> stepList() => [
        Step(
            isActive: controller.state.currentStep.value == 0,
            title: const Text('Location Information'),
            content: _locationWidget()),
        Step(
          isActive: controller.state.currentStep.value == 1,
          title: const Text('Solar Panel Information'),
          content: _solarWidget(),
        ),
        Step(
          isActive: controller.state.currentStep.value == 2,
          title: const Text('Weather Data'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Getting weather data from installation date to next 12 months'),
              SizedBox(height: 20.h),
              const CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ],
          ),
        ),
        Step(
          isActive: controller.state.currentStep.value == 3,
          title: const Text('Power Produced - Prediction'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Using the weather data to get the power produced prediction using our AI model'),
              SizedBox(height: 20.h),
              const CircularProgressIndicator(
                strokeWidth: 3.0,
              ),
            ],
          ),
        ),
        Step(
          isActive: controller.state.currentStep.value == 4,
          title: const Text('Report Generated'),
          content: SizedBox(
            width: double.infinity,
            child: Obx(() {
              if (controller.state.generatePdf.isTrue) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generating PDF',
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 20.h),
                    const CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  ],
                );
              } else {
                return const Text('PDF Generated');
              }
            }),
          ),
        ),
      ];

  AppBar appBar() {
    return AppBar(
      title: const Text('Generate Report'),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const AppDrawer(
        index: 5,
      ),
      body: Obx(() {
        return Stepper(
          onStepTapped: controller.onStepTapped,
          onStepContinue: controller.onStepContinue,
          controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
            if (dtl.currentStep == 2 ||
                dtl.currentStep == 3 ||
                dtl.currentStep == 4) {
              return const Row();
            }

            return Row(
              children: <Widget>[
                TextButton(
                  onPressed: dtl.onStepContinue,
                  child: const Text('Next'),
                ),
              ],
            );
          },
          currentStep: controller.state.currentStep.value,
          steps: stepList(),
        );
      }),
    );
  }
}
