import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app_routes/app_routes.dart';
import 'core/utils/pref_utils.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'screen/client_screen/job_post/job_details.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();
  PrefUtils();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void reLoadLocale(BuildContext context) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.initLanguage();
  }
}

class _MyAppState extends State<MyApp> {
  Locale locale = const Locale('vi');
  Map<String, WidgetBuilder> routes =
      AppRoutes.getRoutes(PrefUtils().getRole());

  @override
  void initState() {
    super.initState();

    initLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing on demand',
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
      initialRoute: AppRoutes.defaultTag,
      routes: routes,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const JobDetails(),
        );
      },
    );
  }

  Future<void> initLanguage() async {
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
      default:
        setState(() {
          locale = const Locale('vi');
        });
    }
  }
}
