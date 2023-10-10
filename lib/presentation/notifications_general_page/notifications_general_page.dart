import '../notifications_general_page/widgets/listlogo_one_item_widget.dart';import 'controller/notifications_general_controller.dart';import 'models/listlogo_one_item_model.dart';import 'models/notifications_general_model.dart';import 'package:drawing_on_demand/core/app_export.dart';import 'package:flutter/material.dart';
// ignore_for_file: must_be_immutable
class NotificationsGeneralPage extends StatelessWidget {NotificationsGeneralPage({Key? key}) : super(key: key);

NotificationsGeneralController controller = Get.put(NotificationsGeneralController(NotificationsGeneralModel().obs));

@override Widget build(BuildContext context) { mediaQueryData = MediaQuery.of(context); return SafeArea(child: Scaffold(backgroundColor: appTheme.whiteA70001, body: Container(width: double.maxFinite, decoration: AppDecoration.fillWhiteA70001, child: Padding(padding: getPadding(left: 24, top: 24, right: 24), child: Obx(() => ListView.separated(physics: BouncingScrollPhysics(), shrinkWrap: true, separatorBuilder: (context, index) {return Padding(padding: getPadding(top: 7.5, bottom: 7.5), child: SizedBox(width: getHorizontalSize(323), child: Divider(height: getVerticalSize(1), thickness: getVerticalSize(1), color: appTheme.indigo50)));}, itemCount: controller.notificationsGeneralModelObj.value.listlogoOneItemList.value.length, itemBuilder: (context, index) {ListlogoOneItemModel model = controller.notificationsGeneralModelObj.value.listlogoOneItemList.value[index]; return ListlogoOneItemWidget(model);})))))); } 
 }
