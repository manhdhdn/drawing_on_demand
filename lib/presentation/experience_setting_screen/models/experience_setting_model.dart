import 'package:get/get.dart';import 'experience_item_model.dart';/// This class defines the variables used in the [experience_setting_screen],
/// and is typically used to hold data that is passed between different parts of the application.
class ExperienceSettingModel {Rx<List<ExperienceItemModel>> experienceItemList = Rx(List.generate(3,(index) => ExperienceItemModel()));

 }
