import 'package:auto_route/auto_route.dart';
import 'package:drawing_on_demand/routes/app_router.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    router.push(LoginRoute(onResult: (result) {
      if (result == true) {
        resolver.next(true);
        router.removeLast();
      }
    }));
  }
}
