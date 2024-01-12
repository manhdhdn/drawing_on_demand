// import 'package:country_code_picker/country_code_picker.dart';
import 'dart:convert';

import 'package:drawing_on_demand/data/apis/account_api.dart';
import 'package:drawing_on_demand/data/models/certificate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../core/utils/pref_utils.dart';
import '../../../core/utils/progress_dialog_utils.dart';
import '../../../data/apis/account_role_api.dart';
import '../../../data/apis/api_config.dart';
import '../../../data/apis/certificate_api.dart';
import '../../../data/apis/ghn_api.dart';
import '../../../data/apis/rank_api.dart';
import '../../../data/apis/role_api.dart';
import '../../../data/models/account.dart';
import '../../../data/models/account_role.dart';
import '../../../data/models/ghn_request.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../common/popUp/popup_1.dart';

class SellerCreateProfile extends StatefulWidget {
  const SellerCreateProfile({Key? key}) : super(key: key);

  @override
  State<SellerCreateProfile> createState() => _SellerCreateProfileState();
}

class _SellerCreateProfileState extends State<SellerCreateProfile> {
  final _formKey = GlobalKey<FormState>();

  PageController pageController = PageController(initialPage: 0);

  TextEditingController addressController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  int currentIndexPage = 0;
  double percent = 33.3;

  bool isCheck = true;

  XFile? avatar;

  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> wards = [];

  Map<String, dynamic>? selectedProvince;
  Map<String, dynamic>? previousSelectedDistrict;
  Map<String, dynamic>? selectedDistrict;
  Map<String, dynamic>? previousSelectedWard;
  Map<String, dynamic>? selectedWard;

  List<String> educationNames = [];
  List<String> educationDescriptions = [];
  List<XFile> educationImages = [];

  List<String> certificateNames = [];
  List<String> certificateDescriptions = [];
  List<XFile> certificateImages = [];

