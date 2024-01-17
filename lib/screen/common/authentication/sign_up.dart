import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/account_api.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../../widgets/responsive.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController(text: PrefUtils().getSignUpInfor()['Name'] ?? '');
  TextEditingController emailController = TextEditingController(text: PrefUtils().getSignUpInfor()['Email'] ?? '');
  TextEditingController phoneController = TextEditingController(text: PrefUtils().getSignUpInfor()['Phone'] ?? '');
  TextEditingController passwordController = TextEditingController(text: PrefUtils().getSignUpInfor()['Password'] ?? '');

  bool hidePassword = true;
  bool isCheck = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Sign Up',
      color: kPrimaryColor,
      child: SafeArea(
        child: DodResponsive(
          mobile: Scaffold(
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 85,
                      width: 110,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('images/logo2.png'), fit: BoxFit.cover),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.createANewAccount,
                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        cursorColor: kNeutralColor,
                        textInputAction: TextInputAction.next,
                        decoration: kInputDecoration.copyWith(
                          labelText: AppLocalizations.of(context)!.name,
                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                          hintText: AppLocalizations.of(context)!.enterFullName,
                          hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                          focusColor: kNeutralColor,
                          border: const OutlineInputBorder(),
                        ),
                        controller: nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          List<String> result = [];

                          if (value!.trim().isEmpty) {
                            result.add(AppLocalizations.of(context)!.pleaseEnterName);
                          }

                          if (!isText(value)) {
                            result.add(AppLocalizations.of(context)!.specialCharacter);
                          }

                          return result.isNotEmpty ? result.join('\n') : null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: kNeutralColor,
                        textInputAction: TextInputAction.next,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Email',
                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                          hintText: AppLocalizations.of(context)!.enterEmail,
                          hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                          focusColor: kNeutralColor,
                          border: const OutlineInputBorder(),
                        ),
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          List<String> result = [];

                          if (value!.trim().isEmpty) {
                            result.add(AppLocalizations.of(context)!.pleaseEnterEmail);
                          }

                          if (!isValidEmail(value)) {
                            result.add(AppLocalizations.of(context)!.validEmail);
                          }

                          return result.isNotEmpty ? result.join('\n') : null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: kNeutralColor,
                        textInputAction: TextInputAction.next,
                        decoration: kInputDecoration.copyWith(
                          labelText: AppLocalizations.of(context)!.phone,
                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                          hintText: AppLocalizations.of(context)!.enterPhone,
                          hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                          focusColor: kNeutralColor,
                          border: const OutlineInputBorder(),
                        ),
                        controller: phoneController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          List<String> result = [];

                          if (value!.trim().isEmpty) {
                            result.add(AppLocalizations.of(context)!.pleaseEnterPhone);
                          }

                          if (!isPhone(value)) {
                            result.add(AppLocalizations.of(context)!.validPhone);
                          }

                          return result.isNotEmpty ? result.join('\n') : null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        cursorColor: kNeutralColor,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: hidePassword,
                        textInputAction: TextInputAction.done,
                        decoration: kInputDecoration.copyWith(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.password2,
                          labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                          hintText: AppLocalizations.of(context)!.enterPass,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          List<String> result = [];

                          if (value!.trim().isEmpty) {
                            result.add(AppLocalizations.of(context)!.pleaseEnterPassword);
                          } else {
                            // Password contains at least 8 characters
                            if (value.length < 8) {
                              result.add(AppLocalizations.of(context)!.atLeast);
                            }

                            // Password contains at least one uppercase letter
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              result.add(AppLocalizations.of(context)!.atOne);
                            }

                            // Password contains at least one lowercase letter
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              result.add(AppLocalizations.of(context)!.atLeastOne);
                            }

                            // Password contains at least one digit
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              result.add(AppLocalizations.of(context)!.leastDigit);
                            }

                            // Password contains at least one special character
                            if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                              result.add('${AppLocalizations.of(context)!.leastSpecialCharacter} [!@#\$%^&*(),.?":{}|<>]');
                            }

                            // No whitespaces
                            if (RegExp(r'\s').hasMatch(value)) {
                              result.add(AppLocalizations.of(context)!.passCannot);
                            }
                          }

                          return result.isNotEmpty ? result.join('\n') : null;
                        },
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            activeColor: kPrimaryColor,
                            visualDensity: const VisualDensity(horizontal: -4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            value: isCheck,
                            onChanged: (value) {
                              setState(() {
                                isCheck = !isCheck;
                              });
                            },
                          ),
                          RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.agree,
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.term,
                                  style: kTextStyle.copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      ButtonGlobalWithoutIcon(
                        buttontext: AppLocalizations.of(context)!.signUp,
                        buttonDecoration: kButtonDecoration.copyWith(
                          color: isCheck ? kPrimaryColor : kLightNeutralColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          isCheck ? onSignUp() : null;
                        },
                        buttonTextColor: kWhite,
                      ),
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
                              AppLocalizations.of(context)!.orSignInWith,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SocialIcon(
                              bgColor: kNeutralColor,
                              iconColor: kWhite,
                              icon: FontAwesomeIcons.facebookF,
                              borderColor: Colors.transparent,
                            ),
                            SizedBox(width: 15.0),
                            SocialIcon(
                              bgColor: kWhite,
                              iconColor: kNeutralColor,
                              icon: FontAwesomeIcons.google,
                              borderColor: kBorderColorTextField,
                            ),
                            // SocialIcon(
                            //   bgColor: kWhite,
                            //   iconColor: Color(0xFF76A9EA),
                            //   icon: FontAwesomeIcons.twitter,
                            //   borderColor: kBorderColorTextField,
                            // ),
                            // SocialIcon(
                            //   bgColor: kWhite,
                            //   iconColor: Color(0xFFFF554A),
                            //   icon: FontAwesomeIcons.instagram,
                            //   borderColor: kBorderColorTextField,
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            onLogin();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.alreadyHaveAccount,
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.logIn,
                                  style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
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
            ),
          ),
          desktop: Scaffold(
            backgroundColor: kWhite,
            body: Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 3,
                  child: Material(
                    elevation: 5.0,
                    child: Scaffold(
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
                                  image: DecorationImage(image: AssetImage('images/logo2.png'), fit: BoxFit.cover),
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.createANewAccount,
                                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  cursorColor: kNeutralColor,
                                  textInputAction: TextInputAction.next,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: AppLocalizations.of(context)!.name,
                                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                    hintText: AppLocalizations.of(context)!.enterFullName,
                                    hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                                    focusColor: kNeutralColor,
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: nameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    List<String> result = [];

                                    if (value!.trim().isEmpty) {
                                      result.add(AppLocalizations.of(context)!.pleaseEnterName);
                                    }

                                    if (!isText(value)) {
                                      result.add(AppLocalizations.of(context)!.specialCharacter);
                                    }

                                    return result.isNotEmpty ? result.join('\n') : null;
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: kNeutralColor,
                                  textInputAction: TextInputAction.next,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: 'Email',
                                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                    hintText: AppLocalizations.of(context)!.enterEmail,
                                    hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                    focusColor: kNeutralColor,
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: emailController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    List<String> result = [];

                                    if (value!.trim().isEmpty) {
                                      result.add(AppLocalizations.of(context)!.pleaseEnterEmail);
                                    }

                                    if (!isValidEmail(value)) {
                                      result.add(AppLocalizations.of(context)!.validEmail);
                                    }

                                    return result.isNotEmpty ? result.join('\n') : null;
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: kNeutralColor,
                                  textInputAction: TextInputAction.next,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: AppLocalizations.of(context)!.phone,
                                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                    hintText: AppLocalizations.of(context)!.enterPhone,
                                    hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                                    focusColor: kNeutralColor,
                                    border: const OutlineInputBorder(),
                                  ),
                                  controller: phoneController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    List<String> result = [];

                                    if (value!.trim().isEmpty) {
                                      result.add(AppLocalizations.of(context)!.pleaseEnterPhone);
                                    }

                                    if (!isPhone(value)) {
                                      result.add(AppLocalizations.of(context)!.validPhone);
                                    }

                                    return result.isNotEmpty ? result.join('\n') : null;
                                  },
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  cursorColor: kNeutralColor,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: hidePassword,
                                  textInputAction: TextInputAction.done,
                                  decoration: kInputDecoration.copyWith(
                                    border: const OutlineInputBorder(),
                                    labelText: AppLocalizations.of(context)!.password2,
                                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                    hintText: AppLocalizations.of(context)!.enterPass,
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
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    List<String> result = [];

                                    if (value!.trim().isEmpty) {
                                      result.add(AppLocalizations.of(context)!.enterPass);
                                    } else {
                                      // Password contains at least 8 characters
                                      if (value.length < 8) {
                                        result.add(AppLocalizations.of(context)!.atLeast);
                                      }

                                      // Password contains at least one uppercase letter
                                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                        result.add(AppLocalizations.of(context)!.atOne);
                                      }

                                      // Password contains at least one lowercase letter
                                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                                        result.add(AppLocalizations.of(context)!.atLeastOne);
                                      }

                                      // Password contains at least one digit
                                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                                        result.add(AppLocalizations.of(context)!.leastDigit);
                                      }

                                      // Password contains at least one special character
                                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                        result.add('${AppLocalizations.of(context)!.leastSpecialCharacter} [!@#\$%^&*(),.?":{}|<>]');
                                      }

                                      // No whitespaces
                                      if (RegExp(r'\s').hasMatch(value)) {
                                        result.add(AppLocalizations.of(context)!.passCannot);
                                      }
                                    }

                                    return result.isNotEmpty ? result.join('\n') : null;
                                  },
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      activeColor: kPrimaryColor,
                                      visualDensity: const VisualDensity(horizontal: -4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2.0),
                                      ),
                                      value: isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          isCheck = !isCheck;
                                        });
                                      },
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: AppLocalizations.of(context)!.agree,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(context)!.term,
                                            style: kTextStyle.copyWith(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                ButtonGlobalWithoutIcon(
                                  buttontext: AppLocalizations.of(context)!.signUp,
                                  buttonDecoration: kButtonDecoration.copyWith(
                                    color: isCheck ? kPrimaryColor : kLightNeutralColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () {
                                    isCheck ? onSignUp() : null;
                                  },
                                  buttonTextColor: kWhite,
                                ),
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
                                        AppLocalizations.of(context)!.orSignInWith,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SocialIcon(
                                        bgColor: kNeutralColor,
                                        iconColor: kWhite,
                                        icon: FontAwesomeIcons.facebookF,
                                        borderColor: Colors.transparent,
                                      ),
                                      SizedBox(width: 15.0),
                                      SocialIcon(
                                        bgColor: kWhite,
                                        iconColor: kNeutralColor,
                                        icon: FontAwesomeIcons.google,
                                        borderColor: kBorderColorTextField,
                                      ),
                                      // SocialIcon(
                                      //   bgColor: kWhite,
                                      //   iconColor: Color(0xFF76A9EA),
                                      //   icon: FontAwesomeIcons.twitter,
                                      //   borderColor: kBorderColorTextField,
                                      // ),
                                      // SocialIcon(
                                      //   bgColor: kWhite,
                                      //   iconColor: Color(0xFFFF554A),
                                      //   icon: FontAwesomeIcons.instagram,
                                      //   borderColor: kBorderColorTextField,
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      onLogin();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: AppLocalizations.of(context)!.alreadyHaveAccount,
                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(context)!.logIn,
                                            style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 4,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {
    context.goNamed(LoginRoute.name);
  }

  void onSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      ProgressDialogUtils.showProgress(context);

      if (PrefUtils().getToken() == '{}') {
        await FirebaseAuth.instance.signInAnonymously();

        // Save token
        var token = await FirebaseAuth.instance.currentUser!.getIdToken();
        await PrefUtils().setToken(token!);
      }

      var account = await AccountApi().gets(
        0,
        filter: 'email eq \'${emailController.text.trim()}\' or phone eq \'${phoneController.text}\'',
        count: 'true',
      );

      if (account.count != 0) {
        throw Exception;
      }

      await PrefUtils().setSignUpInfor({
        'Name': nameController.text.trim(),
        'Email': emailController.text.trim(),
        'Phone': phoneController.text,
        'Password': passwordController.text,
      });

      // Navigator
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      // ignore: use_build_context_synchronously
      context.goNamed(VerifyRoute.name);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.accountAlreadyExists);
    }
  }
}
