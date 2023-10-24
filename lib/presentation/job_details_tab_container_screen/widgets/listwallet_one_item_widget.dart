import '../controller/job_details_tab_container_controller.dart';
import '../models/listwallet_one_item_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListwalletOneItemWidget extends StatelessWidget {
  ListwalletOneItemWidget(
    this.listwalletOneItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  ListwalletOneItemModel listwalletOneItemModelObj;

  var controller = Get.find<JobDetailsTabContainerController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getHorizontalSize(67),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomIconButton(
            height: getSize(48),
            width: getSize(48),
            padding: getPadding(
              all: 12,
            ),
            decoration: IconButtonStyleHelper.fillTealA,
            child: CustomImageView(
              svgPath: ImageConstant.imgWallet,
            ),
          ),
          Padding(
            padding: getPadding(
              top: 9,
            ),
            child: Obx(
              () => Text(
                listwalletOneItemModelObj.salaryTxt.value,
                style: CustomTextStyles.labelLargeBluegray300,
              ),
            ),
          ),
          Padding(
            padding: getPadding(
              top: 9,
            ),
            child: Obx(
              () => Text(
                listwalletOneItemModelObj.priceTxt.value,
                style: CustomTextStyles.titleSmallPrimarySemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
