import 'package:deeplink/home.dart';
import 'package:deeplink/routes.dart';
import 'package:deeplink/splashscreen.dart';
import 'package:deeplink/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import 'checkcategory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? uri;
  String? deepLinkId;
  String? itemId;
  bool isUniLinksInitialized = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<void> initUniLinks() async {
    debugPrint('Setting up deep link subscription');
    debugPrint('deep link init $isUniLinksInitialized');
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        debugPrint('Initial deep link: $initialUri');
        handleDeepLink(initialUri);
      }

      getUriLinksStream().listen((Uri? uri) {
        if (uri != null) {
          debugPrint('Deep link: $uri');
          handleDeepLink(uri);
        }
      }, onError: (err) {
        debugPrint('Error receiving deep link: $err');
      });
    } on PlatformException {
      debugPrint('Error initializing deep link');
    }
  }

  void handleDeepLink(Uri uri) {
    if (uri.path == '/items' && uri.queryParameters['id'] != null) {
      itemId = uri.queryParameters['id']!;
      debugPrint('Navigating to item with deep ID: $itemId');

      // Check if SharedItemDetails is already on the stack
      final currentRoute = ModalRoute.of(navigatorKey.currentContext!);
      if (currentRoute?.settings.name != AppRoutes.checkitems) {
        // Use pushReplacementNamed to replace the current route
        navigatorKey.currentState?.pushReplacementNamed(
          AppRoutes.checkitems,
          arguments: CheckCategory(id: itemId),
        );
      }
    } else if (uri.path == '/profile' && uri.queryParameters['id'] != null) {
      itemId = uri.queryParameters['id']!;
      debugPrint('Navigating to profile with ID: $itemId');

      // Check if Userprofile is already on the stack
      final currentRoute = ModalRoute.of(navigatorKey.currentContext!);
      if (currentRoute?.settings.name != AppRoutes.userprofile) {
        // Use pushReplacementNamed to replace the current route
        navigatorKey.currentState?.pushReplacementNamed(
          AppRoutes.userprofile,
          arguments: Userprofile(profileid: itemId),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: determineInitialRoute(),
      routes: {
        AppRoutes.SplashScreen: (context) => SplashScreen(),
        AppRoutes.HomeScreen: (context) => const HomeScreen(),
        AppRoutes.checkitems: (context) => CheckCategory(
              id: itemId,
            ),
        AppRoutes.userprofile: (context) => Userprofile(
              profileid: itemId,
            )
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.checkitems) {
          return MaterialPageRoute(
            builder: (context) => CheckCategory(id: itemId),
          );
        }
        return null;
      },
      title: "XYZ",
    );
  }

  String determineInitialRoute() {
    if (itemId != null) {
      debugPrint('  deep link id $itemId');
      return AppRoutes.checkitems;
    } else {
      debugPrint('null deep link id $itemId');
      return AppRoutes.SplashScreen;
    }
  }
}
