import 'package:flutter/material.dart';
import 'package:quiz/models/setting.dart';
import 'package:quiz/pages/category.dart';
import 'package:quiz/pages/rate_app.dart';
import 'package:quiz/pages/settings.dart';
import 'package:quiz/pages/start.dart';
import 'package:scoped_model/scoped_model.dart';

class Router {
  static const String rootRoute = "/";
  static const String settingsRoute = "/settings";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rootRoute:
        return MyCustomRoute(
          builder: (_) => StartPage(),
          settings: settings,
        );

      case '/test':
        return MyCustomRoute(
          builder: (_) => SignInPage(),
          settings: settings,
        );

      case '/test2':
        return MyCustomRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );

      case '/home':
        return MyCustomRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );

      case '/settings':
        return MyCustomRoute(
          builder: (_) => ScopedModelDescendant<Setting>(
            builder: (context, child, model) {
              return SettingsPage(
                setting: model,
              );
            },
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}
