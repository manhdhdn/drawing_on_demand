import 'controller/login_controller.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/validation_functions.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:drawing_on_demand/widgets/custom_outlined_button.dart';
import 'package:drawing_on_demand/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends GetWidget<LoginController> {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: appTheme.whiteA70001,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: getPadding(left: 24, top: 13, right: 24, bottom: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomImageView(
                      svgPath: ImageConstant.imgGroup162799,
                      height: getSize(24),
                      width: getSize(24),
                      alignment: Alignment.centerLeft,
                      onTap: () {
                        onTapImgImage();
                      }),
                  Padding(
                      padding: getPadding(top: 44),
                      child: Text("msg_hi_welcome_back".tr,
                          style: theme.textTheme.headlineSmall)),
                  Padding(
                      padding: getPadding(top: 11),
                      child: Text("msg_lorem_ipsum_dolor".tr,
                          style: CustomTextStyles.titleSmallBluegray400_1)),
                  CustomOutlinedButton(
                      height: getVerticalSize(56),
                      text: "msg_continue_with_google".tr,
                      margin: getMargin(top: 31),
                      leftIcon: Container(
                          margin: getMargin(right: 12),
                          child: CustomImageView(
                              svgPath: ImageConstant.imgGooglesymbol1)),
                      buttonStyle: CustomButtonStyles.outlinePrimary,
                      buttonTextStyle: theme.textTheme.titleMedium!,
                      onTap: () {
                        onTapContinuewith();
                      }),
                  CustomOutlinedButton(
                      height: getVerticalSize(56),
                      text: "msg_continue_with_apple".tr,
                      margin: getMargin(top: 16),
                      leftIcon: Container(
                          margin: getMargin(right: 12),
                          child: CustomImageView(
                              svgPath: ImageConstant.imgIconApple)),
                      buttonStyle: CustomButtonStyles.outlinePrimary,
                      buttonTextStyle: theme.textTheme.titleMedium!),
                  Padding(
                      padding: getPadding(left: 33, top: 26, right: 33),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: getPadding(top: 8, bottom: 8),
                                child: SizedBox(
                                    width: getHorizontalSize(62),
                                    child: const Divider())),
                            Padding(
                                padding: getPadding(left: 12),
                                child: Text("msg_or_continue_with".tr,
                                    style: CustomTextStyles
                                        .titleSmallBluegray300)),
                            Padding(
                                padding: getPadding(top: 8, bottom: 8),
                                child: SizedBox(
                                    width: getHorizontalSize(74),
                                    child:
                                        Divider(indent: getHorizontalSize(12))))
                          ])),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(top: 28),
                      child: Text("lbl_email".tr,
                          style: theme.textTheme.titleSmall),
                    ),
                  ),
                  CustomTextFormField(
                    controller: controller.emailController,
                    margin: getMargin(top: 9),
                    hintText: "msg_enter_your_email".tr,
                    hintStyle: CustomTextStyles.titleMediumBluegray400,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          (!isValidEmail(value, isRequired: true))) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    contentPadding:
                        getPadding(left: 12, top: 15, right: 12, bottom: 15),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding(top: 28),
                      child: Text("lbl_password".tr,
                          style: theme.textTheme.titleSmall),
                    ),
                  ),
                  Obx(
                    () => CustomTextFormField(
                      controller: controller.passwordController,
                      margin: getMargin(top: 9),
                      hintText: "msg_enter_your_password".tr,
                      hintStyle: CustomTextStyles.titleMediumBluegray400,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      suffix: InkWell(
                        onTap: () {
                          controller.isShowPassword.value =
                              !controller.isShowPassword.value;
                        },
                        child: Container(
                          margin: getMargin(
                              left: 30, top: 14, right: 16, bottom: 14),
                          child: CustomImageView(
                              svgPath: controller.isShowPassword.value
                                  ? ImageConstant.imgCheckmark
                                  : ImageConstant.imgCheckmarkPrimary),
                        ),
                      ),
                      suffixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(52)),
                      obscureText: controller.isShowPassword.value,
                      contentPadding:
                          getPadding(left: 12, top: 15, right: 12, bottom: 15),
                    ),
                  ),
                  CustomElevatedButton(
                      text: "msg_continue".tr,
                      margin: getMargin(top: 40),
                      buttonStyle: CustomButtonStyles.fillPrimary,
                      onTap: () {
                        onTapContinuewith1();
                      }),
                  Padding(
                      padding: getPadding(left: 41, top: 26, right: 41),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: getPadding(bottom: 1),
                                child: Text("msg_don_t_have_an_account".tr,
                                    style: CustomTextStyles
                                        .titleMediumBluegray300)),
                            GestureDetector(
                                onTap: () {
                                  onTapTxtLargelabelmediu();
                                },
                                child: Padding(
                                    padding: getPadding(left: 2),
                                    child: Text("lbl_sign_up".tr,
                                        style: theme.textTheme.titleMedium)))
                          ])),
                  Container(
                    width: getHorizontalSize(245),
                    margin: getMargin(left: 40, top: 60, right: 40),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "msg_by_signing_up_you2".tr,
                              style: CustomTextStyles
                                  .titleSmallBluegray400SemiBold),
                          TextSpan(
                              text: "lbl_terms".tr,
                              style: CustomTextStyles.titleSmallErrorContainer),
                          TextSpan(
                              text: "lbl_and".tr,
                              style: CustomTextStyles
                                  .titleSmallBluegray400SemiBold),
                          TextSpan(
                              text: "msg_conditions_of_use".tr,
                              style: CustomTextStyles.titleSmallErrorContainer)
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapImgImage() {
    Get.back();
  }

  /// Performs a Google sign-in and returns a [GoogleUser] object.
  ///
  /// If the sign-in is successful, the [onSuccess] callback will be called with
  /// a TODO comment needed to be modified by you.
  /// If the sign-in fails, the [onError] callback will be called with the error message.
  ///
  /// Throws an exception if the Google sign-in process fails.
  onTapContinuewith() {
    controller.loginWithGoogle();
  }

  /// Navigates to the enterOtpScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the enterOtpScreen.
  onTapContinuewith1() {
    if (_formKey.currentState!.validate()) {
      controller.login(controller.emailController.text.trim(),
          controller.passwordController.text.trim());
    }
  }

  /// Navigates to the signUpCreateAcountScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the signUpCreateAcountScreen.
  onTapTxtLargelabelmediu() {
    Get.toNamed(
      AppRoutes.signUpCreateAcountScreen,
    );
  }
}
