import 'package:get/get.dart';import 'search_item_model.dart';/// This class defines the variables used in the [search_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class SearchModel {Rx<List<SearchItemModel>> searchItemList = Rx(List.generate(4,(index) => SearchItemModel()));

 }
