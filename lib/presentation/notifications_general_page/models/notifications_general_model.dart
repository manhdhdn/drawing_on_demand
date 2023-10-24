import 'package:get/get.dart';import 'listlogo_one_item_model.dart';/// This class defines the variables used in the [notifications_general_page],
/// and is typically used to hold data that is passed between different parts of the application.
class NotificationsGeneralModel {Rx<List<ListlogoOneItemModel>> listlogoOneItemList = Rx(List.generate(4,(index) => ListlogoOneItemModel()));

 }
