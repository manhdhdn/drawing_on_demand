import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app_routes/go_routes.dart';
import 'app_routes/named_routes.dart';
import 'core/utils/pref_utils.dart';
import 'data/notifications/firebase_api.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'screen/common/message/function/chat_function.dart';
import 'screen/common/message/provider/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();
  await PrefUtils().init();
  await findSystemLocale();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void refreshLocale(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();

    if (state != null) {
      state.setLanguage();
    }
  }

  static void refreshRoutes(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();

    if (state != null) {
      state.setRoutes();
    }
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Key notifierKey = GlobalKey();

  Locale locale = const Locale('vi');
  GoRouter routes = AppRoutes.routes();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    setLanguage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ChatFunction.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ChatFunction.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': false,
        });
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: notifierKey,
      create: (_) => ChatProvider(),
      child: MaterialApp.router(
        title: dod,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        locale: locale,
        theme: ThemeData(fontFamily: 'Display'),
        debugShowCheckedModeBanner: false,
        routerConfig: routes,
      ),
    );
  }

  Future<void> setLanguage() async {
    switch (PrefUtils().getLanguage()) {
      case 'English':
        setState(() {
          locale = const Locale('en');
        });
        break;
      case 'Vietnamese':
        setState(() {
          locale = const Locale('vi');
        });
        break;
    }
  }

  void setRoutes() {
    setState(() {
      notifierKey = GlobalKey();
      routes = AppRoutes.routes();
    });
  }
}
