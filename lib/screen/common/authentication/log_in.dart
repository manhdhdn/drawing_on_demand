import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/app_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/account_api.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../welcome_screen/welcome_screen.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  static const String tag = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kDarkWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 180,
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 85,
                width: 110,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/logo2.png'), fit: BoxFit.cover),
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Log In Your Account',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                cursorColor: kNeutralColor,
                textInputAction: TextInputAction.next,
                decoration: kInputDecoration.copyWith(
                  labelText: 'Email',
                  labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                  hintText: 'Enter your email',
                  hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                  focusColor: kNeutralColor,
                  border: const OutlineInputBorder(),
                ),
                controller: emailController,
                autofillHints: const [AutofillHints.username],
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.text,
                cursorColor: kNeutralColor,
                obscureText: hidePassword,
                textInputAction: TextInputAction.done,
                decoration: kInputDecoration.copyWith(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                  hintText: 'Please enter your password',
                  hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: kLightNeutralColor,
                    ),
                  ),
                ),
                controller: passwordController,
                autofillHints: const [AutofillHints.password],
                onEditingComplete: () {
                  onLogin();
                },
              ),
              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => const ForgotPassword().launch(context),
                    child: Text(
                      'Forgot Password?',
                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ButtonGlobalWithoutIcon(
                  buttontext: 'Log In',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    onLogin();
                  },
                  buttonTextColor: kWhite),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: kBorderColorTextField,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      'Or Sign up with',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: kBorderColorTextField,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialIcon(
                      bgColor: kNeutralColor,
                      iconColor: kWhite,
                      icon: FontAwesomeIcons.facebookF,
                      borderColor: Colors.transparent,
                    ),
                    SocialIcon(
                      bgColor: kWhite,
                      iconColor: kNeutralColor,
                      icon: FontAwesomeIcons.google,
                      borderColor: kBorderColorTextField,
                    ),
                    SocialIcon(
                      bgColor: kWhite,
                      iconColor: Color(0xFF76A9EA),
                      icon: FontAwesomeIcons.twitter,
                      borderColor: kBorderColorTextField,
                    ),
                    SocialIcon(
                      bgColor: kWhite,
                      iconColor: Color(0xFFFF554A),
                      icon: FontAwesomeIcons.instagram,
                      borderColor: kBorderColorTextField,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: GestureDetector(
                  onTap: () {
                    onCreateNewAccount();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                      children: [
                        TextSpan(
                          text: 'Create New Account',
                          style: kTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onLogin() async {
    try {
      ProgressDialogUtils.showProgress(context);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      var account = await AccountApi().gets(
        0,
        filter: "email eq '${emailController.text.trim()}'",
        expand: 'accountRoles(expand=role),rank',
      );

      // Save account information
      PrefUtils().setAccount(account.value.first);

      // Save token
      var token = await FirebaseAuth.instance.currentUser!.getIdToken();
      PrefUtils().setToken(token!);

      // Navigator
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      var roles = account.value.first.accountRoles!
          .map((accountRole) => accountRole.role!.name)
          .toSet();
      if (roles.contains('Artist')) {
        PrefUtils().setRole('Artist');
        PrefUtils().setRank(account.value.first.rank!.name!);
      } else if (roles.contains('Customer')) {
        PrefUtils().setRole('Customer');
      } else {
        throw 'Account is not supported';
      }

      onLogedIn();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: 'Invalid email or password');
    }
  }

  void onLogedIn() {
    Phoenix.rebirth(context);

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.defaultTag,
      (route) => false,
    );
  }

  void onCreateNewAccount() {
    Navigator.pushNamed(context, WelcomeScreen.tag);
  }
}
