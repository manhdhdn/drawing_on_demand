import 'package:drawing_on_demand/screen/client_screen/home/client_home.dart';
import 'package:drawing_on_demand/screen/client_screen/authentication/client_create_profile.dart';
import 'package:drawing_on_demand/screen/common/log_in.dart';
import 'package:drawing_on_demand/screen/common/opt_verification.dart';
import 'package:drawing_on_demand/screen/common/sign_up.dart';
import 'package:drawing_on_demand/screen/seller_screen/home/seller_home.dart';
import 'package:drawing_on_demand/screen/seller_screen/authentication/seller_create_profile.dart';
import 'package:drawing_on_demand/screen/splash_screen/mt_splash_screen.dart';
import 'package:drawing_on_demand/screen/splash_screen/onboard.dart';
import 'package:drawing_on_demand/screen/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onBoard = '/onboard';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String clientHome = '/client_home';
  static const String sellerHome = '/seller_home';
  static const String signUp = '/sign_up';
  static const String verify = '/verify';
  static const String sellerSetupProfile = '/seller_setup_profile';
  static const String clientSetupProfile = '/client_setup_profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    onBoard: (context) => const OnBoard(),
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LogIn(),
    clientHome: (context) => const ClientHome(),
    sellerHome: (context) => const SellerHome(),
    signUp: (context) => const SignUp(),
    verify: (context) => const OtpVerification(),
    sellerSetupProfile: (context) => const SellerCreateProfile(),
    clientSetupProfile: (context) => const ClientCreateProfile(),
  };
}
