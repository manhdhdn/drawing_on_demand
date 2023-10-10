import '../controller/onboarding_three_controller.dart';
import '../models/sliderapplicati_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SliderapplicatiItemWidget extends StatelessWidget {
  SliderapplicatiItemWidget(
    this.sliderapplicatiItemModelObj, {
    Key? key,
    this.onTapLabel,
  }) : super(
          key: key,
        );

  SliderapplicatiItemModel sliderapplicatiItemModelObj;

  var controller = Get.find<OnboardingThreeController>();

  VoidCallback? onTapLabel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: getPadding(
          left: 41,
          top: 32,
          right: 41,
          bottom: 32,
        ),
        decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: getHorizontalSize(214),
              margin: getMargin(
                left: 14,
                right: 14,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "msg_application_surely2".tr,
                      style: theme.textTheme.headlineSmall,
                    ),
                    TextSpan(
                      text: "lbl_each_company".tr,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: getPadding(
                top: 14,
              ),
              child: Text(
                "msg_semper_in_cursus".tr,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleSmallBluegray300.copyWith(
                  height: 1.57,
                ),
              ),
            ),
            CustomElevatedButton(
              width: getHorizontalSize(156),
              text: "lbl_get_started".tr,
              margin: getMargin(
                top: 69,
              ),
              buttonStyle: CustomButtonStyles.fillPrimary,
              onTap: () {
                onTapLabel?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
