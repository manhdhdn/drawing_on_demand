import 'package:flutter/material.dart';

import '../screen/client_screen/authentication/client_create_profile.dart';
import '../screen/client_screen/home/client_home.dart';
import '../screen/client_screen/home/client_home_screen.dart';
import '../screen/client_screen/home/popular_services.dart';
import '../screen/client_screen/home/recently_view.dart';
import '../screen/client_screen/home/top_seller.dart';
import '../screen/client_screen/job_post/job_details.dart';
import '../screen/client_screen/job_post/job_post.dart';
import '../screen/client_screen/profile/client_profile_details.dart';
import '../screen/common/authentication/log_in.dart';
import '../screen/common/authentication/opt_verification.dart';
import '../screen/common/authentication/sign_up.dart';
import '../screen/common/setting/language.dart';
import '../screen/common/setting/setting.dart';
import '../screen/common/splash_screen/onboard.dart';
import '../screen/common/welcome_screen/welcome_screen.dart';
import '../screen/seller_screen/authentication/seller_create_profile.dart';
import '../screen/seller_screen/home/seller_home.dart';
import '../screen/seller_screen/request/seller_buyer_request.dart';
import '../screen/seller_screen/services/create_new_service.dart';
import '../screen/seller_screen/services/create_service.dart';
import '../screen/common/artwork/service_details.dart';

class AppRoutes {
  static const String defaultTag = '/';

  static Map<String, WidgetBuilder> guestRoutes = {
    defaultTag: (context) => const Login(),
    OnBoard.tag: (context) => const OnBoard(),
    WelcomeScreen.tag: (context) => const WelcomeScreen(),
    SignUp.tag: (context) => const SignUp(),
    OtpVerification.tag: (context) => const OtpVerification(),
    ClientCreateProfile.tag: (context) => const ClientCreateProfile(),
    SellerCreateProfile.tag: (context) => const SellerCreateProfile(),
    Login.tag: (context) => const Login(),
  };

  static Map<String, WidgetBuilder> customerRoutes = {
    defaultTag: (context) => const ClientHome(),
    ClientHome.tag: (context) => const ClientHome(),
    JobPost.tag: (context) => const JobPost(),
    JobDetails.tag: (context) => const JobDetails(),
    ClientProfileDetails.tag: (context) => const ClientProfileDetails(),
    ClientHomeScreen.tag: (context) => const ClientHomeScreen(),
    PopularServices.tag: (context) => const PopularServices(),
    RecentlyView.tag: (context) => const RecentlyView(),
    TopSeller.tag: (context) => const TopSeller(),
    ServiceDetails.tag: (context) => const ServiceDetails(),
  };

  static Map<String, WidgetBuilder> artistRoutes = {
    defaultTag: (context) => const SellerHome(),
    SellerHome.tag: (context) => const SellerHome(),
    CreateService.tag: (context) => const CreateService(),
    CreateNewService.tag: (context) => const CreateNewService(),
    ServiceDetails.tag: (context) => const ServiceDetails(),
    SellerBuyerReq.tag: (context) => const SellerBuyerReq(),
  };

  static Map<String, WidgetBuilder> commonRoutes = {
    Setting.tag: (context) => const Setting(),
    Language.tag: (context) => const Language(),
  };

  static Map<String, WidgetBuilder> getRoutes(String? role) {
    switch (role) {
      case 'Customer':
        customerRoutes.addAll(commonRoutes);

        return customerRoutes;
      case 'Artist':
        artistRoutes.addAll(commonRoutes);

        return artistRoutes;
      default:
        return guestRoutes;
    }
  }
}
