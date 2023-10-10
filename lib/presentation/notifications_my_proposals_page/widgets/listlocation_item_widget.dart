import '../controller/notifications_my_proposals_controller.dart';
import '../models/listlocation_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_elevated_button.dart';
import 'package:drawing_on_demand/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListlocationItemWidget extends StatelessWidget {
  ListlocationItemWidget(
    this.listlocationItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  ListlocationItemModel listlocationItemModelObj;

  var controller = Get.find<NotificationsMyProposalsController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconButton(
          height: getSize(48),
          width: getSize(48),
          margin: getMargin(
            bottom: 42,
          ),
          padding: getPadding(
            all: 7,
          ),
          child: CustomImageView(
            svgPath: ImageConstant.imgLocation,
          ),
        ),
        Expanded(
          child: Padding(
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
                  style: CustomTextStyles.titleSmallPrimaryBold,
                ),
                Padding(
                  padding: getPadding(
                    top: 6,
                  ),
                  child: Obx(
                    () => Text(
                      listlocationItemModelObj.smalllabelregulTxt.value,
                      style: CustomTextStyles.labelLargeBluegray300SemiBold,
                    ),
                  ),
                ),
                CustomElevatedButton(
                  height: getVerticalSize(28),
                  width: getHorizontalSize(78),
                  text: "lbl_opened".tr,
                  margin: getMargin(
                    top: 17,
                  ),
                  buttonStyle: CustomButtonStyles.fillGreen,
                  buttonTextStyle: CustomTextStyles.bodySmallGreenA700,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
