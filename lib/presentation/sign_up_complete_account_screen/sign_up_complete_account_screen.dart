import 'package:drawing_on_demand/data/models/account.dart';
import 'package:flutter_guid/flutter_guid.dart';

import 'controller/sign_up_complete_account_controller.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/validation_functions.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:drawing_on_demand/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:drawing_on_demand/data/models/registerDeviceAuth/post_register_device_auth_req.dart';

// ignore_for_file: must_be_immutable
class SignUpCompleteAccountScreen
    extends GetWidget<SignUpCompleteAccountController> {
  SignUpCompleteAccountScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.whiteA70001,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: double.maxFinite,
              padding: getPadding(left: 24, top: 13, right: 24, bottom: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomImageView(
                      svgPath: ImageConstant.imgGroup162799,
                      height: getSize(24),
                      width: getSize(24),
                      onTap: () {
                        onTapImgImage();
                      }),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(top: 47),
                          child: Text("msg_complete_your_account".tr,
                              style: theme.textTheme.headlineSmall))),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(top: 9),
                          child: Text("msg_lorem_ipsum_dolor".tr,
                              style:
                                  CustomTextStyles.titleSmallBluegray400_1))),
                  Padding(
                      padding: getPadding(top: 33),
                      child: Text("lbl_name".tr,
                          style: theme.textTheme.titleSmall)),
                  CustomTextFormField(
                    controller: controller.nameController,
                    margin: getMargin(top: 9),
                    hintText: "msg_enter_your_name".tr,
                    hintStyle: CustomTextStyles.titleMediumBluegray400,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (!isText(value, isRequired: true)) {
                        return "Please enter your valid name";
                      }
                      return null;
                    },
                    contentPadding:
                        getPadding(left: 12, top: 15, right: 12, bottom: 15),
                  ),
                  Padding(
                      padding: getPadding(top: 18),
                      child: Text("lbl_phone".tr,
                          style: theme.textTheme.titleSmall)),
                  CustomTextFormField(
                      controller: controller.phoneController,
                      margin: getMargin(top: 9),
                      hintText: "msg_enter_your_phone".tr,
                      hintStyle: CustomTextStyles.titleMediumBluegray400,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.phone,
                      validator: (value) {
                        if (!isPhone(value, isRequired: true)) {
                          return "Please enter valid phone number";
                        }
                        return null;
                      },
                      contentPadding:
                          getPadding(left: 12, top: 15, right: 12, bottom: 15)),
                  Padding(
                    padding: getPadding(top: 18),
                    child: Text("lbl_password".tr,
                        style: theme.textTheme.titleSmall),
                  ),
                  Obx(
                    () => CustomTextFormField(
                      controller: controller.passwordController,
                      margin: getMargin(top: 9),
                      hintText: "msg_create_a_password".tr,
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
                                      : ImageConstant.imgCheckmarkPrimary))),
                      suffixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(52)),
                      validator: (value) {
                        if (value == null ||
                            (!isValidPassword(value, isRequired: true))) {
                          return "Please enter valid password";
                        }
                        return null;
                      },
                      obscureText: controller.isShowPassword.value,
                      contentPadding: getPadding(left: 16, top: 15, bottom: 15),
                    ),
                  ),

                  /// Gender
                  Padding(
                    padding: getPadding(top: 18),
                    child: Text("lbl_gender".tr,
                        style: theme.textTheme.titleSmall),
                  ),

                  /// Choose Gender with Radio Button
                  Obx(
                    () => Padding(
                      padding: getPadding(top: 9),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text("txt_male".tr,
                                style: theme.textTheme.titleSmall),
                            value: "Male",
                            groupValue: controller.gender.value,
                            onChanged: (value) =>
                                controller.gender.value = value!,
                          ),
                          RadioListTile<String>(
                            title: Text("txt_female".tr,
                                style: theme.textTheme.titleSmall),
                            value: "Female",
                            groupValue: controller.gender.value,
                            onChanged: (value) =>
                                controller.gender.value = value!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                      text: "msg_continue_with_email".tr,
                      margin: getMargin(top: 27),
                      buttonStyle: CustomButtonStyles.fillPrimary,
                      onTap: () {
                        onTapContinuewith();
                      }),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: getPadding(left: 40, top: 28, right: 40),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("msg_already_have_an".tr,
                                    style: CustomTextStyles
                                        .titleMediumBluegray300),
                                GestureDetector(
                                    onTap: () {
                                      onTapTxtLargelabelmediu();
                                    },
                                    child: Padding(
                                        padding: getPadding(left: 3),
                                        child: Text("lbl_login".tr,
                                            style:
                                                theme.textTheme.titleMedium)))
                              ]))),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: getHorizontalSize(245),
                      margin:
                          getMargin(left: 40, top: 19, right: 40, bottom: 5),
                      child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "msg_by_signing_up_you2".tr,
                                  style: CustomTextStyles
                                      .titleSmallBluegray400SemiBold),
                              TextSpan(
                                  text: "lbl_terms".tr,
                                  style: CustomTextStyles
                                      .titleSmallErrorContainer),
                              TextSpan(
                                  text: "lbl_and".tr,
                                  style: CustomTextStyles
                                      .titleSmallBluegray400SemiBold),
                              TextSpan(
                                  text: "msg_conditions_of_use".tr,
                                  style:
                                      CustomTextStyles.titleSmallErrorContainer)
                            ],
                          ),
                          textAlign: TextAlign.center),
                    ),
                  ),
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

  /// calls the [https://nodedemo.dhiwise.co/device/auth/register] API
  ///
  /// validates the form input fields and executes the API if all the fields are valid
  /// It has [PostRegisterDeviceAuthReq] as a parameter which will be passed as a API request body
  /// If the call is successful, the function calls the `_onOnTapSignUpSuccess()` function.
  /// If the call fails, the function calls the `_onOnTapSignUpError()` function.
  ///
  /// Throws a `NoInternetException` if there is no internet connection.
  Future<void> onTapContinuewith() async {
    if (_formKey.currentState!.validate()) {
      Account account = Account(
        id: Guid.generate(),
        email: Get.arguments,
        phone: controller.phoneController.text.trim(),
        name: controller.nameController.text.trim(),
        gender: controller.gender.value,
        createdDate: DateTime.now(),
        status: "Active",
        rankId: Guid("7681ee23-7b59-4962-a7d1-d72d9118ad31"),
      );

      await controller.callRegisterDeviceAuth(account);
    }
  }

  /// Navigates to the loginScreen when the action is triggered.

  /// When the action is triggered, this function uses the [Get] package to
  /// push the named route for the loginScreen.
  onTapTxtLargelabelmediu() {
    Get.toNamed(
      AppRoutes.loginScreen,
    );
  }
}
