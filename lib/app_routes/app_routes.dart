import 'package:flutter/material.dart';

import '../screen/client_screen/authentication/client_create_profile.dart';
import '../screen/client_screen/home/client_home.dart';
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
import '../screen/seller_screen/services/create_service.dart';

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
  };

  static Map<String, WidgetBuilder> artistRoutes = {
    defaultTag: (context) => const SellerHome(),
    SellerHome.tag: (context) => const SellerHome(),
    CreateService.tag: (context) => const CreateService(),
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
