import 'package:get/get.dart';import 'listwallet_one_item_model.dart';/// This class defines the variables used in the [job_details_tab_container_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class JobDetailsTabContainerModel {Rx<List<ListwalletOneItemModel>> listwalletOneItemList = Rx(List.generate(3,(index) => ListwalletOneItemModel()));

 }
