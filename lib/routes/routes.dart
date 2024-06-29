import 'package:flutter/material.dart';
import 'package:promilo_project/models/top_trending_model.dart';
import 'package:promilo_project/screens/details/description_page.dart';
import 'package:promilo_project/screens/home/home_page.dart';
import 'package:promilo_project/screens/login/login_page.dart';
import 'package:promilo_project/utils/constants.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case LoginPage.routeName:
        return FadeTransitionRoute(pageName: const LoginPage());
      case HomePage.routeName:
        return FadeTransitionRoute(pageName: const HomePage());
      case DescriptionPage.routeName:
        final data = routeSettings.arguments as TopTrendingModel;
        return FadeTransitionRoute(pageName: DescriptionPage(data: data));
      default:
        return FadeTransitionRoute(
            pageName: SafeArea(
          child: Scaffold(appBar: AppBar(), body: const Center(child: Text('404. \nScreen does not exist!'))),
        ));
    }
  }
}

class FadeTransitionRoute<T> extends PageRouteBuilder<T> {
  final Widget pageName;
  final RouteSettings? setting;

  FadeTransitionRoute({required this.pageName, this.setting})
      : super(
          settings: setting,
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => pageName,
          transitionDuration: kDefaultDuration,
          reverseTransitionDuration: kDefaultDuration,
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}
