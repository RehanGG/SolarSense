import 'package:flutter/material.dart';
import 'package:solarsense/shared/widgets/app_drawer.dart';
import '../widgets/reports_list.dart';

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
      body: const ReportsList(),
    );
  }
}
