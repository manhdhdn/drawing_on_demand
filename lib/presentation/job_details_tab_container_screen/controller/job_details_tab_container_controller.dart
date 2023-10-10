import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/job_details_tab_container_screen/models/job_details_tab_container_model.dart';import 'package:flutter/material.dart';/// A controller class for the JobDetailsTabContainerScreen.
///
/// This class manages the state of the JobDetailsTabContainerScreen, including the
/// current jobDetailsTabContainerModelObj
class JobDetailsTabContainerController extends GetxController with  GetSingleTickerProviderStateMixin {Rx<JobDetailsTabContainerModel> jobDetailsTabContainerModelObj = JobDetailsTabContainerModel().obs;

late TabController tabviewController = Get.put(TabController(vsync: this, length: 3));

 }
