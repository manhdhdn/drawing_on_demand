import 'package:auto_route/auto_route.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/presentation/home_page/home_page.dart';
import 'package:drawing_on_demand/presentation/message_page/message_page.dart';
import 'package:drawing_on_demand/presentation/profile_page/profile_page.dart';
import 'package:drawing_on_demand/presentation/saved_page/saved_page.dart';
import 'package:drawing_on_demand/routes/app_router.dart';
import 'package:drawing_on_demand/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeContainerScreen extends StatelessWidget {
  HomeContainerScreen({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA70001,
        body: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.homePage,
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, ani, ani1) => getCurrentPage(routeSetting.name!),
            transitionDuration: const Duration(seconds: 1),
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          onChanged: (BottomBarEnum type) {
            AutoRouter.of(context).push(getCurrentRoute(type));
          },
        ),
      ),
    );
  }

  ///Handling route based on bottom click actions
  dynamic getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return HomeRoute();
      case BottomBarEnum.Message:
        return AppRoutes.messagePage;
      case BottomBarEnum.Saved:
        return AppRoutes.savedPage;
      case BottomBarEnum.Profile:
        return ProfileRoute();
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      case AppRoutes.homePage:
        return HomePage();
      case AppRoutes.messagePage:
        return MessagePage();
      case AppRoutes.savedPage:
        return SavedPage();
      case AppRoutes.profilePage:
        return ProfilePage();
      default:
        return const DefaultWidget();
    }
  }
}
