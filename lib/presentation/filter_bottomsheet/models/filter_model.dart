import 'package:get/get.dart';import 'chipviewjobs_item_model.dart';/// This class defines the variables used in the [filter_bottomsheet],
/// and is typically used to hold data that is passed between different parts of the application.
class FilterModel {Rx<List<ChipviewjobsItemModel>> chipviewjobsItemList = Rx(List.generate(2,(index) =>ChipviewjobsItemModel()));

 }
