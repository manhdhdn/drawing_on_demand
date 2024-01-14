import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../core/utils/validation_function.dart';
import '../../../data/apis/art_api.dart';
import '../../../data/apis/artwork_api.dart';
import '../../../data/apis/category_api.dart';
import '../../../data/apis/material_api.dart';
import '../../../data/apis/size_api.dart';
import '../../../data/apis/surface_api.dart';
import '../../../data/models/art.dart';
import '../../../data/models/artwork.dart';
import '../../../data/models/category.dart';
import '../../../data/models/material.dart' as material_model;
import '../../../data/models/size.dart';
import '../../../data/models/surface.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import 'create_service.dart';

class CreateNewService extends StatefulWidget {
  const CreateNewService({Key? key}) : super(key: key);

  @override
  State<CreateNewService> createState() => _CreateNewServiceState();
}

class _CreateNewServiceState extends State<CreateNewService> {
  final _formKey = GlobalKey<FormState>();

  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 33.3;

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
  List<int> weights = [];
  List<int> heights = [];

  List<XFile> arts = [];

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

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getData();
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
          'Create New Artwork',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (int index) => setState(() => currentIndexPage = index),
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentIndexPage == 0
                                ? 'Step 1 of 3'
                                : currentIndexPage == 1
                                    ? 'Step 2 of 3'
                                    : 'Step 3 of 3',
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: StepProgressIndicator(
                              totalSteps: 3,
                              currentStep: currentIndexPage + 1,
                              size: 8,
                              padding: 0,
                              selectedColor: kPrimaryColor,
                              unselectedColor: kPrimaryColor.withOpacity(0.2),
                              roundedEdges: const Radius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      Column(
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
                          TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: kNeutralColor,
                            textInputAction: TextInputAction.next,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'In Stock',
                              labelStyle: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                              ),
                              hintText: 'Enter quantity',
                              hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                              focusColor: kNeutralColor,
                              border: const OutlineInputBorder(),
                            ),
                            controller: quantityController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (!isNumber(value, isRequired: true)) {
                                return 'Please enter quantity (number only)';
                              }

                              if (int.parse(value!) < 1) {
                                return 'Minimum quantity is 1';
                              }

                              if (int.parse(value) > 1000) {
                                return 'Maximum quantity is 1000';
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
                              labelText: 'Price',
                              labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                              hintText: 'Enter price',
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
                                return 'Please enter price (number only)';
                              }

