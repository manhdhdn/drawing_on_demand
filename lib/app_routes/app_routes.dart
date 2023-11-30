import 'package:flutter/material.dart';

import '../screen/client_screen/authentication/client_create_profile.dart';
import '../screen/client_screen/home/client_home.dart';
import '../screen/common/authentication/log_in.dart';
import '../screen/common/authentication/opt_verification.dart';
import '../screen/common/authentication/sign_up.dart';
import '../screen/common/splash_screen/mt_splash_screen.dart';
import '../screen/common/splash_screen/onboard.dart';
import '../screen/common/welcome_screen/welcome_screen.dart';
import '../screen/seller_screen/authentication/seller_create_profile.dart';
import '../screen/seller_screen/home/seller_home.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onBoard = '/onboard';
  static const String welcome = '/';
  static const String login = '/login';
  static const String signUp = '/sign_up';
  static const String verify = '/verify';

  // common

  // customer
  static const String client = '/customer';
  static const String clientSetupProfile = '$client/setup_profile';
  static const String clientHome = '$client/home';
  static const String clientChat = '$client/chat';
  static const String jobPost = '$client/job_post';
  static const String clientOrder = '$client/order';
  static const String clientProfile = '$client/profile';
  static const String jobPostDetail = '$client/job_post/:id';

  // artist
  static const String seller = '/artist';
  static const String sellerSetupProfile = '$seller/setup_profile';
  static const String sellerHome = '$seller/home';
  static const String sellerChat = '$seller/chat';
  static const String jobApply = '$seller/job_apply';
  static const String sellerOrder = '$seller/order';
  static const String sellerProfile = '$seller/profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onBoard: (context) => const OnBoard(),
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LogIn(),
    signUp: (context) => const SignUp(),
    verify: (context) => const OtpVerification(),

    // common

    // customer
    clientSetupProfile: (context) => const ClientCreateProfile(),
    client: (context) => const ClientHome(),
    clientChat: (context) => const ClientHome(),
    clientHome: (context) => const ClientHome(),
    jobPost: (context) => const ClientHome(),
    clientOrder: (context) => const ClientHome(),
    clientProfile: (context) => const ClientHome(),
    // jobPostDetail: (context) => const JobDetails(),

    // artist
    sellerSetupProfile: (context) => const SellerCreateProfile(),
    seller: (context) => const SellerHome(),
  };
}
