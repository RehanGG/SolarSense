import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solarsense/shared/widgets/app_drawer.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  AppBar appBar() {
    return AppBar(
      title: const Text('Dashboard'),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        index: 1,
      ),
      appBar: appBar(),
      body: Center(
        child: Image.asset(
          'assets/ud.png',
          height: 400.h,
        ),
      ),
    );
  }
}
