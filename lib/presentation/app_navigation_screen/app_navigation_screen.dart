import 'controller/app_navigation_controller.dart';import 'package:drawing_on_demand/core/app_export.dart';import 'package:flutter/material.dart';import 'package:drawing_on_demand/presentation/confirmation_dialog/confirmation_dialog.dart';import 'package:drawing_on_demand/presentation/confirmation_dialog/controller/confirmation_controller.dart';import 'package:drawing_on_demand/presentation/filter_bottomsheet/filter_bottomsheet.dart';import 'package:drawing_on_demand/presentation/filter_bottomsheet/controller/filter_controller.dart';import 'package:drawing_on_demand/presentation/apply_job_popup_dialog/apply_job_popup_dialog.dart';import 'package:drawing_on_demand/presentation/apply_job_popup_dialog/controller/apply_job_popup_controller.dart';import 'package:drawing_on_demand/presentation/logout_popup_dialog/logout_popup_dialog.dart';import 'package:drawing_on_demand/presentation/logout_popup_dialog/controller/logout_popup_controller.dart';class AppNavigationScreen extends GetWidget<AppNavigationController> {const AppNavigationScreen({Key? key}) : super(key: key);

@override Widget build(BuildContext context) { mediaQueryData = MediaQuery.of(context); return SafeArea(child: Scaffold(backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1), body: SizedBox(width: double.maxFinite, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_app_navigation".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20), child: Text("msg_check_your_app_s".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.blueGray40001, fontSize: getFontSize(16), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.black900))])), Expanded(child: SingleChildScrollView(child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [GestureDetector(onTap: () {onTapSplashScreen();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_splash_screen".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapOnboardingOne();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_onboarding_one".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapOnboardingTwo();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_onboarding_two".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapOnboardingThree();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_onboarding_three".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapSignUpCreateAcount();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_sign_up_create".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapSignUpCompleteAccount();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_sign_up_complete".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapJobType();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_job_type".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapSpeciallization();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_speciallization".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapConfirmation();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_confirmation".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapSelectaCountry();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_select_a_country2".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapLogin();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_login2".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapEnterOTP();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_enter_otp".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapHomeContainer();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_home_container".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapSearch();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_search2".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapFilter();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_filter".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapJobDetailsTabContainer();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_job_details_tab".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapMessageAction();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_message_action".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapChat();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_chat".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapApplyJob();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_apply_job".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapApplyJobPopup();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_apply_job_popup".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapNotificationsMyProposalsTabContainer();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_notifications".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapSettings();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_settings".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapLogoutpopup();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_logout_popup".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapPersonalInfo();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_personal_info".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapExperienceSetting();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_experience_setting".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapNewPosition();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_new_position".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapAddNewEducation();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("msg_add_new_education".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapPrivacy();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_privacy".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapLanguage();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_language".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))]))), GestureDetector(onTap: () {onTapNotifications();}, child: Container(decoration: AppDecoration.fillOnPrimaryContainer, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Align(alignment: Alignment.centerLeft, child: Padding(padding: getPadding(left: 20, top: 10, right: 20, bottom: 10), child: Text("lbl_notifications".tr, textAlign: TextAlign.center, style: TextStyle(color: appTheme.black900, fontSize: getFontSize(20), fontFamily: 'Roboto', fontWeight: FontWeight.w400)))), Padding(padding: getPadding(top: 5), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.blueGray40001))])))]))))])))); } 
/// Navigates to the splashScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the splashScreen.
onTapSplashScreen() { Get.toNamed(AppRoutes.splashScreen, ); } 
/// Navigates to the onboardingOneScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the onboardingOneScreen.
onTapOnboardingOne() { Get.toNamed(AppRoutes.onboardingOneScreen, ); } 
/// Navigates to the onboardingTwoScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the onboardingTwoScreen.
onTapOnboardingTwo() { Get.toNamed(AppRoutes.onboardingTwoScreen, ); } 
/// Navigates to the onboardingThreeScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the onboardingThreeScreen.
onTapOnboardingThree() { Get.toNamed(AppRoutes.onboardingThreeScreen, ); } 
/// Navigates to the signUpCreateAcountScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the signUpCreateAcountScreen.
onTapSignUpCreateAcount() { Get.toNamed(AppRoutes.signUpCreateAcountScreen, ); } 
/// Navigates to the signUpCompleteAccountScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the signUpCompleteAccountScreen.
onTapSignUpCompleteAccount() { Get.toNamed(AppRoutes.signUpCompleteAccountScreen, ); } 
/// Navigates to the jobTypeScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the jobTypeScreen.
onTapJobType() { Get.toNamed(AppRoutes.jobTypeScreen, ); } 
/// Navigates to the speciallizationScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the speciallizationScreen.
onTapSpeciallization() { Get.toNamed(AppRoutes.speciallizationScreen, ); } 


/// Displays a dialog with the [ConfirmationDialog] content.
///
/// The [ConfirmationDialog] widget is created with a new 
/// instance of the [ConfirmationController],
/// which is obtained using the Get.put() method.
onTapConfirmation() { Get.dialog(AlertDialog(backgroundColor: Colors.transparent, contentPadding: EdgeInsets.zero, insetPadding: const EdgeInsets.only(left: 0), content:ConfirmationDialog(Get.put(ConfirmationController(),),),)); } 
/// Navigates to the selectACountryScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the selectACountryScreen.
onTapSelectaCountry() { Get.toNamed(AppRoutes.selectACountryScreen, ); } 
/// Navigates to the loginScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the loginScreen.
onTapLogin() { Get.toNamed(AppRoutes.loginScreen, ); } 
/// Navigates to the enterOtpScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the enterOtpScreen.
onTapEnterOTP() { Get.toNamed(AppRoutes.enterOtpScreen, ); } 
/// Navigates to the homeContainerScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the homeContainerScreen.
onTapHomeContainer() { Get.toNamed(AppRoutes.homeContainerScreen, ); } 
/// Navigates to the searchScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the searchScreen.
onTapSearch() { Get.toNamed(AppRoutes.searchScreen, ); } 


/// Displays a scrollable bottom sheet widget using the [Get] package 
/// and the [FilterBottomsheet] widget.
///
/// The bottom sheet is controlled by the [FilterController]
/// and is displayed using the [Get.bottomSheet] method with
/// [isScrollControlled] set to true.

onTapFilter() { Get.bottomSheet(FilterBottomsheet(Get.put(FilterController(),),),isScrollControlled: true,); } 
/// Navigates to the jobDetailsTabContainerScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the jobDetailsTabContainerScreen.
onTapJobDetailsTabContainer() { Get.toNamed(AppRoutes.jobDetailsTabContainerScreen, ); } 
/// Navigates to the messageActionScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the messageActionScreen.
onTapMessageAction() { Get.toNamed(AppRoutes.messageActionScreen, ); } 
/// Navigates to the chatScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the chatScreen.
onTapChat() { Get.toNamed(AppRoutes.chatScreen, ); } 
/// Navigates to the applyJobScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the applyJobScreen.
onTapApplyJob() { Get.toNamed(AppRoutes.applyJobScreen, ); } 


/// Displays a dialog with the [ApplyJobPopupDialog] content.
///
/// The [ApplyJobPopupDialog] widget is created with a new 
/// instance of the [ApplyJobPopupController],
/// which is obtained using the Get.put() method.
onTapApplyJobPopup() { Get.dialog(AlertDialog(backgroundColor: Colors.transparent, contentPadding: EdgeInsets.zero, insetPadding: const EdgeInsets.only(left: 0), content:ApplyJobPopupDialog(Get.put(ApplyJobPopupController(),),),)); } 
/// Navigates to the notificationsMyProposalsTabContainerScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the notificationsMyProposalsTabContainerScreen.
onTapNotificationsMyProposalsTabContainer() { Get.toNamed(AppRoutes.notificationsMyProposalsTabContainerScreen, ); } 
/// Navigates to the settingsScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the settingsScreen.
onTapSettings() { Get.toNamed(AppRoutes.settingsScreen, ); } 


/// Displays a dialog with the [LogoutPopupDialog] content.
///
/// The [LogoutPopupDialog] widget is created with a new 
/// instance of the [LogoutPopupController],
/// which is obtained using the Get.put() method.
onTapLogoutpopup() { Get.dialog(AlertDialog(backgroundColor: Colors.transparent, contentPadding: EdgeInsets.zero, insetPadding: const EdgeInsets.only(left: 0), content:LogoutPopupDialog(Get.put(LogoutPopupController(),),),)); } 
/// Navigates to the personalInfoScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the personalInfoScreen.
onTapPersonalInfo() { Get.toNamed(AppRoutes.personalInfoScreen, ); } 
/// Navigates to the experienceSettingScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the experienceSettingScreen.
onTapExperienceSetting() { Get.toNamed(AppRoutes.experienceSettingScreen, ); } 
/// Navigates to the newPositionScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the newPositionScreen.
onTapNewPosition() { Get.toNamed(AppRoutes.newPositionScreen, ); } 
/// Navigates to the addNewEducationScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the addNewEducationScreen.
onTapAddNewEducation() { Get.toNamed(AppRoutes.addNewEducationScreen, ); } 
/// Navigates to the privacyScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the privacyScreen.
onTapPrivacy() { Get.toNamed(AppRoutes.privacyScreen, ); } 
/// Navigates to the languageScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the languageScreen.
onTapLanguage() { Get.toNamed(AppRoutes.languageScreen, ); } 
/// Navigates to the notificationsScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the notificationsScreen.
onTapNotifications() { Get.toNamed(AppRoutes.notificationsScreen, ); } 
 }
