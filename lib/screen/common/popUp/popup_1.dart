import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../app_routes/named_routes.dart';
import '../../../core/common/common_features.dart';
import '../../../data/apis/order_api.dart';
import '../../seller_screen/profile/seller_profile.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import '../authentication/opt_verification.dart';

class SellerAddLanguagePopUp extends StatefulWidget {
  const SellerAddLanguagePopUp({Key? key}) : super(key: key);

  @override
  State<SellerAddLanguagePopUp> createState() => _SellerAddLanguagePopUpState();
}

class _SellerAddLanguagePopUpState extends State<SellerAddLanguagePopUp> {
  //__________language level___________________________________________________
  DropdownButton<String> getLevel() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in languageLevel) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedLanguageLevel,
      style: kTextStyle.copyWith(color: kLightNeutralColor),
      onChanged: (value) {
        setState(() {
          selectedLanguageLevel = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add Languages',
                  style: kTextStyle.copyWith(color: kNeutralColor),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.name,
              cursorColor: kNeutralColor,
              textInputAction: TextInputAction.next,
              decoration: kInputDecoration.copyWith(
                labelText: 'Language',
                labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                hintText: 'Enter language ',
                hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                focusColor: kNeutralColor,
                border: const OutlineInputBorder(),
              ),
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
                    labelText: 'Language Level',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  child: DropdownButtonHideUnderline(child: getLevel()),
                );
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: Colors.red,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Add',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SellerAddSkillPopUp extends StatefulWidget {
  const SellerAddSkillPopUp({Key? key}) : super(key: key);

  @override
  State<SellerAddSkillPopUp> createState() => _SellerAddSkillPopUpState();
}

class _SellerAddSkillPopUpState extends State<SellerAddSkillPopUp> {
  DropdownButton<String> getLevel() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in skillLevel) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedSkillLevel,
      style: kTextStyle.copyWith(color: kLightNeutralColor),
      onChanged: (value) {
        setState(() {
          selectedSkillLevel = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add Skills',
                  style: kTextStyle.copyWith(color: kNeutralColor),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.name,
              cursorColor: kNeutralColor,
              textInputAction: TextInputAction.next,
              decoration: kInputDecoration.copyWith(
                labelText: 'Skill',
                labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                hintText: 'Enter skill ',
                hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                focusColor: kNeutralColor,
                border: const OutlineInputBorder(),
              ),
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
                    labelText: 'Skill Level',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  child: DropdownButtonHideUnderline(child: getLevel()),
                );
              },
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: Colors.red,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Add',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ImportImagePopUp extends StatefulWidget {
  const ImportImagePopUp({Key? key}) : super(key: key);

  @override
  State<ImportImagePopUp> createState() => _ImportImagePopUpState();
}

class _ImportImagePopUpState extends State<ImportImagePopUp> {
  String choosedType = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Select Image',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    onGallery();
                  },
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.images,
                        color: choosedType == 'gallery' ? kPrimaryColor : kLightNeutralColor,
                        size: 40,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Photo Gallery',
                        style: kTextStyle.copyWith(color: kLightNeutralColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    onCamera();
                  },
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.camera,
                        color: choosedType == 'camera' ? kPrimaryColor : kLightNeutralColor,
                        size: 40,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Take Photo',
                        style: kTextStyle.copyWith(color: kLightNeutralColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void onGallery() async {
    setState(() {
      choosedType = 'gallery';
    });

    await pickMultipleImages();

    // ignore: use_build_context_synchronously
    GoRouter.of(context).pop();
  }

  void onCamera() async {
    setState(() {
      choosedType = 'camera';
    });

    await openCamera();

    // ignore: use_build_context_synchronously
    GoRouter.of(context).pop();
  }
}

class SaveProfilePopUp extends StatefulWidget {
  const SaveProfilePopUp({Key? key}) : super(key: key);

  @override
  State<SaveProfilePopUp> createState() => _SaveProfilePopUpState();
}

class _SaveProfilePopUpState extends State<SaveProfilePopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 186,
              width: 209,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: AssetImage('images/success.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              'Congratulations!',
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Your profile is successfully completed\nVerify your email address to get started.',
              style: kTextStyle.copyWith(color: kLightNeutralColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Button(
              containerBg: kPrimaryColor,
              borderColor: Colors.transparent,
              buttonText: 'Done',
              textColor: kWhite,
              onPressed: () {
                setState(() {
                  finish(context);
                  context.goNamed(LoginRoute.name);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class BlockingReasonPopUp extends StatefulWidget {
  const BlockingReasonPopUp({Key? key}) : super(key: key);

  @override
  State<BlockingReasonPopUp> createState() => _BlockingReasonPopUpState();
}

class _BlockingReasonPopUpState extends State<BlockingReasonPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Block on Messanger',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              'If you’re friend, the conversation will stay in chats unless you hide it.',
              style: kTextStyle.copyWith(color: kSubTitleColor),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: Colors.red,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Block',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ImportDocumentPopUp extends StatefulWidget {
  const ImportDocumentPopUp({Key? key}) : super(key: key);

  @override
  State<ImportDocumentPopUp> createState() => _ImportDocumentPopUpState();
}

class _ImportDocumentPopUpState extends State<ImportDocumentPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Choose your Need',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(
                      FontAwesomeIcons.images,
                      color: kPrimaryColor,
                      size: 40,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Photo Gallery',
                      style: kTextStyle.copyWith(color: kPrimaryColor),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    const Icon(
                      IconlyBold.document,
                      color: kLightNeutralColor,
                      size: 40,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Open File',
                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class AddFAQPopUp extends StatefulWidget {
  const AddFAQPopUp({Key? key}) : super(key: key);

  @override
  State<AddFAQPopUp> createState() => _AddFAQPopUpState();
}

class _AddFAQPopUpState extends State<AddFAQPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add FAQ',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              cursorColor: kNeutralColor,
              textInputAction: TextInputAction.next,
              decoration: kInputDecoration.copyWith(
                labelText: 'Add Question',
                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                hintText: 'What software is used to create the design?',
                hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                focusColor: kNeutralColor,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              cursorColor: kNeutralColor,
              decoration: kInputDecoration.copyWith(
                labelText: 'Add Answer',
                labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                hintText: 'I can use Figma , Adobe XD or Framer , whatever app your comfortable working with',
                hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                focusColor: kNeutralColor,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: Colors.red,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Add',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CancelReasonPopUp extends StatefulWidget {
  final String? id;
  final String? accountId;

  const CancelReasonPopUp({Key? key, this.id, this.accountId}) : super(key: key);

  @override
  State<CancelReasonPopUp> createState() => _CancelReasonPopUpState();
}

class _CancelReasonPopUpState extends State<CancelReasonPopUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController reasonController = TextEditingController();

  @override
  void dispose() {
    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Why are you Cancel Order?',
                    style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => finish(context),
                    child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
                color: kBorderColorTextField,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                cursorColor: kNeutralColor,
                textInputAction: TextInputAction.next,
                maxLength: 300,
                decoration: kInputDecoration.copyWith(
                  labelText: 'Enter Reason',
                  labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                  hintText: 'Describe why you want to cancel the order',
                  hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusColor: kNeutralColor,
                  border: const OutlineInputBorder(),
                ),
                controller: reasonController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a reason';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Button(
                      containerBg: kWhite,
                      borderColor: Colors.red,
                      buttonText: 'Cancel',
                      textColor: Colors.red,
                      onPressed: () {
                        finish(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Button(
                      containerBg: kPrimaryColor,
                      borderColor: Colors.transparent,
                      buttonText: 'Submit',
                      textColor: kWhite,
                      onPressed: () {
                        onCancelOrder();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onCancelOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // AccountReview accountReview = AccountReview(
      //   id: Guid.newGuid,
      //   star: 0,
      //   comment: reasonController.text.trim(),
      //   createdDate: DateTime.now(),
      //   status: 'Cancelled',
      //   createdBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
      //   accountId: Guid(widget.accountId),
      // );

      // await AccountReviewApi().postOne(accountReview);

      await OrderApi().patchOne(widget.id!, {
        'Status': 'Cancelled',
      });

      // ignore: use_build_context_synchronously
      finish(context);

      setState(() {
        selectedOrderTab = 'Cancelled';
      });

      // ignore: use_build_context_synchronously
      context.goNamed(OrderRoute.name);
    } catch (error) {
      Fluttertoast.showToast(msg: 'Cancel order failed');
    }
  }
}

class OrderCompletePopUp extends StatefulWidget {
  const OrderCompletePopUp({Key? key}) : super(key: key);

  @override
  State<OrderCompletePopUp> createState() => _OrderCompletePopUpState();
}

class _OrderCompletePopUpState extends State<OrderCompletePopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'Order Completed',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Your order has been completed.\nDate Thursday 27 Jun 2023',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Your Earned \$5.00',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                setState(
                  () {
                    finish(context);
                  },
                );
              },
              child: Container(
                height: 40,
                width: 135,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kPrimaryColor),
                child: Center(
                  child: Text(
                    'Got it!',
                    style: kTextStyle.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewSubmittedPopUp extends StatefulWidget {
  const ReviewSubmittedPopUp({Key? key}) : super(key: key);

  @override
  State<ReviewSubmittedPopUp> createState() => _ReviewSubmittedPopUpState();
}

class _ReviewSubmittedPopUpState extends State<ReviewSubmittedPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Successfully',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Thank you so much, you\'ve just publish your review',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(color: kLightNeutralColor),
            ),
            const SizedBox(height: 20.0),
            ButtonGlobalWithoutIcon(
                buttontext: 'Got it!',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  onFinish();
                },
                buttonTextColor: kWhite),
          ],
        ),
      ),
    );
  }

  void onFinish() {
    finish(context);

    context.goNamed(OrderRoute.name);
  }
}

class FavouriteWarningPopUp extends StatefulWidget {
  const FavouriteWarningPopUp({Key? key}) : super(key: key);

  @override
  State<FavouriteWarningPopUp> createState() => _FavouriteWarningPopUpState();
}

class _FavouriteWarningPopUpState extends State<FavouriteWarningPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 103,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                image: const DecorationImage(image: AssetImage('images/shot1.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Are You Sure!',
              style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                'Do you really want to remove this from your favourite list',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: Colors.red,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Add',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyPopUp extends StatefulWidget {
  const VerifyPopUp({Key? key}) : super(key: key);

  @override
  State<VerifyPopUp> createState() => _VerifyPopUpState();
}

class _VerifyPopUpState extends State<VerifyPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Let’s Verify It’s You',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Text(
              'You are trying to add a new withdrawal method. check a verification method so we can make sure it’s you.',
              style: kTextStyle.copyWith(color: kSubTitleColor),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Button(
                containerBg: kPrimaryColor,
                borderColor: Colors.transparent,
                buttonText: 'Got It!',
                textColor: kWhite,
                onPressed: () {
                  finish(context);
                  const OtpVerification().launch(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WithdrawAmountPopUp extends StatefulWidget {
  const WithdrawAmountPopUp({Key? key}) : super(key: key);

  @override
  State<WithdrawAmountPopUp> createState() => _WithdrawAmountPopUpState();
}

class _WithdrawAmountPopUpState extends State<WithdrawAmountPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Withdraw Amount',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 2.0),
            Text(
              'Review your withdrawal details',
              style: kTextStyle.copyWith(color: kSubTitleColor),
            ),
            const SizedBox(height: 5.0),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  'Transfer To',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  'PayPal',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Account',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  'ibne*****@gmail.com',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Amount',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  '$currencySign 5,000',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: redColor,
                    buttonText: 'Cancel',
                    textColor: redColor,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Confirm',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                      const SellerProfile().launch(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WithdrawHistoryPopUp extends StatefulWidget {
  const WithdrawHistoryPopUp({Key? key}) : super(key: key);

  @override
  State<WithdrawHistoryPopUp> createState() => _WithdrawHistoryPopUpState();
}

class _WithdrawHistoryPopUpState extends State<WithdrawHistoryPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Withdrawal Completed',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            const Divider(
              thickness: 1.0,
              color: kBorderColorTextField,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Withdraw to:',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  'PayPal Account',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Transaction ID:',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  '7254636544114',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Price:',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  '$currencySign 5,000.00',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Transaction Made:',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const Spacer(),
                Text(
                  '10 Jun 2023',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: kWhite,
                    borderColor: redColor,
                    buttonText: 'Cancel',
                    textColor: redColor,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: kPrimaryColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Confirm',
                    textColor: kWhite,
                    onPressed: () {
                      finish(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
