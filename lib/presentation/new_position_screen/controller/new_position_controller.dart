import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/new_position_screen/models/new_position_model.dart';import 'package:flutter/material.dart';/// A controller class for the NewPositionScreen.
///
/// This class manages the state of the NewPositionScreen, including the
/// current newPositionModelObj
class NewPositionController extends GetxController {TextEditingController frameOneController = TextEditingController();

TextEditingController nameController = TextEditingController();

TextEditingController locationController = TextEditingController();

TextEditingController groupTwentySeveController = TextEditingController();

Rx<NewPositionModel> newPositionModelObj = NewPositionModel().obs;

SelectionPopupModel? selectedDropDownValue;

DateTime selectedSelectdateDate = DateTime.now();

DateTime selectedSelectdate1Date = DateTime.now();

@override void onClose() { super.onClose(); frameOneController.dispose(); nameController.dispose(); locationController.dispose(); groupTwentySeveController.dispose(); } 
onSelected(dynamic value) { for (var element in newPositionModelObj.value.dropdownItemList.value) {element.isSelected = false; if (element.id == value.id) {element.isSelected = true;}} newPositionModelObj.value.dropdownItemList.refresh(); } 
 }
