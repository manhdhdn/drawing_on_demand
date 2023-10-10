import '../controller/message_controller.dart';
import '../models/message_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageItemWidget extends StatelessWidget {
  MessageItemWidget(
    this.messageItemModelObj, {
    Key? key,
    this.onTapRowesther,
  }) : super(
          key: key,
        );

  MessageItemModel messageItemModelObj;

  var controller = Get.find<MessageController>();

  VoidCallback? onTapRowesther;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getVerticalSize(73),
      width: getHorizontalSize(327),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: getSize(56),
              width: getSize(56),
              decoration: BoxDecoration(
                color: appTheme.gray100,
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(28),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () {
                onTapRowesther?.call();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: getSize(56),
                    width: getSize(56),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage56x56,
                          height: getSize(56),
                          width: getSize(56),
                          radius: BorderRadius.circular(
                            getHorizontalSize(28),
                          ),
                          alignment: Alignment.center,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: getSize(16),
                            width: getSize(16),
                            decoration: BoxDecoration(
                              color: appTheme.tealA700,
                              borderRadius: BorderRadius.circular(
                                getHorizontalSize(8),
                              ),
                              border: Border.all(
                                color: theme.colorScheme.onPrimaryContainer
                                    .withOpacity(1),
                                width: getHorizontalSize(1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      left: 12,
                      top: 3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            messageItemModelObj.estherhowardTxt.value,
                            style: CustomTextStyles.titleMediumBold,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            top: 9,
                          ),
                          child: Text(
                            "msg_lorem_ipsum_dolor4".tr,
                            style: CustomTextStyles.titleSmallBluegray400_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      left: 30,
                      top: 7,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "lbl_10_20".tr,
                          style: CustomTextStyles.labelLargeSemiBold,
                        ),
                        Container(
                          margin: getMargin(
                            top: 6,
                          ),
                          padding: getPadding(
                            left: 8,
                            top: 5,
                            right: 8,
                            bottom: 5,
                          ),
                          decoration: AppDecoration.fillPrimary.copyWith(
                            borderRadius: BorderRadiusStyle.circleBorder12,
                          ),
                          child: Obx(
                            () => Text(
                              messageItemModelObj.group162722Txt.value,
                              style: theme.textTheme.labelMedium,
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
      ),
    );
  }
}
