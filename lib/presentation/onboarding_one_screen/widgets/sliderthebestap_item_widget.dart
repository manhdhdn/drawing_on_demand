import '../controller/onboarding_one_controller.dart';
import '../models/sliderthebestap_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SliderthebestapItemWidget extends StatelessWidget {
  SliderthebestapItemWidget(
    this.sliderthebestapItemModelObj, {
    Key? key,
    this.onTapLabel,
  }) : super(
          key: key,
        );

  SliderthebestapItemModel sliderthebestapItemModelObj;

  var controller = Get.find<OnboardingOneController>();

  VoidCallback? onTapLabel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: getPadding(
          left: 39,
          top: 32,
          right: 39,
          bottom: 32,
        ),
        decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: getHorizontalSize(246),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "msg_the_best_app_for2".tr,
                      style: theme.textTheme.headlineSmall,
                    ),
                    TextSpan(
                      text: "msg_find_your_dream".tr,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: getPadding(
                top: 19,
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
              width: getHorizontalSize(101),
              text: "lbl_next".tr,
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
