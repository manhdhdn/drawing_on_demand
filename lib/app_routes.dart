import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screen/client_screen/authentication/client_create_profile.dart';
import 'screen/client_screen/home/client_home.dart';
import 'screen/common/authentication/log_in.dart';
import 'screen/common/authentication/opt_verification.dart';
import 'screen/common/authentication/sign_up.dart';
import 'screen/common/messgae/chat_list.dart';
import 'screen/common/splash_screen/mt_splash_screen.dart';
import 'screen/common/splash_screen/onboard.dart';
import 'screen/common/welcome_screen/welcome_screen.dart';
import 'screen/seller_screen/authentication/seller_create_profile.dart';
import 'screen/seller_screen/home/seller_home.dart';

class AppRoutes {
  // static const String splash = '/splash';
  // static const String onBoard = '/onboard';
  // static const String welcome = '/';
  // static const String login = '/login';
  // static const String signUp = '/sign_up';
  // static const String verify = '/verify';

  // // common
  // static const String chat = '/chat';

  // // customer
  // static const String clientSetupProfile = '/customer/setup_profile';
  // static const String client = '/customer';
  // static const String clientHome = '/customer/home';
  // static const String clientJobPost = '/customer/job_post';
  // static const String clientOrder = '/customer/order';
  // static const String clientProfile = '/customer/profile';

  // // artist
  // static const String sellerSetupProfile = '/artist/setup_profile';
  // static const String seller = '/artist';
  // static const String sellerHome = '/artist/home';
  // static const String jobApply = '/artist/job_apply';
  // static const String sellerOrder = '/artist/order';
  // static const String sellerProfile = '/artist/profile';

  // static Map<String, WidgetBuilder> routes = {
  //   splash: (context) => const SplashScreen(),
  //   onBoard: (context) => const OnBoard(),
  //   welcome: (context) => const WelcomeScreen(),
  //   login: (context) => const LogIn(),
  //   signUp: (context) => const SignUp(),
  //   verify: (context) => const OtpVerification(),

  //   // common
  //   chat: (context) => const ChatScreen(),

  //   // customer
  //   clientSetupProfile: (context) => const ClientCreateProfile(),
  //   client: (context) => const ClientHome(),
  //   clientHome: (context) => const ClientHome(),
  //   clientJobPost: (context) => const ClientHome(),
  //   clientOrder: (context) => const ClientHome(),
  //   clientProfile: (context) => const ClientHome(),

  //   // artist
  //   sellerSetupProfile: (context) => const SellerCreateProfile(),
  //   seller: (context) => const SellerHome(),
  // };

  final GoRouter router = GoRouter(routes: [
    GoRoute(
      name: 'welcome',
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: 'customer',
      path: '/customer',
      builder: (context, state) => const ClientHome(),
    ),
    GoRoute(
      name: 'artist',
      path: '/artist',
      builder: (context, state) => const SellerHome(),
    ),
  ]);
}
