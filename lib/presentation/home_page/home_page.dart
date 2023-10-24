import '../home_page/widgets/home_item_widget.dart';
import 'controller/home_controller.dart';
import 'models/home_item_model.dart';
import 'models/home_model.dart';
import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_circleimage.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_image_1.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_subtitle.dart';
import 'package:drawing_on_demand/widgets/app_bar/appbar_subtitle_2.dart';
import 'package:drawing_on_demand/widgets/app_bar/custom_app_bar.dart';
import 'package:drawing_on_demand/widgets/custom_icon_button.dart';
import 'package:drawing_on_demand/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key})
      : super(
          key: key,
        );

  HomeController controller = Get.put(HomeController(HomeModel().obs));

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.whiteA70001,
        appBar: CustomAppBar(
          leadingWidth: getHorizontalSize(74),
          leading: AppbarCircleimage(
            imagePath: ImageConstant.imgImage50x50,
            margin: getMargin(
              left: 24,
            ),
          ),
          title: Padding(
            padding: getPadding(
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppbarSubtitle(
                  text: "msg_hi_welcome_back".tr,
                ),
                AppbarSubtitle2(
                  text: "msg_find_your_dream2".tr,
                  margin: getMargin(
                    top: 9,
                    right: 33,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            AppbarImage1(
              svgPath: ImageConstant.imgNotification,
              margin: getMargin(
                left: 24,
                top: 13,
                right: 24,
                bottom: 13,
              ),
            ),
          ],
        ),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: CustomSearchView(
                  margin: getMargin(
                    left: 24,
                    top: 30,
                    right: 24,
                  ),
                  controller: controller.searchController,
                  hintText: "lbl_search".tr,
                  hintStyle: CustomTextStyles.titleMediumBluegray400,
                  alignment: Alignment.center,
                  prefix: Container(
                    margin: getMargin(
                      left: 16,
                      top: 17,
                      right: 8,
                      bottom: 17,
                    ),
                    child: CustomImageView(
                      svgPath: ImageConstant.imgSearch,
                    ),
                  ),
                  prefixConstraints: BoxConstraints(
                    maxHeight: getVerticalSize(52),
                  ),
                  suffix: Container(
                    margin: getMargin(
                      left: 30,
                      top: 17,
                      right: 16,
                      bottom: 17,
                    ),
                    child: CustomImageView(
                      svgPath: ImageConstant.imgFilterPrimary,
                    ),
                  ),
                  suffixConstraints: BoxConstraints(
                    maxHeight: getVerticalSize(52),
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  left: 24,
                  top: 25,
                ),
                child: Text(
                  "lbl_recommendation".tr,
                  style: CustomTextStyles.titleMedium18,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: getPadding(
                    left: 24,
                    top: 17,
                  ),
                  child: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: getPadding(
                              all: 16,
                            ),
                            decoration: AppDecoration.fillPrimary.copyWith(
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
                                    bottom: 96,
                                  ),
                                  padding: getPadding(
                                    all: 8,
                                  ),
                                  decoration: IconButtonStyleHelper
                                      .fillOnPrimaryContainer,
                                  child: CustomImageView(
                                    svgPath: ImageConstant.imgFrame162722,
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    left: 12,
                                    top: 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "msg_senior_ui_ux_designer".tr,
                                        style: CustomTextStyles
                                            .titleSmallGray5001Bold,
                                      ),
                                      Opacity(
                                        opacity: 0.8,
                                        child: Padding(
                                          padding: getPadding(
                                            top: 7,
                                          ),
                                          child: Text(
                                            "lbl_shopee".tr,
                                            style: CustomTextStyles
                                                .labelLargeGray5001SemiBold,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: 0.64,
                                        child: Padding(
                                          padding: getPadding(
                                            top: 11,
                                          ),
                                          child: Text(
                                            "msg_jakarta_indonesia".tr,
                                            style: CustomTextStyles
                                                .labelLargeGray5001_2,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 9,
                                        ),
                                        child: Text(
                                          "msg_1100_12_000_month".tr,
                                          style: CustomTextStyles
                                              .labelLargeGray5001_1,
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 17,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: getPadding(
                                                left: 12,
                                                top: 5,
                                                right: 12,
                                                bottom: 5,
                                              ),
                                              decoration: AppDecoration
                                                  .fillOnPrimaryContainer1
                                                  .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder16,
                                              ),
                                              child: Text(
                                                "lbl_fulltime".tr,
                                                style: CustomTextStyles
                                                    .labelLargeGray5001,
                                              ),
                                            ),
                                            Container(
                                              margin: getMargin(
                                                left: 7,
                                              ),
                                              padding: getPadding(
                                                left: 12,
                                                top: 4,
                                                right: 12,
                                                bottom: 4,
                                              ),
                                              decoration: AppDecoration
                                                  .fillOnPrimaryContainer1
                                                  .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder16,
                                              ),
                                              child: Text(
                                                "lbl_two_days_ago".tr,
                                                style: CustomTextStyles
                                                    .labelLargeGray5001,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: getMargin(
                              left: 16,
                            ),
                            padding: getPadding(
                              all: 16,
                            ),
                            decoration: AppDecoration.fillDeepPurple.copyWith(
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
                                    bottom: 96,
                                  ),
                                  padding: getPadding(
                                    all: 8,
                                  ),
                                  decoration: IconButtonStyleHelper
                                      .fillOnPrimaryContainer,
                                  child: CustomImageView(
                                    svgPath: ImageConstant.imgFrame162722,
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "msg_senior_ui_ux_designer".tr,
                                        style: CustomTextStyles
                                            .titleSmallGray5001Bold,
                                      ),
                                      Opacity(
                                        opacity: 0.8,
                                        child: Padding(
                                          padding: getPadding(
                                            top: 4,
                                          ),
                                          child: Text(
                                            "lbl_shopee".tr,
                                            style: CustomTextStyles
                                                .labelLargeGray5001SemiBold,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: 0.64,
                                        child: Container(
                                          width: getHorizontalSize(181),
                                          margin: getMargin(
                                            top: 8,
                                          ),
                                          child: Text(
                                            "msg_jakarta_indonesia".tr,
                                            maxLines: null,
                                            overflow: TextOverflow.ellipsis,
                                            style: CustomTextStyles
                                                .labelLargeGray5001_2
                                                .copyWith(
                                              height: 1.67,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 4,
                                        ),
                                        child: Text(
                                          "msg_1100_12_000_month".tr,
                                          style: CustomTextStyles
                                              .labelLargeGray5001_1,
                                        ),
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: getPadding(
                                                left: 12,
                                                top: 4,
                                                right: 12,
                                                bottom: 4,
                                              ),
                                              decoration: AppDecoration
                                                  .fillOnPrimaryContainer1
                                                  .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder16,
                                              ),
                                              child: Text(
                                                "lbl_fulltime".tr,
                                                style: CustomTextStyles
                                                    .labelLargeGray5001,
                                              ),
                                            ),
                                            Container(
                                              margin: getMargin(
                                                left: 7,
                                              ),
                                              padding: getPadding(
                                                left: 12,
                                                top: 4,
                                                right: 12,
                                                bottom: 4,
                                              ),
                                              decoration: AppDecoration
                                                  .fillOnPrimaryContainer1
                                                  .copyWith(
                                                borderRadius: BorderRadiusStyle
                                                    .roundedBorder16,
                                              ),
                                              child: Text(
                                                "lbl_two_days_ago".tr,
                                                style: CustomTextStyles
                                                    .labelLargeGray5001,
                                              ),
                                            ),
                                          ],
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
                  ),
                ),
              ),
              Padding(
                padding: getPadding(
                  left: 24,
                  top: 22,
                ),
                child: Text(
                  "lbl_recent_jobs".tr,
                  style: CustomTextStyles.titleMediumInter,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: getPadding(
                      left: 24,
                      top: 16,
                      right: 24,
                    ),
                    child: Obx(
                      () => ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (
                          context,
                          index,
                        ) {
                          return SizedBox(
                            height: getVerticalSize(16),
                          );
                        },
                        itemCount: controller
                            .homeModelObj.value.homeItemList.value.length,
                        itemBuilder: (context, index) {
                          HomeItemModel model = controller
                              .homeModelObj.value.homeItemList.value[index];
                          return HomeItemWidget(
                            model,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
