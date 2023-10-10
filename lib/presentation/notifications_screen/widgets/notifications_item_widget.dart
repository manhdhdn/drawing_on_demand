import '../controller/notifications_controller.dart';
import '../models/notifications_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_switch.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationsItemWidget extends StatelessWidget {
  NotificationsItemWidget(
    this.notificationsItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  NotificationsItemModel notificationsItemModelObj;

  var controller = Get.find<NotificationsController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            notificationsItemModelObj.newpostTxt.value,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        Obx(
          () => CustomSwitch(
            value: notificationsItemModelObj.isSelectedSwitch.value,
            onChange: (value) {
              notificationsItemModelObj.isSelectedSwitch.value = value;
            },
          ),
        ),
      ],
    );
  }
}
