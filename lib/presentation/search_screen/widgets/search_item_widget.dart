import '../controller/search_controller.dart';
import '../models/search_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:drawing_on_demand/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart' hide SearchController;

// ignore: must_be_immutable
class SearchItemWidget extends StatelessWidget {
  SearchItemWidget(
    this.searchItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  SearchItemModel searchItemModelObj;

  var controller = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        all: 16,
      ),
      decoration: AppDecoration.outlineIndigo.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconButton(
            height: getSize(48),
            width: getSize(48),
            margin: getMargin(
              bottom: 68,
            ),
            padding: getPadding(
              all: 7,
            ),
            child: CustomImageView(
              svgPath: ImageConstant.imgLightbulb,
            ),
          ),
          Padding(
            padding: getPadding(
              left: 12,
              top: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "msg_senior_ui_ux_designer".tr,
                  style: CustomTextStyles.titleMediumBold_1,
                ),
                Padding(
                  padding: getPadding(
                    top: 5,
                  ),
                  child: Obx(
                    () => Text(
                      searchItemModelObj.shellTxt.value,
                      style: CustomTextStyles.labelLargeBluegray300SemiBold,
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 12,
                  ),
                  child: Text(
                    "msg_560_12_000_month".tr,
                    style: CustomTextStyles.labelLargeGray600_1,
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 13,
                  ),
                  child: Row(
                    children: [
                      CustomElevatedButton(
                        height: getVerticalSize(28),
                        width: getHorizontalSize(70),
                        text: "lbl_fulltime".tr,
                        buttonTextStyle: theme.textTheme.labelLarge!,
                      ),
                      CustomElevatedButton(
                        height: getVerticalSize(28),
                        width: getHorizontalSize(103),
                        text: "lbl_two_days_ago".tr,
                        margin: getMargin(
                          left: 8,
                        ),
                        buttonTextStyle: theme.textTheme.labelLarge!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            svgPath: ImageConstant.imgBookmark,
            height: getSize(24),
            width: getSize(24),
            margin: getMargin(
              left: 30,
              bottom: 92,
            ),
          ),
        ],
      ),
    );
  }
}
