import 'package:get/get.dart';import 'saved_item_model.dart';/// This class defines the variables used in the [saved_page],
/// and is typically used to hold data that is passed between different parts of the application.
class SavedModel {Rx<List<SavedItemModel>> savedItemList = Rx(List.generate(4,(index) => SavedItemModel()));

 }
