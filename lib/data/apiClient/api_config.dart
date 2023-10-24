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
    "account": "accounts",
  };
}
