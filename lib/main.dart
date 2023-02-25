import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomas/helpers/deeplinks.dart';
import 'package:tomas/helpers/push_notification_service.dart';
import 'package:tomas/localization/app_translations_delegate.dart';
import 'package:tomas/localization/application.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/introduction/introduction.dart';
import 'package:tomas/screens/landing/landing.dart';
import 'package:tomas/screens/lifecycle_manager/lifecycle_manager.dart';
import 'package:uni_links/uni_links.dart';

import 'redux/app_state.dart';
import 'redux/store.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Store<AppState> _store = await createStore();
  await Firebase.initializeApp();

  runApp(
    MainApp(_store), // Wrap your app
  );
}

class MainApp extends StatefulWidget {
  final Store<AppState> store;

  MainApp(this.store);
  @override
  _MainAppState createState() => _MainAppState();

  static _MainAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  StreamSubscription _linkSubscription;
  SharedPreferences prefs;
  AppTranslationsDelegate _newLocaleDelegate;

  bool isLogin = false;
  bool introduction = false;

  Future initMain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwtToken = prefs.getString('jwtToken');
    if (jwtToken != null) {
      print(jwtToken);
      bool hasExpired = JwtDecoder.isExpired(jwtToken);
      if (hasExpired) {
        prefs.remove('jwtToken');
        setState(() {
          isLogin = false;
        });
      } else {
        setState(() {
          isLogin = true;
        });
      }
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  Future<void> initPlatformState() async {
    // Attach a listener to the Uri links stream

// 1
    _linkSubscription = getUriLinksStream().listen((Uri uri) {
      print(uri);
      if (!mounted) return;
      Deeplinks.parseRoute(uri, navigatorKey, isLogin);
    }, onError: (Object err) {
      print('Got error $err');
    });
  }

  Future<void> onLocaleChange(Locale locale) async {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  Future<void> initLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('language') ?? 'en';
    setState(() {
      _newLocaleDelegate =
          AppTranslationsDelegate(newLocale: Locale(language, ''));
    });
  }

  Future<void> initIntoduction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _data = prefs.getBool('introduction') ?? false;
    if (_data) {
      setState(() {
        introduction = prefs.getBool('introduction') ?? false;
      });
    }
  }

  // Future<void> iniFirebasetNotification() async {
  //   await pushNotificationService.initialize(navigatorKey, context);
  // }

  @override
  void initState() {
    initPlatformState();
    initIntoduction();
    initMain();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: Locale('en', ''));
    initLocale();
    application.onLocaleChanged = onLocaleChange;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // iniFirebasetNotification();
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: StoreProvider<AppState>(
            store: widget.store,
            child: LifecycleManager(MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Tomas',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  brightness: Brightness.light,
                  primarySwatch: Colors.red,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  appBarTheme: AppBarTheme(
                      elevation: 0,
                      color: Colors.white,
                      brightness: Brightness.light),
                  dialogBackgroundColor: Colors.white24,
                  bottomSheetTheme:
                      BottomSheetThemeData(backgroundColor: Colors.black26)),
              localizationsDelegates: [
                _newLocaleDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: <Locale>[
                const Locale('en', ''),
                const Locale('id', ''),
              ],
              home: introduction
                  ? !isLogin
                      ? Landing()
                      : Home()
                  : Introduction(),
              routes: routes,
            ))));
  }
}
//!isLogin ? Landing() :
