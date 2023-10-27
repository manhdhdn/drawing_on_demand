import 'dart:convert';

import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/data/apiClient/api_account_role.dart';
import 'package:drawing_on_demand/data/apiClient/api_role.dart';
import 'package:drawing_on_demand/data/models/account_role.dart';
import 'package:drawing_on_demand/data/models/role.dart';
import 'package:drawing_on_demand/presentation/job_type_screen/models/job_type_model.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A controller class for the JobTypeScreen.
///
/// This class manages the state of the JobTypeScreen, including the
/// current jobTypeModelObj
class JobTypeController extends GetxController {
  Rx<JobTypeModel> jobTypeModelObj = JobTypeModel().obs;

  Rx<String> role = "Customer".obs;

  Future<void> addAccountToRole(String roleName) async {
    try {
      if (roleName != "Customer") {
        Set<Role> roles = await Get.find<ApiRole>().filter("name", roleName);

        AccountRole accountRole = AccountRole(
          id: Guid.generate(),
          addedDate: DateTime.now(),
          status: "Pending",
          accountId: Guid(jsonDecode(Get.find<PrefUtils>().getAccount())["id"]),
          roleId: roles.first.id,
        );

        await Get.find<ApiAccountRole>().postOne(accountRole);
      }

      Get.toNamed(AppRoutes.speciallizationScreen);
    } catch (error, stackTrace) {
      Logger.log(
        error,
        stackTrace: stackTrace,
      );

      Fluttertoast.showToast(msg: "msg_something_went_wrong".tr);
    }
  }
}
