import 'package:drawing_on_demand/core/app_export.dart';
import 'package:drawing_on_demand/presentation/apply_job_popup_dialog/models/apply_job_popup_model.dart';

/// A controller class for the ApplyJobPopupDialog.
///
/// This class manages the state of the ApplyJobPopupDialog, including the
/// current applyJobPopupModelObj
class ApplyJobPopupController extends GetxController {
  Rx<ApplyJobPopupModel> applyJobPopupModelObj = ApplyJobPopupModel().obs;
}
