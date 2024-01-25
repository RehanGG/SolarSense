import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solarsense/routes/app_routes.dart';
import 'package:solarsense/shared/constants/constants.dart';
import 'package:solarsense/shared/services/app_controller.dart';

class AppDrawer extends StatelessWidget {
  final int index;
  const AppDrawer({Key? key, required this.index}) : super(key: key);

  Widget header() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(15.w),
        width: double.infinity,
        color: AppController.to.state.currentTheme.value == ThemeMode.dark
            ? ColorConstants.primaryDarkColor
            : ColorConstants.primaryColor,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                AppController.to.state.appUser.value!.fullName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                AppController.to.state.appUser.value!.email,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget tile(Function function, String text, int index, IconData icon) {
    return Material(
      color: this.index == index
          ? AppController.to.state.currentTheme.value == ThemeMode.dark
              ? ColorConstants.primaryDarkColor.withOpacity(0.1)
              : ColorConstants.secondaryColor.withOpacity(0.1)
          : Colors.transparent,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: 14.sp, letterSpacing: 1.0),
        ),
        style: ListTileStyle.drawer,
        onTap: () {
          if (index == this.index) {
            return;
          }
          function();
        },
        leading: Icon(
          icon,
          color: this.index == index
              ? AppController.to.state.currentTheme.value == ThemeMode.dark
                  ? ColorConstants.primaryDarkColor
                  : ColorConstants.secondaryColor
              : Colors.grey,
        ),
      ),
    );
  }

  Widget listTiles() {
    return SingleChildScrollView(
      child: Column(
        children: [
          tile(() {
            Get.offAllNamed(Routes.DASHBOARD_VIEW);
          }, 'Dashboard', 1, Icons.dashboard),
          tile(() {
            Get.toNamed(Routes.EDITPROFILE_VIEW);
          }, 'Edit Profile', 2, Icons.edit),
          tile(() {
            Get.offAllNamed(Routes.CALCULATE_SPOT_VIEW);
          }, 'Calculate Spot', 3, Icons.sunny),
          tile(() {
            AppController.to.switchTheme();
            Get.changeThemeMode(AppController.to.state.currentTheme.value);
          }, 'Switch Theme', 4, Icons.published_with_changes),
          if (AppController.to.state.appUser.value!.admin)
            tile(() {
              Get.toNamed(Routes.MANAGE_USERS_VIEW);
            }, 'Manage Users (Admin)', 20, Icons.manage_accounts),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          header(),
          Expanded(child: listTiles()),
          const Divider(
            color: ColorConstants.secondaryColor,
          ),
          tile(() {
            AppController.to.signOutUser();
          }, 'Sign out', 100, Icons.logout)
        ],
      ),
    );
  }
}
