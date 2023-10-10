import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/select_a_country_screen/models/select_a_country_model.dart';import 'package:flutter/material.dart';/// A controller class for the SelectACountryScreen.
///
/// This class manages the state of the SelectACountryScreen, including the
/// current selectACountryModelObj
class SelectACountryController extends GetxController {TextEditingController searchController = TextEditingController();

Rx<SelectACountryModel> selectACountryModelObj = SelectACountryModel().obs;

Rx<String> radioGroup = "".obs;

@override void onClose() { super.onClose(); searchController.dispose(); } 
 }
