import '../saved_page/widgets/saved_item_widget.dart';import 'controller/saved_controller.dart';import 'models/saved_item_model.dart';import 'models/saved_model.dart';import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/widgets/app_bar/appbar_image.dart';import 'package:drawing_on_demand/widgets/app_bar/appbar_title.dart';import 'package:drawing_on_demand/widgets/app_bar/custom_app_bar.dart';import 'package:flutter/material.dart';
// ignore_for_file: must_be_immutable
class SavedPage extends StatelessWidget {SavedPage({Key? key}) : super(key: key);

SavedController controller = Get.put(SavedController(SavedModel().obs));

@override Widget build(BuildContext context) { mediaQueryData = MediaQuery.of(context); return SafeArea(child: Scaffold(backgroundColor: appTheme.whiteA70001, appBar: CustomAppBar(leadingWidth: getHorizontalSize(48), leading: AppbarImage(svgPath: ImageConstant.imgGroup162799, margin: getMargin(left: 24, top: 13, bottom: 13), onTap: () {onTapArrowbackone();}), centerTitle: true, title: AppbarTitle(text: "lbl_saved".tr)), body: Container(width: double.maxFinite, padding: getPadding(left: 24, right: 24), child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [Expanded(child: Padding(padding: getPadding(top: 30), child: Obx(() => ListView.separated(physics: BouncingScrollPhysics(), shrinkWrap: true, separatorBuilder: (context, index) {return SizedBox(height: getVerticalSize(12));}, itemCount: controller.savedModelObj.value.savedItemList.value.length, itemBuilder: (context, index) {SavedItemModel model = controller.savedModelObj.value.savedItemList.value[index]; return SavedItemWidget(model);})))), Container(height: getVerticalSize(148), width: getHorizontalSize(327), decoration: BoxDecoration(color: appTheme.gray5001, borderRadius: BorderRadius.circular(getHorizontalSize(16)), border: Border.all(color: appTheme.indigo50, width: getHorizontalSize(1))))])))); } 


/// Navigates to the previous screen.
///
/// When the action is triggered, this function uses the [Get] package to 
/// navigate to the previous screen in the navigation stack.
onTapArrowbackone() { Get.back(); } 
 }
