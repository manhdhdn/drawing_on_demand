import 'package:firebase_auth/firebase_auth.dart';

class ApiConfig {
  static const String baseUrl = 'dond.azurewebsites.net';
  static String token = '';

  static Map<String, String> get headers {
    getToken();

    return {
      'accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static const String odata = 'Odata';

  static const Map<String, String> paths = {
    'accountReview': 'accountReviews',
    'accountRole': 'accountRoles',
    'account': 'accounts',
    'art': 'arts',
    'artworkReview': 'artworkReviews',
    'artwork': 'artworks',
    'category': 'categories',
    'certificate': 'certificates',
    'discount': 'discounts',
    'handoverItem': 'handoverItems',
    'handover': 'handovers',
    'invite': 'invites',
    'material': 'materials',
    'orderDetail': 'orderDetails',
    'order': 'orders',
    'payment': 'payments',
    'proposal': 'proposals',
    'rank': 'ranks',
    'requirement': 'requirements',
    'role': 'roles',
    'size': 'sizes',
    'step': 'steps',
    'surface': 'surfaces',
  };

  static void getToken() async {
    token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  }
}
