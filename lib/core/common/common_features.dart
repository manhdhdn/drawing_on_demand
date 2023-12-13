import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../app_routes/app_routes.dart';
import '../../data/models/account_review.dart';
import '../../data/models/artwork_review.dart';
import '../../screen/common/popUp/popup_1.dart';
import '../../screen/widgets/constant.dart';
import '../utils/pref_utils.dart';

void logout(BuildContext context) async {
  try {
    // Sign out
    await FirebaseAuth.instance.signOut();

    // Clear pref data
    PrefUtils().clearPreferencesData();

    // Navigate to login

    // ignore: use_build_context_synchronously
    Phoenix.rebirth(context);

    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.defaultTag,
      (route) => false,
    );
  } catch (error) {
    Fluttertoast.showToast(msg: error.toString());
  }
}

void showImportPicturePopUp(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
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

Future<void> pickMultipleImages() async {
  final image = await ImagePicker().pickMultiImage();

  if (image.isNotEmpty) {
    images.addAll(image);
  }
}

Future<void> pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (image != null) {
    images.add(image);
  }
}

Future<void> openCamera() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);

  if (image != null) {
    images.add(image);
  }
}

Future<String> uploadImage(XFile image) async {
  const String folder = 'images/';

  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef.child(folder + image.name);

  var data = await image.readAsBytes();

  try {
    await imageRef.putData(data);
  } catch (error) {
    rethrow;
  }

  return imageRef.getDownloadURL();
}

String getReviewPoint(Set<ArtworkReview> artworkReviews) {
  double point = 0;

  if (artworkReviews.isNotEmpty) {
    for (var artworkReview in artworkReviews) {
      point += artworkReview.star!;
    }

    point = point / artworkReviews.length;
  }

  return NumberFormat('0.0').format(point);
}

String getAccountReviewPoint(Set<AccountReview> accountReviews) {
  double point = 0;

  if (accountReviews.isNotEmpty) {
    for (var artworkReview in accountReviews) {
      point += artworkReview.star!;
    }

    point = point / accountReviews.length;
  }

  return NumberFormat('0.0').format(point);
}

void onAddToCart(String id) {
  // TODO
}
