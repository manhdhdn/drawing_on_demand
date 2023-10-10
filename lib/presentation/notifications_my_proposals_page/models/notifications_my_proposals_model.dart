import 'package:get/get.dart';import 'listlocation_item_model.dart';/// This class defines the variables used in the [notifications_my_proposals_page],
/// and is typically used to hold data that is passed between different parts of the application.
class NotificationsMyProposalsModel {Rx<List<ListlocationItemModel>> listlocationItemList = Rx(List.generate(3,(index) => ListlocationItemModel()));

 }
