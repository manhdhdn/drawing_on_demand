import 'package:drawing_on_demand/core/app_export.dart';import 'package:drawing_on_demand/presentation/message_action_screen/models/message_action_model.dart';import 'package:flutter/material.dart';/// A controller class for the MessageActionScreen.
///
/// This class manages the state of the MessageActionScreen, including the
/// current messageActionModelObj
class MessageActionController extends GetxController {TextEditingController searchController = TextEditingController();

Rx<MessageActionModel> messageActionModelObj = MessageActionModel().obs;

@override void onClose() { super.onClose(); searchController.dispose(); } 
 }
