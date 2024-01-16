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
import '../../data/apis/api_config.dart';
import '../../data/apis/discount_api.dart';
import '../../data/apis/ghn_api.dart';
import '../../data/apis/order_api.dart';
import '../../data/apis/order_detail_api.dart';
import '../../data/models/account_review.dart';
import '../../data/models/artwork.dart';
import '../../data/models/artwork_review.dart';
import '../../data/models/discount.dart';
import '../../data/models/ghn_request.dart';
import '../../data/models/order.dart';
import '../../data/models/order_detail.dart';
// import '../../main.dart';
import '../../screen/common/message/function/chat_function.dart';
import '../../screen/common/popUp/popup_1.dart';
import '../../screen/widgets/constant.dart';
import '../utils/pref_utils.dart';

Future<void> logout(BuildContext context) async {
  try {
    // Sign out
    await FirebaseAuth.instance.signOut();

    // Offline chat
    ChatFunction.updateUserData({
      'lastActive': DateTime.now(),
      'isOnline': false,
    });

    // Clear pref data
    await PrefUtils().clearPreferencesData();

    // Navigate to login
    Future.delayed(const Duration(milliseconds: 500), () {
      // MyApp.refreshRoutes(context);
      context.goNamed(LoginRoute.name);
    });
  } catch (error) {
    Fluttertoast.showToast(msg: error.toString());
  }
}

Future<void> showImportPicturePopUp(BuildContext context) async {
  await showDialog(
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
    if (images.isEmpty) {
      images.addAll(image);
    } else {
      for (var i = 0; i < (image.length > 3 ? 3 : image.length); i++) {
        try {
          images[i] = image[i];
        } catch (error) {
          images.add(image[i]);
        }
      }
    }
  }
}

Future<void> pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (image != null) {
    if (images.isEmpty) {
      images.add(image);
    } else {
      images[0] = image;
    }
  }
}

Future<void> openCamera() async {
  final image = await ImagePicker().pickImage(source: ImageSource.camera);

  if (image != null) {
    if (images.isEmpty) {
      images.add(image);
    } else {
      images[0] = image;
    }
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
      if (artworkReview.status == 'Approved') {
        point += artworkReview.star!;
      }
    }

    point = point / artworkReviews.length;
  }

  return NumberFormat('0.0').format(point);
}

String getAccountReviewPoint(List<AccountReview> accountReviews) {
  double point = 0;

  if (accountReviews.isNotEmpty) {
    for (var artworkReview in accountReviews) {
      if (artworkReview.status == 'Approved') {
        point += artworkReview.star!;
      }
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
      orderedBy: Guid(jsonDecode(PrefUtils().getAccount())['Id']),
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

      Fluttertoast.showToast(msg: 'Thêm số lượng vào giỏ hàng thành công');

      return;
    }
  }

  try {
    OrderDetail orderDetail = OrderDetail(
      id: Guid.newGuid,
      price: artwork.price,
      quantity: 1,
      fee: artwork.createdByNavigation!.rank!.fee,
      artworkId: artwork.id,
      orderId: order.id,
    );

    await OrderDetailApi().postOne(orderDetail);

    Fluttertoast.showToast(msg: 'Thêm tác phẩm mới vào giỏ hàng thành công');
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

double getSubtotal(List<OrderDetail> orderDetails) {
  double subtotal = 0;

  for (var orderDetail in orderDetails) {
    subtotal += orderDetail.price! * orderDetail.quantity!;
  }

  return subtotal;
}

Future<int> getProvinceCode(String address) async {
  int code = 0;

  try {
    var request = GHNRequest(endpoint: ApiConfig.GHNPaths['province']);
    var respone = await GHNApi().postOne(request);

    var provinces = List<Map<String, dynamic>>.from(
        jsonDecode(respone.postJsonString!)['data']);

    Map<String, dynamic> result = {};
    double matchPoint = 0;

    for (var province in provinces) {
      var nameExs = [];

      if (province.containsKey('NameExtension')) {
        nameExs = List<String>.from(province['NameExtension']);
      }

      for (var nameEx in nameExs) {
        double point = getMatchPoint(address.split(',').last, nameEx);

        if (matchPoint < point) {
          matchPoint = point;
          result = province;
        }
      }
    }

    code = result['ProvinceID'];
  } catch (error) {
    Fluttertoast.showToast(msg: 'Get country code failed');
  }

  return code;
}

Future<int> getDistrictCode(String address, int provinceId) async {
  int code = 0;

  try {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['district'],
      postJsonString: jsonEncode(
        {'province_id': provinceId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    var districts = List<Map<String, dynamic>>.from(
        jsonDecode(respone.postJsonString!)['data']);

    Map<String, dynamic> result = {};
    double matchPoint = 0;

    for (var district in districts) {
      var nameExs = [];

      if (district.containsKey('NameExtension')) {
        nameExs = List<String>.from(district['NameExtension']);
      }

      for (var nameEx in nameExs) {
        double point = getMatchPoint(address, nameEx);

        if (matchPoint < point) {
          matchPoint = point;
          result = district;
        }
      }
    }

    code = result['DistrictID'];
  } catch (error) {
    Fluttertoast.showToast(msg: 'Get district code failed');
  }

  return code;
}

Future<String> getWardCode(String address, int districtId) async {
  String code = '0';

  try {
    var request = GHNRequest(
      endpoint: ApiConfig.GHNPaths['ward'],
      postJsonString: jsonEncode(
        {'district_id': districtId},
      ),
    );
    var respone = await GHNApi().postOne(request);

    var wards = List<Map<String, dynamic>>.from(
        jsonDecode(respone.postJsonString!)['data']);

    Map<String, dynamic> result = {};
    double matchPoint = 0;

    for (var ward in wards) {
      var nameExs = [];

      if (ward.containsKey('NameExtension')) {
        nameExs = List<String>.from(ward['NameExtension']);
      }

      for (var nameEx in nameExs) {
        double point = getMatchPoint(address, nameEx);

        if (matchPoint < point) {
          matchPoint = point;
          result = ward;
        }
      }
    }

    code = result['WardCode'];
  } catch (error) {
    Fluttertoast.showToast(msg: 'Get ward code failed');
  }

  return code;
}

double getMatchPoint(String base, String target) {
  base.toLowerCase;
  target.toLowerCase;

  return wordFrequencySimilarity(base, target);
}

Future<Map<String, dynamic>> getDiscount(Order order) async {
  double discount = 0;
  int quantity = 0;
  Guid? discountId;

  try {
    for (var orderDetail in order.orderDetails!) {
      quantity += orderDetail.quantity!;
    }

    DateTime dateTime = DateTime.now();
    String dateTimeString =
        DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(dateTime);

    Discounts discounts = await DiscountApi().gets(
      0,
      filter:
          'number le $quantity and startDate le $dateTimeString and endDate ge $dateTimeString',
      orderBy: 'discountPercent',
    );

    if (discounts.value.isNotEmpty) {
      discount = discounts.value.last.discountPercent!;
      discountId = discounts.value.last.id!;
    }
  } catch (error) {
    rethrow;
  }

  return {'discountPercent': discount, 'discountId': discountId};
}

List<String> getArtistsName(List<OrderDetail> orderDetails) {
  List<String> artistsNames = [];

  for (var orderDetail in orderDetails) {
    artistsNames.add(orderDetail.artwork!.createdByNavigation!.name!);
  }

  return artistsNames;
}