  DropdownButton<Map<String, dynamic>> getProvinces() {
    List<DropdownMenuItem<Map<String, dynamic>>> dropDownItems = [];

    for (Map<String, dynamic> des in provinces) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des['ProvinceName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedProvince,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) async {
        if (isCheck) {
          await getDistrict(value!['ProvinceID'] as int);

          setState(() {
            selectedProvince = value;
          });
        }
      },
    );
  }

  DropdownButton<Map<String, dynamic>> getDistricts() {
    List<DropdownMenuItem<Map<String, dynamic>>> dropDownItems = [];

    for (Map<String, dynamic> des in districts) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des['DistrictName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedDistrict,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) async {
        if (isCheck) {
          await getWard(value!['DistrictID'] as int);

          setState(() {
            previousSelectedDistrict = selectedDistrict;
            selectedDistrict = value;
          });
        }
      },
    );
  }

  DropdownButton<Map<String, dynamic>> getWards() {
    List<DropdownMenuItem<Map<String, dynamic>>> dropDownItems = [];

    for (Map<String, dynamic> des in wards) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des['WardName']),
      );
      dropDownItems.add(item);
    }

    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedWard,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        if (isCheck) {
          setState(() {
            previousSelectedWard = selectedWard;
            selectedWard = value!;
          });
        }
      },
    );
  }

  DropdownButton<String> getGender() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in gender) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedGender,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedGender = value!;
        });
      },
    );
  }

  Future<void> showImportProfilePopUp() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const ImportImagePopUp(),
            );
          },
        );
      },
    );
  }

  void saveProfilePopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const SaveProfilePopUp(),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    images.clear();
    getProvince();
  }

  @override
  void dispose() {
    _formKey.currentState!.dispose();
    pageController.dispose();

    PrefUtils().clearSignUpInfor();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kNeutralColor),
        backgroundColor: kDarkWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          'Setup Profile',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: ButtonGlobalWithoutIcon(
                buttontext: 'Back',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: currentIndexPage == 0 ? kLightNeutralColor : kWhite,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: currentIndexPage == 0 ? kLightNeutralColor : kPrimaryColor),
                ),
                onPressed: () {
                  currentIndexPage > 0
                      ? pageController.previousPage(
                          duration: const Duration(microseconds: 3000),
                          curve: Curves.bounceInOut,
                        )
                      : null;
                },
                buttonTextColor: currentIndexPage == 0 ? kWhite : kPrimaryColor,
              ),
            ),
            Expanded(
              child: ButtonGlobalWithoutIcon(
                buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Profile',
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
                      : onSave();
                },
                buttonTextColor: kWhite,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (int index) => setState(
            () => currentIndexPage = index,
          ),
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Your Photo',
                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                child: avatar == null
                                    ? const Icon(
                                        IconlyBold.profile,
                                        color: kBorderColorTextField,
                                        size: 68,
                                      )
                                    : FutureBuilder(
                                        future: avatar!.readAsBytes(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: Image.memory(
                                                snapshot.data!,
                                                fit: BoxFit.cover,
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
                              GestureDetector(
                                onTap: () async {
                                  await showImportProfilePopUp();

                                  setState(() {
                                    if (images.isNotEmpty) {
                                      avatar = images.first;
                                      images.clear();
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: kPrimaryColor),
                                  ),
                                  child: const Icon(
                                    IconlyBold.camera,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
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
                                labelText: 'Choose a Province',
                                labelStyle: kTextStyle.copyWith(
                                  color: kNeutralColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: getProvinces(),
                              ),
                            );
                          },
                          validator: (value) {
                            if (selectedProvince == null) {
                              return 'Please choose a province';
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
                                labelText: 'Choose a District',
                                labelStyle: kTextStyle.copyWith(
                                  color: kNeutralColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: getDistricts(),
                              ),
                            );
                          },
                          validator: (value) {
                            if (selectedDistrict == null) {
                              return 'Please choose a district';
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
                                labelText: 'Choose a Ward',
                                labelStyle: kTextStyle.copyWith(
                                  color: kNeutralColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: getWards(),
                              ),
                            );
                          },
                          validator: (value) {
                            if (selectedWard == null) {
                              return 'Please choose a ward';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Street Address',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter street address',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          controller: addressController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter street address';
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
                                labelText: 'Select Gender',
                                labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                              ),
                              child: DropdownButtonHideUnderline(child: getGender()),
                            );
                          },
                        ),
                      ],
                    ).visible(currentIndexPage == 0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Education',
                              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  educationNames.add('');
                                  educationDescriptions.add('');
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'Add Education',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: educationNames.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const SizedBox(height: 20.0),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: kWhite,
                                    border: Border.all(color: kBorderColorTextField),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: context.width() * 0.7,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              cursorColor: kNeutralColor,
                                              textInputAction: TextInputAction.next,
                                              decoration: kInputDecoration.copyWith(
                                                labelText: 'School name',
                                                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                                hintText: 'Enter school name',
                                                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                focusColor: kNeutralColor,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                border: const OutlineInputBorder(),
                                              ),
                                              initialValue: educationNames.length > index ? educationNames[index] : '',
                                              onChanged: (value) {
                                                setState(() {
                                                  try {
                                                    educationNames[index] = value;
                                                  } catch (error) {
                                                    educationNames.add(value);
                                                  }
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter school name';
                                                }

                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: context.width() * 0.7,
                                            child: TextFormField(
                                              keyboardType: TextInputType.multiline,
                                              cursorColor: kNeutralColor,
                                              textInputAction: TextInputAction.newline,
                                              maxLength: 300,
                                              maxLines: 3,
                                              decoration: kInputDecoration.copyWith(
                                                labelText: 'Description',
                                                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                                hintText: 'Enter description',
                                                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                focusColor: kNeutralColor,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                border: const OutlineInputBorder(),
                                              ),
                                              initialValue: educationDescriptions.length > index ? educationDescriptions[index] : '',
                                              onChanged: (value) {
                                                setState(() {
                                                  try {
                                                    educationDescriptions[index] = value;
                                                  } catch (error) {
                                                    educationDescriptions.add(value);
                                                  }
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter description';
                                                }

                                                return null;
                                              },
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                educationNames.removeAt(index);
                                                educationDescriptions.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(
                                              IconlyBold.delete,
                                              color: kLightNeutralColor,
                                              size: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          children: [
                            Text(
                              'Certification',
                              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  certificateNames.add('');
                                  certificateDescriptions.add('');
                                  certificateImages.add(XFile(''));
                                });
                              },
                              child: Row(
                                children: [
                                  const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'Add Certification',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: certificateNames.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const SizedBox(height: 20.0),
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: kWhite,
                                    border: Border.all(color: kBorderColorTextField),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: context.width() * 0.7,
                                            child: TextFormField(
                                              keyboardType: TextInputType.text,
                                              cursorColor: kNeutralColor,
                                              textInputAction: TextInputAction.next,
                                              decoration: kInputDecoration.copyWith(
                                                labelText: 'Certification name',
                                                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                                hintText: 'Enter certification name',
                                                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                focusColor: kNeutralColor,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                border: const OutlineInputBorder(),
                                              ),
                                              initialValue: certificateNames.length > index ? certificateNames[index] : '',
                                              onChanged: (value) {
                                                setState(() {
                                                  try {
                                                    certificateNames[index] = value;
                                                  } catch (error) {
                                                    certificateNames.add(value);
                                                  }
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter certification name';
                                                }

                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: context.width() * 0.7,
                                            child: TextFormField(
                                              keyboardType: TextInputType.multiline,
                                              cursorColor: kNeutralColor,
                                              textInputAction: TextInputAction.newline,
                                              maxLength: 300,
                                              maxLines: 3,
                                              decoration: kInputDecoration.copyWith(
                                                labelText: 'Description',
                                                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                                                hintText: 'Enter description',
                                                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                focusColor: kNeutralColor,
                                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                                border: const OutlineInputBorder(),
                                              ),
                                              initialValue: certificateDescriptions.length > index ? certificateDescriptions[index] : '',
                                              onChanged: (value) {
                                                setState(() {
                                                  try {
                                                    certificateDescriptions[index] = value;
                                                  } catch (error) {
                                                    certificateDescriptions.add(value);
                                                  }
                                                });
                                              },
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter description';
                                                }

                                                return null;
                                              },
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                certificateNames.removeAt(index);
                                                certificateDescriptions.removeAt(index);
                                                certificateImages.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(
                                              IconlyBold.delete,
                                              color: kLightNeutralColor,
                                              size: 18.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      GestureDetector(
                                        onTap: () async {
                                          await showImportPicturePopUp(context);

                                          if (images.isNotEmpty) {
                                            setState(() {
                                              try {
                                                certificateImages[index] = images.first;
                                              } catch (error) {
                                                certificateImages.add(images.first);
                                              }
                                            });

                                            images.clear();
                                          }
                                        },
                                        child: Container(
                                          constraints: const BoxConstraints(maxWidth: 200),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(color: kBorderColorTextField),
                                          ),
                                          child: certificateImages.length <= index || certificateImages[index].path.isEmpty
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
                                                  future: certificateImages[index].readAsBytes(),
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
                                                                  certificateImages.removeAt(index);
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
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ).visible(currentIndexPage == 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About you',
                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLength: 300,
                          maxLines: 8,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.newline,
                          decoration: kInputDecoration.copyWith(
                            hintText: 'Write a brief description about you..',
                            hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          controller: bioController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please write a bio';
                            }

                            return null;
                          },
                        ),
                      ],
                    ).visible(currentIndexPage == 2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getProvince() async {
    var request = GHNRequest(endpoint: ApiConfig.GHNPaths['province']);
    var respone = await GHNApi().postOne(request);

    setState(() {
      provinces = List<Map<String, dynamic>>.from(jsonDecode(respone.postJsonString!)['data']);

      provinces.sort(((a, b) => a['ProvinceName'].compareTo(b['ProvinceName'])));

      Map<String, dynamic> result = {};
      double matchPoint = 0;

      for (var province in provinces) {
        var nameExs = [];

        if (province.containsKey('NameExtension')) {
          nameExs = List<String>.from(province['NameExtension']);
        }

        for (var nameEx in nameExs) {
          double point = getMatchPoint(addressController.text.trim().split(',').last, nameEx);

          if (matchPoint < point) {
            matchPoint = point;
            result = province;
          }
        }
      }

      if (result.isNotEmpty) {
        getDistrict(result['ProvinceID']).then(
          (value) => setState(() {
            selectedProvince = result['ProvinceID'];
          }),
        );
      }
    });
  }

  Future<void> getDistrict(int provinceId) async {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['district'],
      postJsonString: jsonEncode(
        {'province_id': provinceId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    setState(() {
      previousSelectedDistrict = selectedDistrict;
      selectedDistrict = null;
      previousSelectedWard = selectedWard;
      selectedWard = null;

      districts = List<Map<String, dynamic>>.from(jsonDecode(respone.postJsonString!)['data']);
      wards = [];

      Map<String, dynamic> result = {};
      double matchPoint = 0;

      for (var district in districts) {
        var nameExs = [];

        if (district.containsKey('NameExtension')) {
          nameExs = List<String>.from(district['NameExtension']);
        }

        for (var nameEx in nameExs) {
          double point = getMatchPoint(addressController.text.trim(), nameEx);

          if (matchPoint < point) {
            matchPoint = point;
            result = district;
          }
        }
      }

      if (result.isNotEmpty) {
        getWard(result['DistrictID']).then(
          (value) => setState(() {
            selectedDistrict = result['DistrictID'];
          }),
        );
      }
    });
  }

  Future<void> getWard(int districtId) async {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['ward'],
      postJsonString: jsonEncode(
        {'district_id': districtId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    setState(() {
      previousSelectedWard = selectedWard;
      selectedWard = null;

      wards = List<Map<String, dynamic>>.from(jsonDecode(respone.postJsonString!)['data']);

      Map<String, dynamic> result = {};
      double matchPoint = 0;

      for (var ward in wards) {
        var nameExs = [];

        if (ward.containsKey('NameExtension')) {
          nameExs = List<String>.from(ward['NameExtension']);
        }

        for (var nameEx in nameExs) {
          double point = getMatchPoint(addressController.text.trim(), nameEx);

          if (matchPoint < point) {
            matchPoint = point;
            result = ward;
          }
        }
      }

      if (result.isNotEmpty) {
        selectedWard = result['WardCode'];
      }
    });
  }

  void onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (certificateNames.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add at least one certification');
      return;
    } else {
      if (certificateImages.any((image) => image.path.isEmpty)) {
        Fluttertoast.showToast(msg: 'Please complete all certification information');
        return;
      }
    }

    try {
      ProgressDialogUtils.showProgress(context);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: PrefUtils().getSignUpInfor()['Email'],
        password: PrefUtils().getSignUpInfor()['Password'],
      );

      String? image;

      if (avatar != null) {
        image = await uploadImage(avatar!);
      }

      List<String> address = [
        addressController.text.trim(),
        selectedWard!['WardName'],
        selectedDistrict!['DistrictName'],
        selectedProvince!['ProvinceName'],
      ];

      var rank = (await RankApi().gets(0, orderBy: 'connect')).value.first;

      var account = Account(
        id: Guid.newGuid,
        email: PrefUtils().getSignUpInfor()['Email'],
        phone: PrefUtils().getSignUpInfor()['Phone'],
        name: PrefUtils().getSignUpInfor()['Name'],
        gender: selectedGender,
        avatar: image,
        address: address.join(', '),
        bio: bioController.text.trim(),
        availableConnect: rank.connect,
        createdDate: DateTime.now(),
        status: 'Pending',
        rankId: rank.id,
      );

      var roles = (await RoleApi().gets(0, filter: 'name eq \'Artist\' or name eq \'Customer\'', orderBy: 'name')).value;

      List<Certificate> certificates = [];

      for (var i = 0; i < educationNames.length; i++) {
        certificates.add(Certificate(
          id: Guid.newGuid,
          name: 'Education|${educationNames[i]}',
          image: 'https://firebasestorage.googleapis.com/v0/b/drawing-on-demand.appspot.com/o/images%2Fog-image.webp?alt=media&token=07973317-de31-470f-bde1-4d285d416222',
          achievedDate: account.createdDate,
          description: educationDescriptions[i],
          accountId: account.id,
        ));
      }

      for (var i = 0; i < certificateNames.length; i++) {
        var image = await uploadImage(certificateImages[i]);

        certificates.add(Certificate(
          id: Guid.newGuid,
          name: certificateNames[i],
          image: image,
          achievedDate: account.createdDate,
          description: certificateDescriptions[i],
          accountId: account.id,
        ));
      }

      var accountRoles = [
        AccountRole(
          id: Guid.newGuid,
          addedDate: account.createdDate,
          status: 'Active',
          accountId: account.id,
          roleId: roles.last.id,
        ),
        AccountRole(
          id: Guid.newGuid,
          addedDate: account.createdDate,
          status: 'Pending',
          accountId: account.id,
          roleId: roles.first.id,
        ),
      ];

      await AccountApi().postOne(account);

      for (var certificate in certificates) {
        await CertificateApi().postOne(certificate);
      }

      for (var accountRole in accountRoles) {
        await AccountRoleApi().postOne(accountRole);
      }

      FirebaseAuth.instance.sendSignInLinkToEmail(
        email: PrefUtils().getSignUpInfor()['Email']!,
        actionCodeSettings: ActionCodeSettings(
          url: '${ApiConfig.paymentUrl}${LoginRoute.tag}',
          handleCodeInApp: true,
        ),
      );

      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);

      saveProfilePopUp();
    } catch (error) {
      // ignore: use_build_context_synchronously
      ProgressDialogUtils.hideProgress(context);
      Fluttertoast.showToast(msg: 'Create profile failed');
    }
  }
}
