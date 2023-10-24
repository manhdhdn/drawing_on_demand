import 'package:get/get.dart';import 'listenglishuk_item_model.dart';import 'listchineses_item_model.dart';/// This class defines the variables used in the [language_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class LanguageModel {Rx<List<ListenglishukItemModel>> listenglishukItemList = Rx(List.generate(3,(index) => ListenglishukItemModel()));

Rx<List<ListchinesesItemModel>> listchinesesItemList = Rx(List.generate(6,(index) => ListchinesesItemModel()));

 }
