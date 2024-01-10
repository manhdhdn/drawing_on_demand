import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/category_api.dart';
import '../../../data/apis/material_api.dart';
import '../../../data/apis/requirement_api.dart';
import '../../../data/apis/size_api.dart';
import '../../../data/apis/surface_api.dart';
import '../../../data/models/category.dart';
import '../../../data/models/material.dart' as material_model;
import '../../../data/models/requirement.dart';
import '../../../data/models/size.dart';
import '../../../data/models/surface.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import 'job_post.dart';

class CreateNewJobPost extends StatefulWidget {
  const CreateNewJobPost({Key? key}) : super(key: key);

  @override
  State<CreateNewJobPost> createState() => _CreateNewJobPostState();
}

class _CreateNewJobPostState extends State<CreateNewJobPost> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController(text: '1');
  TextEditingController budgetController = TextEditingController();

  List<Category> categories = [];
  List<material_model.Material> materials = [];
  List<Surface> surfaces = [];

  Guid? selectedCategory;
  Guid? selectedMaterial;
  Guid? selectedSurface;
  int selectedPieces = 1;
  String selectedStatus = 'Public';

  List<int> widths = [];
  List<int> lengths = [];
  List<String> status = ['Public', 'Private'];

  DropdownButton<Guid> getCategories() {
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

  DropdownButton<Guid> getMaterials() {
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

  DropdownButton<Guid> getSurfaces() {
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

  DropdownButton<String> getStatus() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String des in status) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedStatus,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedStatus = value!;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    getData();

    images.clear();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '$dod | Create requirement',
      color: kPrimaryColor,
      child: Scaffold(
        backgroundColor: kDarkWhite,
        appBar: AppBar(
          backgroundColor: kDarkWhite,
          elevation: 0,
          iconTheme: const IconThemeData(color: kNeutralColor),
          title: Text(
            'Create New Requirement',
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            height: context.height(),
            width: context.width(),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      'Overview',
                      style: kTextStyle.copyWith(
                        color: kNeutralColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      cursorColor: kNeutralColor,
                      textInputAction: TextInputAction.next,
                      maxLength: 60,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Title',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                        hintText: 'Enter requirement title',
                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                        focusColor: kNeutralColor,
                        border: const OutlineInputBorder(),
                      ),
                      controller: titleController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter title';
                        }

                        return null;
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
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(7.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Choose a Category',
                            labelStyle: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(child: getCategories()),
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
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(7.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Choose a Material',
                            labelStyle: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(child: getMaterials()),
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
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(7.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Choose a Surface',
                            labelStyle: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(child: getSurfaces()),
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
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(7.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Pieces',
                            labelStyle: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(child: getPieces()),
                        );
                      },
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: selectedPieces,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Text(
                                  'Piece ${index + 1}: ',
                                  style: kTextStyle.copyWith(
                                    color: kSubTitleColor,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: kNeutralColor,
                                    textInputAction: TextInputAction.next,
                                    decoration: kInputDecoration.copyWith(
                                      labelText: 'Width',
                                      labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                      hintText: 'cm',
                                      hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                      focusColor: kNeutralColor,
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      try {
                                        setState(() {
                                          widths[index] = int.tryParse(value)!;
                                        });
                                      } catch (error) {
                                        setState(() {
                                          widths.add(int.tryParse(value)!);
                                        });
                                      }
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (!isFloatNumber(value, isRequired: true)) {
                                        return 'Please enter width\nNumber only';
                                      }

                                      if (int.tryParse(value!)! < 10) {
                                        return 'Minimum width is 10 cm';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    cursorColor: kNeutralColor,
                                    textInputAction: TextInputAction.next,
                                    decoration: kInputDecoration.copyWith(
                                      labelText: 'Length',
                                      labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                      hintText: 'cm',
                                      hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                      focusColor: kNeutralColor,
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      try {
                                        setState(() {
                                          lengths[index] = int.tryParse(value)!;
                                        });
                                      } catch (error) {
                                        setState(() {
                                          lengths.add(int.tryParse(value)!);
                                        });
                                      }
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (!isFloatNumber(value, isRequired: true)) {
                                        return 'Please enter length\nNumber only';
                                      }

                                      if (int.tryParse(value!)! < 10) {
                                        return 'Minimum length is 10 cm';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: kNeutralColor,
                      textInputAction: TextInputAction.next,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Number of drawings',
                        labelStyle: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'How many drawings do you need?',
                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                        focusColor: kNeutralColor,
                        border: const OutlineInputBorder(),
                      ),
                      controller: quantityController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        setState(() {
                          quantityController.text = value.trim();
                        });
                      },
                      validator: (value) {
                        if (!isNumber(value, isRequired: true)) {
                          return 'Please enter quantity\nNumber only';
                        }

                        if (int.parse(value!) < 1) {
                          return 'Minimum quantity is 1';
                        }

                        if (int.parse(value) > 3) {
                          return 'Maximum quantity is 3';
                        }

                        return null;
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
                        hintText: 'How much you can pay?',
                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                        focusColor: kNeutralColor,
                        border: const OutlineInputBorder(),
                      ),
                      controller: budgetController,
                      onChanged: (value) {
                        if (isCurrency(value, isRequired: true)) {
                          int budget = int.tryParse(value.replaceAll('.', ''))!;

                          if (budget >= 100000000) {
                            budget = 99999999;
                          }

                          String budgetString = budget.toString();
                          int count = 0;
                          String budgetWithDot = '';

                          for (int i = budgetString.length - 1; i > 0; i--) {
                            count++;

                            if (count == 3) {
                              count = 0;
                              budgetWithDot = '.${budgetString[i]}$budgetWithDot';
                            } else {
                              budgetWithDot = budgetString[i] + budgetWithDot;
                            }
                          }

                          budgetWithDot = budgetString[0] + budgetWithDot;

                          setState(() {
                            budgetController.text = budgetWithDot;
                            budgetController.moveCursorToEnd();
                          });
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (!isCurrency(value, isRequired: true)) {
                          return 'Please enter budget\nNumber only';
                        }

                        if (int.parse(value!.replaceAll('.', '')) < 100000) {
                          return 'Minimum budget is ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(100000)}';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      cursorColor: kNeutralColor,
                      textInputAction: TextInputAction.newline,
                      maxLength: 700,
                      maxLines: 3,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Describe',
                        labelStyle: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: 'I need an artist for...',
                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                        focusColor: kNeutralColor,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: const OutlineInputBorder(),
                      ),
                      controller: descriptionController,
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
                              borderSide: BorderSide(color: kBorderColorTextField, width: 2),
                            ),
                            contentPadding: const EdgeInsets.all(7.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Status',
                            labelStyle: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(child: getStatus()),
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () async {
                          await showImportPicturePopUp(context);

                          setState(() {
                            images = images;
                          });
                        },
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: kBorderColorTextField),
                          ),
                          child: images.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      IconlyBold.image,
                                      color: kLightNeutralColor,
                                      size: 50,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      ' Upload Image ',
                                      style: kTextStyle.copyWith(color: kSubTitleColor),
                                    ),
                                    const SizedBox(height: 10.0),
                                  ],
                                )
                              : FutureBuilder(
                                  future: images.last.readAsBytes(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Image.memory(
                                              snapshot.data!,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  images.clear();
                                                });
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.red[700],
                                                size: 27.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: kWhite),
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          child: ButtonGlobalWithoutIcon(
            buttontext: 'Create',
            buttonDecoration: kButtonDecoration.copyWith(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              onDone();
            },
            buttonTextColor: kWhite,
          ),
        ),
      ),
    );
  }

  void getData() async {
    var dataCategories = (await CategoryApi().gets(0)).value;
    var dataMaterials = (await MaterialApi().gets(0)).value;
    var dataSurfaces = (await SurfaceApi().gets(0)).value;

    dataCategories.sort((a, b) => a.name!.compareTo(b.name!));
    dataMaterials.sort((a, b) => a.name!.compareTo(b.name!));
    dataSurfaces.sort((a, b) => a.name!.compareTo(b.name!));

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

  void onDone() async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      ProgressDialogUtils.showProgress(context);

      String? image;

      if (images.isNotEmpty) {
        image = await uploadImage(images.last);
        images.clear();
      }

      var accountId = Guid(jsonDecode(PrefUtils().getAccount())['Id']);

      var requirement = Requirement(
        id: Guid.newGuid,
        title: titleController.text,
        description: descriptionController.text,
        image: image,
        quantity: int.parse(quantityController.text),
        pieces: selectedPieces,
        budget: double.tryParse(budgetController.text.replaceAll('.', '')),
        createdDate: DateTime.now(),
        status: selectedStatus,
        categoryId: selectedCategory,
        materialId: selectedMaterial,
        surfaceId: selectedSurface,
        createdBy: accountId,
      );

      await RequirementApi().postOne(requirement);

      for (int i = 0; i < selectedPieces; i++) {
        var size = Size(
          id: Guid.newGuid,
          width: widths[i],
          length: lengths[i],
          height: 1,
          weight: 1000,
          requirementId: requirement.id,
        );

        await SizeApi().postOne(size);
      }

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      // ignore: use_build_context_synchronously
      context.pop();

      // update last screen
      JobPost.refresh();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: errorSomethingWentWrong);
    }
  }
}
