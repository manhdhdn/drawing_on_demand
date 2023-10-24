import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/personal_info_screen/models/personal_info_model.dart';import 'package:flutter/material.dart';import 'package:drawing_on_demand/data/models/me/get_me_resp.dart';import 'package:drawing_on_demand/data/apiClient/api_client.dart';/// A controller class for the PersonalInfoScreen.
///
/// This class manages the state of the PersonalInfoScreen, including the
/// current personalInfoModelObj
class PersonalInfoController extends GetxController {TextEditingController firstNameController = TextEditingController();

TextEditingController lastNameController = TextEditingController();

TextEditingController emailController = TextEditingController();

TextEditingController phoneController = TextEditingController();

TextEditingController locationController = TextEditingController();

Rx<PersonalInfoModel> personalInfoModelObj = PersonalInfoModel().obs;

GetMeResp getMeResp = GetMeResp();

@override void onClose() { super.onClose(); firstNameController.dispose(); lastNameController.dispose(); emailController.dispose(); phoneController.dispose(); locationController.dispose(); } 
/// Calls the https://nodedemo.dhiwise.co/device/api/v1/user/me API with the specified request data.
///
/// The [Map] parameter represents request body
Future<void> callFetchMe() async  { try{
getMeResp   =  await Get.find<ApiClient>().fetchMe(headers: {'Content-type': 'application/json','Authorization': 'Bearer  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYxNmZiNzBhZWJiM2RiYjVlYmVkYTBmMiIsInVzZXJuYW1lIjoiT3Jpb24xNyIsImlhdCI6MTY3ODc3NjY2OX0.16TzzeJMkGbsT-hk-wigjBt4xeJNcwNzVvnl05evYUk',});
_handleFetchMeSuccess();
} on GetMeResp catch(e)
{
getMeResp = e;
rethrow;
} } 
/// handles the success response for the API
void _handleFetchMeSuccess() { 

emailController.text = getMeResp.data!.email!.toString();firstNameController.text = getMeResp.data!.name!.toString(); } 
/// calls the [https://nodedemo.dhiwise.co/device/api/v1/user/me] API 
///
/// It has [GetMeReq] as a parameter which will be passed as a API request body
/// If the call is successful, the function calls the `_onFetchMeSuccess()` function.
/// If the call fails, the function calls the `_onFetchMeError()` function.
///
/// Throws a `NoInternetException` if there is no internet connection.
@override Future<void> onReady() async  { try {
await callFetchMe();_onFetchMeSuccess();} on GetMeResp {_onFetchMeError();} on NoInternetException catch (e) {Get.rawSnackbar(message: e.toString());} catch (e) {
 //TODO: Handle generic errors
} } 
void _onFetchMeSuccess() {  } 
void _onFetchMeError() { 
 } 
 }
