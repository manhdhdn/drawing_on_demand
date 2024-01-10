import '../../core/utils/pref_utils.dart';

class ApiConfig {
  // static const String baseUrl = 'localhost:7257';
  static const String baseUrl = 'dond.azurewebsites.net';
  static const String paymentUrl = 'http://localhost:8000';
  // static const String paymentUrl = 'http://localhost:8000';

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${PrefUtils().getToken()}',
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

    // GHN
    'ghn': 'ghn',

    // VNPay
    'vnpay': 'vnpay',
  };

  // ignore: constant_identifier_names
  static const Map<String, String> GHNPaths = {
    'province': '/master-data/province',
    'district': '/master-data/district',
    'ward': '/master-data/ward',
    'fee': '/v2/shipping-order/fee',
    'preview': '/v2/shipping-order/preview',
    'create': '/v2/shipping-order/create',
  };
}
