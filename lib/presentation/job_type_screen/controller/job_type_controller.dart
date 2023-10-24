import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/job_type_screen/models/job_type_model.dart';/// A controller class for the JobTypeScreen.
///
/// This class manages the state of the JobTypeScreen, including the
/// current jobTypeModelObj
class JobTypeController extends GetxController {Rx<JobTypeModel> jobTypeModelObj = JobTypeModel().obs;

 }
