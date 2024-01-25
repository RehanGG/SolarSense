import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarsense/app.dart';
import 'package:solarsense/routes/app_pages.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:solarsense/shared/constants/theme.dart';
import 'package:solarsense/shared/services/initial_bindings.dart';

void main() async {
  await App.initApp();
  runApp(const SolarSense());
}

class SolarSense extends StatelessWidget {
  const SolarSense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GetMaterialApp(
        initialBinding: InitialBindings(),
        debugShowCheckedModeBanner: false,
        title: 'SolarSense',
        themeMode: ThemeMode.system,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: Routes.LOADING_VIEW,
        getPages: AppPages.routes,
      ),
      builder: (BuildContext context, Widget? child) => child!,
    );
  }
}
