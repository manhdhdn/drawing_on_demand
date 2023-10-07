import 'package:auto_route/auto_route.dart';
import 'package:drawing_on_demand/presentation/home_container_screen/home_container_screen.dart';
import 'package:drawing_on_demand/presentation/home_page/home_page.dart';
import 'package:drawing_on_demand/presentation/login_screen/login_screen.dart';
import 'package:drawing_on_demand/presentation/onboarding_one_screen/onboarding_one_screen.dart';
import 'package:drawing_on_demand/presentation/onboarding_three_screen/onboarding_three_screen.dart';
import 'package:drawing_on_demand/presentation/onboarding_two_screen/onboarding_two_screen.dart';
import 'package:drawing_on_demand/presentation/profile_page/profile_page.dart';
import 'package:drawing_on_demand/presentation/splash_screen/splash_screen.dart';
import 'package:drawing_on_demand/routes/guard/auth_guard.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        /// InitialRoute
        AutoRoute(page: HomeContainerRoute.page, initial: true),

        /// LoginRoute
        AutoRoute(page: LoginRoute.page),

        /// ProtectdRoute
        AutoRoute(page: ProfileRoute.page, guards: [AuthGuard()]),

        /// AlowedRoute
        AutoRoute(page: HomeRoute.page),
      ];
}
