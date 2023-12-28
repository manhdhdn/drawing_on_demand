import 'dart:convert';

import 'package:document_analysis/document_analysis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../app_routes/named_routes.dart';
import '../../data/apis/order_api.dart';
import '../../data/apis/order_detail_api.dart';
import '../../data/models/account_review.dart';
import '../../data/models/artwork.dart';
import '../../data/models/artwork_review.dart';
import '../../data/models/order.dart';
import '../../data/models/order_detail.dart';
import '../../screen/common/message/function/chat_function.dart';
import '../../screen/common/popUp/popup_1.dart';
import '../../screen/widgets/constant.dart';
import '../utils/pref_utils.dart';

void logout(BuildContext context) async {
  try {
    // Sign out
    await FirebaseAuth.instance.signOut();

    // Offline chat
    ChatFunction.updateUserData({
      'lastActive': DateTime.now(),
      'isOnline': false,
    });

    // Clear pref data
    PrefUtils().clearPreferencesData();

    // Navigate to login
    // ignore: use_build_context_synchronously
    context.goNamed(LoginRoute.name);
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
    await imageRef.putData(data, SettableMetadata(contentType: image.mimeType));
  } catch (error) {
    rethrow;
  }

  return imageRef.getDownloadURL();
}

String getReviewPoint(List<ArtworkReview> artworkReviews) {
  double point = 0;

  if (artworkReviews.isNotEmpty) {
    for (var artworkReview in artworkReviews) {
      point += artworkReview.star!;
    }

    point = point / artworkReviews.length;
  }

  return NumberFormat('0.0').format(point);
}

String getAccountReviewPoint(List<AccountReview> accountReviews) {
  double point = 0;

  if (accountReviews.isNotEmpty) {
    for (var artworkReview in accountReviews) {
      point += artworkReview.star!;
    }

    point = point / accountReviews.length;
  }

  return NumberFormat('0.0').format(point);
}

Future<Order> getCart() async {
  Order order = Order();

  try {
    if (PrefUtils().getCartId() == '{}') {
      order = (await OrderApi().gets(
        0,
        filter:
            "orderedBy eq ${jsonDecode(PrefUtils().getAccount())['Id']} and status eq 'Cart'",
        expand:
            'orderDetails(expand=artwork(expand=arts,sizes,createdByNavigation))',
      ))
          .value
          .first;

      PrefUtils().setCartId(order.id!.toString());
    } else {
      order = await OrderApi().getOne(
        PrefUtils().getCartId(),
        'orderDetails(expand=artwork(expand=arts,sizes,createdByNavigation))',
      );
    }
  } catch (error) {
    order = Order(
      id: Guid.newGuid,
      orderType: 'Artwork',
      orderDate: DateTime.now(),
      status: 'Cart',
      total: 0,
      orderBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
      orderDetails: [],
    );

    await OrderApi().postOne(order);

    PrefUtils().setCartId(order.id!.toString());
  }

  return order;
}

void onAddToCart(Artwork artwork) async {
  Order order = await getCart();

  for (var orderDetail in order.orderDetails!) {
    if (orderDetail.artworkId == artwork.id) {
      increaseQuantity(orderDetail.id.toString(), orderDetail.quantity!);

      Fluttertoast.showToast(msg: 'Add to cart successfully (quantity)');

      return;
    }
  }

  try {
    OrderDetail orderDetai = OrderDetail(
      id: Guid.newGuid,
      price: artwork.price,
      quantity: 1,
      fee: artwork.createdByNavigation!.rank!.fee,
      artworkId: artwork.id,
      orderId: order.id,
    );

    await OrderDetailApi().postOne(orderDetai);

    Fluttertoast.showToast(msg: 'Add to cart successfully');
  } catch (error) {
    Fluttertoast.showToast(msg: 'Add to cart failed');
  }
}

Future<void> increaseQuantity(String id, int quantity) async {
  quantity++;

  try {
    await OrderDetailApi().patchOne(id, {'Quantity': quantity});
  } catch (error) {
    //
  }
}

Future<void> decreaseQuantity(String id, int quantity) async {
  quantity--;

  try {
    await OrderDetailApi().patchOne(id, {'Quantity': quantity});
  } catch (error) {
    //
  }
}

int getCartIndex(int index, List<int> packList) {
  int cartIndex = 0;

  for (var i = 0; i < index; i++) {
    cartIndex += packList[i];
  }

  return cartIndex;
}

double getMatchPoint(String base, String target) {
  base.toLowerCase;
  target.toLowerCase;

  return wordFrequencySimilarity(base, target);
}

String getDiscount() {
  return '';
}
