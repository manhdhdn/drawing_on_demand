import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import '../../app_routes/go_routes.dart';
import '../../core/utils/pref_utils.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'default_channel', // id
    'Default Notifications', // title
    description: 'This channel is used for all notifications.', // description
    importance: Importance.defaultImportance,
    playSound: true,
    showBadge: true,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();

    await PrefUtils().setDeviceId(fCMToken!);

    initPushNotifications();
    initLocalNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    // Handle navigation here
    if (message.data['pathName'] != null) {
      GoRouter.of(shellNavigatorContext).goNamed(
        message.data['pageName'],
        pathParameters: {message.data['pathName']: message.data['referenceId']},
      );
    } else {
      GoRouter.of(shellNavigatorContext).goNamed(message.data['pageName']);
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }

    // Handle navigation here
    if (message.data['pathName'] != null) {
      GoRouter.of(shellNavigatorContext).goNamed(
        message.data['pageName'],
        pathParameters: {message.data['pathName']: message.data['referenceId']},
      );
    } else {
      GoRouter.of(shellNavigatorContext).goNamed(message.data['pageName']);
    }
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // App terminate and open
    _firebaseMessaging.getInitialMessage().then(handleMessage);

    // App open from no where
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // App in background
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification == null) {
        return;
      }

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));

          handleMessage(message);
        }
      },
      onDidReceiveBackgroundNotificationResponse: (response) {
        if (response.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(response.payload!));

          handleBackgroundMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    required String receiverDeviceId,
    required String pageName,
    String? pathName,
    String? referenceId,
  }) async {
    try {
      var key = 'AAAAnm9VMYE:APA91bHilD1G2CG4ZSyzIoJnVnQvuN1J7bnaCt4LSjyR20UJkKOINoxTWLQ8k9V8SRu1M1DkZmJ3UGoxi41CcRP48pWvISqfFN_KDM-Tn4oHxiGxAlfgXUFo-Ku5oVS1gmSgC9N4aAvQ';

      var response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(
          <String, dynamic>{
            "to": receiverDeviceId,
            'priority': 'high',
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'data': <String, String?>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'pageName': pageName,
              'pathName': pathName,
              'referenceId': referenceId,
            }
          },
        ),
      );

      if (response.statusCode >= 400) {
        throw Exception();
      }
    } catch (error) {
      // Fluttertoast.showToast(msg: error.toString());
    }
  }
}
