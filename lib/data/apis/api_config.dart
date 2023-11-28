import 'package:firebase_auth/firebase_auth.dart';

class ApiConfig {
  static const String baseUrl = 'localhost:7257';

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ${FirebaseAuth.instance.currentUser?.getIdToken().toString()}',
  };

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
    'ranking': 'rankings',
    'requirement': 'requirements',
    'role': 'roles',
    'size': 'sizes',
    'step': 'steps',
    'surface': 'surfaces',
  };
}
