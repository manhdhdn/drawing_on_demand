import '../search_screen/widgets/search_item_widget.dart';import 'controller/search_controller.dart';import 'models/search_item_model.dart';import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/widgets/app_bar/appbar_image.dart';import 'package:drawing_on_demand/widgets/app_bar/appbar_title.dart';import 'package:drawing_on_demand/widgets/app_bar/custom_app_bar.dart';import 'package:drawing_on_demand/widgets/custom_search_view.dart';import 'package:flutter/material.dart' hide SearchController;class SearchScreen extends GetWidget<SearchController> {const SearchScreen({Key? key}) : super(key: key);

@override Widget build(BuildContext context) { mediaQueryData = MediaQuery.of(context); return SafeArea(child: Scaffold(resizeToAvoidBottomInset: false, backgroundColor: appTheme.whiteA70001, appBar: CustomAppBar(leadingWidth: getHorizontalSize(48), leading: AppbarImage(svgPath: ImageConstant.imgGroup162799, margin: getMargin(left: 24, top: 13, bottom: 13), onTap: () {onTapArrowbackone();}), centerTitle: true, title: AppbarTitle(text: "lbl_find_jobs".tr)), body: Container(width: double.maxFinite, padding: getPadding(left: 24, right: 24), child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [CustomSearchView(margin: getMargin(top: 30), controller: controller.searchController, hintText: "lbl_search".tr, hintStyle: CustomTextStyles.titleMediumBluegray400, prefix: Container(margin: getMargin(left: 16, top: 17, right: 8, bottom: 17), child: CustomImageView(svgPath: ImageConstant.imgSearch)), prefixConstraints: BoxConstraints(maxHeight: getVerticalSize(52)), suffix: Container(margin: getMargin(left: 30, top: 17, right: 16, bottom: 17), child: CustomImageView(svgPath: ImageConstant.imgFilterPrimary)), suffixConstraints: BoxConstraints(maxHeight: getVerticalSize(52))), Expanded(child: Padding(padding: getPadding(top: 24), child: Obx(() => ListView.separated(physics: BouncingScrollPhysics(), shrinkWrap: true, separatorBuilder: (context, index) {return SizedBox(height: getVerticalSize(12));}, itemCount: controller.searchModelObj.value.searchItemList.value.length, itemBuilder: (context, index) {SearchItemModel model = controller.searchModelObj.value.searchItemList.value[index]; return SearchItemWidget(model);})))), GestureDetector(onTap: () {onTapView();}, child: Container(height: getVerticalSize(148), width: getHorizontalSize(327), decoration: BoxDecoration(color: theme.colorScheme.onPrimaryContainer.withOpacity(1), borderRadius: BorderRadius.circular(getHorizontalSize(16)), border: Border.all(color: appTheme.indigo50, width: getHorizontalSize(1)))))])))); } 


/// Navigates to the previous screen.
///
/// When the action is triggered, this function uses the [Get] package to 
/// navigate to the previous screen in the navigation stack.
onTapArrowbackone() { Get.back(); } 
/// Navigates to the jobDetailsTabContainerScreen when the action is triggered.

/// When the action is triggered, this function uses the [Get] package to
/// push the named route for the jobDetailsTabContainerScreen.
onTapView() { Get.toNamed(AppRoutes.jobDetailsTabContainerScreen, ); } 
 }
