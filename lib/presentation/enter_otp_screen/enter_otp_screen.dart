import 'controller/enter_otp_controller.dart';import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';import 'package:drawing_on_demand/widgets/custom_pin_code_text_field.dart';import 'package:flutter/material.dart';class EnterOtpScreen extends GetWidget<EnterOtpController> {const EnterOtpScreen({Key? key}) : super(key: key);

@override Widget build(BuildContext context) { mediaQueryData = MediaQuery.of(context); return SafeArea(child: Scaffold(resizeToAvoidBottomInset: false, backgroundColor: appTheme.whiteA70001, body: Container(width: double.maxFinite, padding: getPadding(left: 24, top: 13, right: 24, bottom: 13), child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [CustomImageView(svgPath: ImageConstant.imgGroup162799, height: getSize(24), width: getSize(24), alignment: Alignment.centerLeft, onTap: () {onTapImgImage();}), Padding(padding: getPadding(top: 44), child: Text("lbl_enter_otp".tr, style: theme.textTheme.headlineSmall)), Container(width: getHorizontalSize(282), margin: getMargin(left: 22, top: 10, right: 22), child: RichText(text: TextSpan(children: [TextSpan(text: "msg_we_have_just_sent2".tr, style: CustomTextStyles.titleSmallBluegray400_3), TextSpan(text: "msg_example_gmail_com".tr, style: CustomTextStyles.titleSmallPrimary_1)]), textAlign: TextAlign.center)), Obx(() => CustomPinCodeTextField(context: context, margin: getMargin(left: 16, top: 38, right: 15), controller: controller.otpController.value, onChanged: (value) {})), CustomElevatedButton(text: "lbl_continue".tr, margin: getMargin(top: 40), buttonStyle: CustomButtonStyles.fillPrimary, onTap: () {onTapContinue();}), Padding(padding: getPadding(left: 30, top: 26, right: 30, bottom: 5), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("msg_didn_t_receive_code".tr, style: CustomTextStyles.titleMediumBluegray300), Text("lbl_resend_code".tr, style: theme.textTheme.titleMedium)]))])))); } 


/// Navigates to the previous screen.
///
/// When the action is triggered, this function uses the [Get] package to 
/// navigate to the previous screen in the navigation stack.
onTapImgImage() { Get.back(); } 
/// Navigates to the jobTypeScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the jobTypeScreen.
onTapContinue() { Get.toNamed(AppRoutes.jobTypeScreen, ); } 
 }
