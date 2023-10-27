import 'controller/speciallization_controller.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_checkbox_button.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:drawing_on_demand/presentation/confirmation_dialog/confirmation_dialog.dart';
import 'package:drawing_on_demand/presentation/confirmation_dialog/controller/confirmation_controller.dart';

class SpeciallizationScreen extends GetWidget<SpeciallizationController> {
  const SpeciallizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA70001,
        body: Container(
          width: double.maxFinite,
          padding: getPadding(left: 23, top: 13, right: 23, bottom: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomImageView(
                  svgPath: ImageConstant.imgGroup162799,
                  height: getSize(24),
                  width: getSize(24),
                  alignment: Alignment.centerLeft,
                  margin: getMargin(left: 1),
                  onTap: () {
                    onTapImgImage();
                  }),
              Container(
                  width: getHorizontalSize(177),
                  margin: getMargin(top: 44),
                  child: Text("msg_what_is_your_specialization".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall!
                          .copyWith(height: 1.33))),
              Padding(
                  padding: getPadding(top: 7),
                  child: Text("msg_lorem_ipsum_dolor2".tr,
                      style: CustomTextStyles.titleSmallBluegray400_1)),
              Container(
                width: getHorizontalSize(327),
                margin: getMargin(left: 1, top: 31),
                padding: getPadding(left: 16, top: 10, right: 16, bottom: 10),
                decoration: AppDecoration.outlineIndigo
                    .copyWith(borderRadius: BorderRadiusStyle.roundedBorder24),
                child: Obx(
                  () => CustomCheckboxButton(
                    text: "msg_design_creative".tr,
                    value: controller.designcreative.value,
                    onChange: (value) {
                      controller.designcreative.value = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomElevatedButton(
          text: "lbl_continue".tr,
          margin: getMargin(left: 24, right: 24, bottom: 39),
          buttonStyle: CustomButtonStyles.fillPrimary,
          onTap: () {
            onTapContinue();
          },
        ),
      ),
    );
  }

  /// Displays a dialog with the [ConfirmationDialog] content.
  ///
  /// The [ConfirmationDialog] widget is created with a new
  /// instance of the [ConfirmationController],
  /// which is obtained using the Get.put() method.
  onTapContinue() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.only(left: 0),
      content: ConfirmationDialog(
        Get.put(
          ConfirmationController(),
        ),
      ),
    ));
  }

  /// Navigates to the previous screen.
  ///
  /// When the action is triggered, this function uses the [Get] package to
  /// navigate to the previous screen in the navigation stack.
  onTapImgImage() {
    Get.back();
  }
}
