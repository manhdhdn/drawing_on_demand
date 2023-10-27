import 'package:firebase_auth/firebase_auth.dart';

class ApiConfig {
  static const String baseUrl = "dond.azurewebsites.net";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${FirebaseAuth.instance.currentUser?.getIdToken()}',
  };

  static const String odata = "Odata";

  static const Map<String, String> paths = {
    "accountReview": "accountReviews",
    "accountRole": "accountRoles",
    "account": "accounts",
    "art": "arts",
    "artworkReview": "artworkReviews",
    "artwork": "artworks",
    "category": "categories",
    "certificate": "certificates",
    "discountByNumber": "discountByNumbers",
    "discountBySpecial": "discountBySpecials",
    "handoverItem": "handoverItems",
    "handover": "handovers",
    "invite": "invites",
    "orderDetail": "orderDetails",
    "order": "orders",
    "payment": "payments",
    "proposal": "proposals",
    "ranking": "rankings",
    "requirement": "requirements",
    "role": "roles",
    "size": "sizes",
    "timeline": "timeLines",
  };
}
