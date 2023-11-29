import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/common/common_features.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/category_api.dart';
import '../../../data/apis/material_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/apis/surface_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/category.dart';
import '../../../data/models/material.dart' as material_model;
import '../../../data/models/requirement.dart';
import '../../../data/models/surface.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class CreateNewJobPost extends StatefulWidget {
  const CreateNewJobPost({Key? key}) : super(key: key);

  @override
  State<CreateNewJobPost> createState() => _CreateNewJobPostState();
}

class _CreateNewJobPostState extends State<CreateNewJobPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  Set<Category> categories = {};
  Set<material_model.Material> materials = {};
  Set<Surface> surfaces = {};

  Guid? selectedCategory;
  Guid? selectedMaterial;
  Guid? selectedSurface;
  int selectedPieces = 1;

  @override
  void initState() {
    super.initState();

    getData();
  }

  DropdownButton<Guid> getCategory() {
    List<DropdownMenuItem<Guid>> dropDownItems = [];
    for (Category des in categories) {
      var item = DropdownMenuItem(
        value: des.id,
        child: Text(des.name!),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedCategory,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
    );
  }

  DropdownButton<Guid> getMaterial() {
    List<DropdownMenuItem<Guid>> dropDownItems = [];
    for (material_model.Material des in materials) {
      var item = DropdownMenuItem(
        value: des.id,
        child: Text(des.name!),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedMaterial,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedMaterial = value!;
        });
      },
    );
  }

  DropdownButton<Guid> getSurface() {
    List<DropdownMenuItem<Guid>> dropDownItems = [];
    for (Surface des in surfaces) {
      var item = DropdownMenuItem(
        value: des.id,
        child: Text(des.name!),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedSurface,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedSurface = value!;
        });
      },
    );
  }

  DropdownButton<int> getPieces() {
    List<DropdownMenuItem<int>> dropDownItems = [];
    for (int des in pieces) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des.toString()),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedPieces,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedPieces = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'Create New Requirement',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          width: context.width(),
          height: context.height(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  'Overview',
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  cursorColor: kNeutralColor,
                  textInputAction: TextInputAction.next,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Requirement Title',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintText: 'Enter requirement title',
                    hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                    focusColor: kNeutralColor,
                    border: const OutlineInputBorder(),
                  ),
                  controller: titleController,
                ),
                const SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return InputDecorator(
                      decoration: kInputDecoration.copyWith(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                              color: kBorderColorTextField, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(7.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Choose a Category',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                      child: DropdownButtonHideUnderline(child: getCategory()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return InputDecorator(
                      decoration: kInputDecoration.copyWith(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                              color: kBorderColorTextField, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(7.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Choose a Material',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                      child: DropdownButtonHideUnderline(child: getMaterial()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return InputDecorator(
                      decoration: kInputDecoration.copyWith(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                              color: kBorderColorTextField, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(7.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Choose a Surface',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                      child: DropdownButtonHideUnderline(child: getSurface()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                FormField(
                  builder: (FormFieldState<dynamic> field) {
                    return InputDecorator(
                      decoration: kInputDecoration.copyWith(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          borderSide: BorderSide(
                              color: kBorderColorTextField, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(7.0),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Pieces',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      ),
                      child: DropdownButtonHideUnderline(child: getPieces()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  cursorColor: kNeutralColor,
                  textInputAction: TextInputAction.next,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Budget',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintText: 'Price you can pay',
                    hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                    focusColor: kNeutralColor,
                    border: const OutlineInputBorder(),
                  ),
                  controller: budgetController,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  cursorColor: kNeutralColor,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Describe',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintText: 'I need an artist for...',
                    hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                    focusColor: kNeutralColor,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: const OutlineInputBorder(),
                  ),
                  controller: descriptionController,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  showCursor: false,
                  readOnly: true,
                  cursorColor: kNeutralColor,
                  textInputAction: TextInputAction.next,
                  decoration: kInputDecoration.copyWith(
                    labelText: 'Upload Image',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintText: 'Upload image here',
                    hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                    focusColor: kNeutralColor,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(
                      FeatherIcons.upload,
                      color: kLightNeutralColor,
                    ),
                  ),
                  controller: imageController,
                  onTap: () async {
                    await pickImage();
                    imageController.text =
                        images.isNotEmpty ? images.last.name : '';
                  },
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kWhite),
        child: ButtonGlobalWithoutIcon(
            buttontext: 'Done',
            buttonDecoration: kButtonDecoration.copyWith(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              onDone();
            },
            buttonTextColor: kWhite),
      ),
    );
  }

  void getData() async {
    var dataCategories = (await CategoryApi().gets(0)).value;
    var dataMaterials = (await MaterialApi().gets(0)).value;
    var dataSurfaces = (await SurfaceApi().gets(0)).value;

    setState(() {
      categories = dataCategories;
      materials = dataMaterials;
      surfaces = dataSurfaces;
    });

    setState(() {
      selectedCategory = categories.first.id;
      selectedMaterial = materials.first.id;
      selectedSurface = surfaces.first.id;
    });
  }

  void onUploadImage() {
    pickImage();
  }

  void onDone() async {
    try {
      ProgressDialogUtils.showProgress(context);

      String? image;

      if (images.isNotEmpty) {
        image = await uploadImage(images.last);
        images.clear();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var accountId =
          Account.fromJson(jsonDecode(prefs.getString('account')!)).id;

      var requirement = Requirement(
        id: Guid.newGuid,
        title: titleController.text,
        description: descriptionController.text,
        image: image,
        pieces: selectedPieces,
        budget: Decimal.parse(budgetController.text),
        createdDate: DateTime.now(),
        status: 'Public',
        categoryId: selectedCategory,
        materialId: selectedMaterial,
        surfaceId: selectedSurface,
        createdBy: accountId,
      );

      await RequirementApi().postOne(requirement);

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: errorSomethingWentWrong);
    }
  }
}
