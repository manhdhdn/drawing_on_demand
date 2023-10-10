import '../controller/experience_setting_controller.dart';
import '../models/experience_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExperienceItemWidget extends StatelessWidget {
  ExperienceItemWidget(
    this.experienceItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  ExperienceItemModel experienceItemModelObj;

  var controller = Get.find<ExperienceSettingController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIconButton(
          height: getSize(48),
          width: getSize(48),
          padding: getPadding(
            all: 8,
          ),
          child: CustomImageView(
            svgPath: ImageConstant.imgUser,
          ),
        ),
        Expanded(
          child: Padding(
            padding: getPadding(
              left: 12,
              top: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    experienceItemModelObj.internshipuiuxTxt.value,
                    style: CustomTextStyles.titleSmallPrimarySemiBold,
                  ),
                ),
                Padding(
                  padding: getPadding(
                    top: 6,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: getPadding(
                          top: 1,
                        ),
                        child: Text(
                          "lbl_shopee_sg".tr,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 3,
                          top: 1,
                        ),
                        child: Text(
                          "lbl".tr,
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 4,
                        ),
                        child: Obx(
                          () => Text(
                            experienceItemModelObj.zipcodeTxt.value,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
