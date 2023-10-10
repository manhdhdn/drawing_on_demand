import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/sign_up_complete_account_screen/models/sign_up_complete_account_model.dart';import 'package:flutter/material.dart';import 'package:drawing_on_demand/data/models/registerDeviceAuth/post_register_device_auth_resp.dart';import 'package:drawing_on_demand/data/apiClient/api_client.dart';/// A controller class for the SignUpCompleteAccountScreen.
///
/// This class manages the state of the SignUpCompleteAccountScreen, including the
/// current signUpCompleteAccountModelObj
class SignUpCompleteAccountController extends GetxController {TextEditingController firstNameController = TextEditingController();

TextEditingController lastNameController = TextEditingController();

TextEditingController passwordController = TextEditingController();

Rx<SignUpCompleteAccountModel> signUpCompleteAccountModelObj = SignUpCompleteAccountModel().obs;

Rx<bool> isShowPassword = true.obs;

PostRegisterDeviceAuthResp postRegisterDeviceAuthResp = PostRegisterDeviceAuthResp();

@override void onClose() { super.onClose(); firstNameController.dispose(); lastNameController.dispose(); passwordController.dispose(); } 
/// Calls the https://nodedemo.dhiwise.co/device/auth/register API with the specified request data.
///
/// The [Map] parameter represents request body
Future<void> callRegisterDeviceAuth(Map req) async  { try{
postRegisterDeviceAuthResp   =  await Get.find<ApiClient>().registerDeviceAuth(headers: {'Content-Type': 'application/json',}, requestData: req, );
_handleRegisterDeviceAuthSuccess();
} on PostRegisterDeviceAuthResp catch(e)
{
postRegisterDeviceAuthResp = e;
rethrow;
} } 
/// handles the success response for the API
void _handleRegisterDeviceAuthSuccess() { 

Get.find<PrefUtils>().setId(postRegisterDeviceAuthResp.data?.id ?? ''); } 
 }
