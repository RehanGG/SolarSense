import 'package:get/get.dart';
import 'package:solarsense/modules/admin/views/manage_users_view.dart';
import 'package:solarsense/modules/authentication/bindings/editprofile_bindings.dart';
import 'package:solarsense/modules/authentication/bindings/loading_bindings.dart';
import 'package:solarsense/modules/authentication/bindings/login_bindings.dart';
import 'package:solarsense/modules/authentication/bindings/signup_bindings.dart';
import 'package:solarsense/modules/authentication/views/editprofile_view.dart';
import 'package:solarsense/modules/authentication/views/loading_view.dart';
import 'package:solarsense/modules/authentication/views/login_view.dart';
import 'package:solarsense/modules/authentication/views/resetpass_view.dart';
import 'package:solarsense/modules/authentication/views/signup_view.dart';
import 'package:solarsense/modules/authentication/views/verify_email_view.dart';
import 'package:solarsense/modules/dashboard/views/calculate_spot_view.dart';
import 'package:solarsense/modules/dashboard/views/dashboard_view.dart';
import 'package:solarsense/modules/map/bindings/map_bindings.dart';
import 'package:solarsense/modules/map/views/map_view.dart';
import 'package:solarsense/routes/app_routes.dart';

import '../modules/authentication/bindings/resetpass_bindings.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> authRoutes = [
    GetPage(
      name: Routes.LOADING_VIEW,
      page: () => const LoadingView(),
      binding: LoadingBindings(),
    ),
    GetPage(
      name: Routes.LOGIN_VIEW,
      page: () => const LoginView(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: Routes.SIGNUP_VIEW,
      page: () => const SignupView(),
      binding: SignupBindings(),
    ),
    GetPage(
      name: Routes.RESETPASS_VIEW,
      page: () => const ResetPassView(),
      binding: ResetPassBindings(),
    ),
    GetPage(
      name: Routes.EDITPROFILE_VIEW,
      page: () => const EditProfileView(),
      binding: EditProfileBindings(),
    ),
    GetPage(
      name: Routes.VERIFY_EMAIL_VIEW,
      page: () => const VerifyEmailView(),
    ),
  ];

  static final List<GetPage> dashboardRoutes = [
    GetPage(
      name: Routes.DASHBOARD_VIEW,
      page: () => const DashboardView(),
    ),
    GetPage(
      name: Routes.CALCULATE_SPOT_VIEW,
      page: () => const CalculateSpotView(),
    ),
  ];

  static final List<GetPage> adminRoutes = [
    GetPage(
      name: Routes.MANAGE_USERS_VIEW,
      page: () => const ManageUsersView(),
    ),
  ];

  static final List<GetPage> commonRoutes = [
    GetPage(
      name: Routes.MAP_VIEW,
      page: () => const MapView(),
      binding: MapBindings(),
    ),
  ];

  static final List<GetPage> routes = [
    ...authRoutes,
    ...dashboardRoutes,
    ...adminRoutes,
    ...commonRoutes,
  ];
}
