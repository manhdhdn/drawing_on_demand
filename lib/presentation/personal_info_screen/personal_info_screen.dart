import 'controller/personal_info_controller.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/core/utils/validation_functions.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_image.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_image_1.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_title.dart';
import 'package:drawing_on_demand/widgets/app_bar/custom_app_bar.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:drawing_on_demand/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class PersonalInfoScreen extends GetWidget<PersonalInfoController> {
  PersonalInfoScreen({Key? key}) : super(key: key);

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: appTheme.whiteA70001,
            appBar: CustomAppBar(
                leadingWidth: getHorizontalSize(48),
                leading: AppbarImage(
                    svgPath: ImageConstant.imgGroup162799,
                    margin: getMargin(left: 24, top: 13, bottom: 13),
                    onTap: () {
                      onTapArrowbackone();
                    }),
                centerTitle: true,
                title: AppbarTitle(text: "lbl_personal_info".tr),
                actions: [
                  AppbarImage1(
                      svgPath: ImageConstant.imgEditsquare,
                      margin:
                          getMargin(left: 24, top: 13, right: 24, bottom: 13))
                ]),
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    padding: getPadding(top: 32),
                    child: Padding(
                        padding: getPadding(left: 24, right: 24, bottom: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("lbl_first_name".tr,
                                  style: CustomTextStyles.titleSmallPrimary),
                              CustomTextFormField(
                                  controller: controller.firstNameController,
                                  margin: getMargin(top: 9),
                                  hintText: "lbl_gustavo".tr,
                                  hintStyle:
                                      CustomTextStyles.titleMediumBluegray400),
                              Padding(
                                  padding: getPadding(top: 18),
                                  child: Text("lbl_last_name".tr,
                                      style:
                                          CustomTextStyles.titleSmallPrimary)),
                              CustomTextFormField(
                                  controller: controller.lastNameController,
                                  margin: getMargin(top: 9),
                                  hintText: "lbl_lipshutz".tr,
                                  hintStyle:
                                      CustomTextStyles.titleMediumBluegray400),
                              Padding(
                                  padding: getPadding(top: 18),
                                  child: Text("lbl_email".tr,
                                      style:
                                          CustomTextStyles.titleSmallPrimary)),
                              CustomTextFormField(
                                  controller: controller.emailController,
                                  margin: getMargin(top: 9),
                                  hintText: "lbl_xyz_gmail_com".tr,
                                  hintStyle:
                                      CustomTextStyles.titleMediumBluegray400,
                                  textInputType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null ||
                                        (!isValidEmail(value,
                                            isRequired: true))) {
                                      return "Please enter valid email";
                                    }
                                    return null;
                                  }),
                              Padding(
                                  padding: getPadding(top: 18),
                                  child: Text("lbl_phone".tr,
                                      style:
                                          CustomTextStyles.titleSmallPrimary)),
                              CustomTextFormField(
                                  controller: controller.phoneController,
                                  margin: getMargin(top: 9),
                                  hintText: "lbl_1_1234567890".tr,
                                  hintStyle:
                                      CustomTextStyles.titleMediumBluegray400),
                              Padding(
                                  padding: getPadding(top: 18),
                                  child: Text("lbl_location".tr,
                                      style:
                                          CustomTextStyles.titleSmallPrimary)),
                              CustomTextFormField(
                                  controller: controller.locationController,
                                  margin: getMargin(top: 9),
                                  hintText: "lbl_lorem_ipsun".tr,
                                  hintStyle:
                                      CustomTextStyles.titleMediumBluegray400,
                                  textInputAction: TextInputAction.done,
                                  maxLines: 6,
                                  contentPadding: getPadding(
                                      left: 16, top: 20, right: 16, bottom: 20))
                            ])))),
            bottomNavigationBar: CustomElevatedButton(
                text: "lbl_save_changes".tr,
                margin: getMargin(left: 24, right: 24, bottom: 44),
                buttonStyle: CustomButtonStyles.fillBlueGray,
                buttonTextStyle: CustomTextStyles.titleMediumBluegray300,
                onTap: () {
                  onTapSavechanges();
                })));
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapArrowbackone() {
    Get.back();
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapSavechanges() {
    Get.back();
  }
}
