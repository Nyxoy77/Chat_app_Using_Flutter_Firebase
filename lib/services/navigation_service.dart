import 'package:chata/Pages/home_page.dart';
import 'package:chata/Pages/login_page.dart';
import 'package:chata/Pages/registeration_page.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class NavigationService {
  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }
  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    "/home" : (context) =>HomePage(),
    "/register" : (context)=> RegisterationPage(),
  };

  GlobalKey<NavigatorState>? get navigatorKey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)>? get routes {
    return _routes;
  }

  void pushNamed(String routeName) {
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorKey.currentState?.pop();
  }
}
