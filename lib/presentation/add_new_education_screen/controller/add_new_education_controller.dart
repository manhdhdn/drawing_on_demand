import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/add_new_education_screen/models/add_new_education_model.dart';import 'package:flutter/material.dart';/// A controller class for the AddNewEducationScreen.
///
/// This class manages the state of the AddNewEducationScreen, including the
/// current addNewEducationModelObj
class AddNewEducationController extends GetxController {TextEditingController frameOneController = TextEditingController();

TextEditingController frameoneoneController = TextEditingController();

TextEditingController frameonetwoController = TextEditingController();

TextEditingController groupEightyOneController = TextEditingController();

Rx<AddNewEducationModel> addNewEducationModelObj = AddNewEducationModel().obs;

SelectionPopupModel? selectedDropDownValue;

DateTime selectedSelectdateDate = DateTime.now();

DateTime selectedSelectdate1Date = DateTime.now();

@override void onClose() { super.onClose(); frameOneController.dispose(); frameoneoneController.dispose(); frameonetwoController.dispose(); groupEightyOneController.dispose(); } 
onSelected(dynamic value) { for (var element in addNewEducationModelObj.value.dropdownItemList.value) {element.isSelected = false; if (element.id == value.id) {element.isSelected = true;}} addNewEducationModelObj.value.dropdownItemList.refresh(); } 
 }