                              if (int.parse(value!.replaceAll('.', '')) < 50000) {
                                return 'Minimum price is ${NumberFormat.simpleCurrency(locale: 'vi_VN').format(50000)}';
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
                              hintText: 'Enter a describe for your artwork',
                              hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                              focusColor: kNeutralColor,
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: const OutlineInputBorder(),
                            ),
                            controller: descriptionController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter description';
                              }

                              return null;
                            },
                          ),
                        ],
                      ).visible(currentIndexPage == 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Text(
                            'Delivery Package',
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                        '${index + 1}: ',
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
                                          initialValue: widths.length > index ? widths[index].toString() : null,
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
                                          initialValue: lengths.length > index ? lengths[index].toString() : null,
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
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      Text(
                                        '${index + 1}: ',
                                        style: kTextStyle.copyWith(
                                          color: kWhite,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          cursorColor: kNeutralColor,
                                          textInputAction: TextInputAction.next,
                                          decoration: kInputDecoration.copyWith(
                                            labelText: 'Weight',
                                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                            hintText: 'g',
                                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                            focusColor: kNeutralColor,
                                            border: const OutlineInputBorder(),
                                          ),
                                          initialValue: weights.length > index ? weights[index].toString() : null,
                                          onChanged: (value) {
                                            try {
                                              setState(() {
                                                weights[index] = int.tryParse(value)!;
                                              });
                                            } catch (error) {
                                              setState(() {
                                                weights.add(int.tryParse(value)!);
                                              });
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (!isFloatNumber(value, isRequired: true)) {
                                              return 'Please enter weight\nNumber only';
                                            }

                                            if (int.tryParse(value!)! < 100) {
                                              return 'Minimum weight is 100g';
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
                                            labelText: 'Height',
                                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                            hintText: 'cm',
                                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                            focusColor: kNeutralColor,
                                            border: const OutlineInputBorder(),
                                          ),
                                          initialValue: heights.length > index ? heights[index].toString() : null,
                                          onChanged: (value) {
                                            try {
                                              setState(() {
                                                heights[index] = int.tryParse(value)!;
                                              });
                                            } catch (error) {
                                              setState(() {
                                                heights.add(int.tryParse(value)!);
                                              });
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          validator: (value) {
                                            if (!isFloatNumber(value, isRequired: true)) {
                                              return 'Please enter height\nNumber only';
                                            }

                                            if (int.tryParse(value!)! < 1) {
                                              return 'Minimum height is 1 cm';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: kLightNeutralColor),
                                ],
                              );
                            },
                          ),
                        ],
                      ).visible(currentIndexPage == 1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Text(
                            'Image (Up to 3)',
                            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15.0),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 3,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await showImportPicturePopUp(context);

                                    setState(() {
                                      arts.addAll(images);

                                      while (arts.length > 3) {
                                        arts.removeLast();
                                      }
                                    });

                                    images.clear();
                                  },
                                  child: Container(
                                    width: context.width(),
                                    constraints: const BoxConstraints(minHeight: 130),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: kBorderColorTextField),
                                    ),
                                    child: arts.length <= i
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
                                            future: arts[i].readAsBytes(),
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
                                                            arts.removeAt(i);
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
                              );
                            },
                          ),
                        ],
                      ).visible(currentIndexPage == 2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ButtonGlobalWithoutIcon(
                buttontext: 'Back',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: currentIndexPage > 0 ? kWhite : kLightNeutralColor,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: currentIndexPage > 0 ? kPrimaryColor : kLightNeutralColor),
                ),
                onPressed: () {
                  currentIndexPage > 0
                      ? pageController.previousPage(
                          duration: const Duration(microseconds: 3000),
                          curve: Curves.bounceInOut,
                        )
                      : null;
                },
                buttonTextColor: currentIndexPage > 0 ? kPrimaryColor : kWhite,
              ),
            ),
            Expanded(
              child: ButtonGlobalWithoutIcon(
                buttontext: currentIndexPage < 2 ? 'Next' : 'Create',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  currentIndexPage < 2
                      ? _formKey.currentState!.validate()
                          ? pageController.nextPage(
                              duration: const Duration(microseconds: 3000),
                              curve: Curves.bounceInOut,
                            )
                          : null
                      : onDone();
                },
                buttonTextColor: kWhite,
              ),
            ),
          ],
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (arts.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add at least one image');
    }

    try {
      ProgressDialogUtils.showProgress(context);

      var artwork = Artwork(
        id: Guid.newGuid,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: budgetController.text.replaceAll('.', '').toDouble(),
        pieces: selectedPieces,
        inStock: quantityController.text.toInt(),
        createdDate: DateTime.now(),
        status: 'Available',
        categoryId: selectedCategory,
        materialId: selectedMaterial,
        surfaceId: selectedSurface,
        createdBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
      );

      List<Art> images = [];

      for (var art in arts) {
        var image = await uploadImage(art);

        images.add(
          Art(
            id: Guid.newGuid,
            image: image,
            createdDate: artwork.createdDate,
            artworkId: artwork.id,
          ),
        );
      }

      List<Size> sizes = [];

      for (var i = 0; i < selectedPieces; i++) {
        sizes.add(
          Size(
            id: Guid.newGuid,
            width: widths[i],
            length: lengths[i],
            height: heights[i],
            weight: weights[i],
            artworkId: artwork.id,
          ),
        );
      }

      await ArtworkApi().postOne(artwork);

      for (var image in images) {
        await ArtApi().postOne(image);
      }

      for (var size in sizes) {
        await SizeApi().postOne(size);
      }

      CreateService.refresh();

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      // ignore: use_build_context_synchronously
      GoRouter.of(context).pop();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: 'Create service failed');
    }
  }
}
