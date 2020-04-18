import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/pages/category.dart';
import 'package:quiz/pages/settings.dart';

import 'pages/start.dart';

void main() {
  // Admob.initialize("a");
//
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp]
//  )
//      .then((_) {
//    runApp(MyApp());
//  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/start':
        return MyCustomRoute(
          builder: (_) => StartPage(),
          settings: settings,
        );

      case '/home':
        return MyCustomRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );

      case '/settings':
        return MyCustomRoute(
          builder: (_) => SettingsPage(),
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trivia - Éducation',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.indigo,
          fontFamily: "Montserrat",
          buttonColor: Colors.pink,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              textTheme: ButtonTextTheme.primary)),
      onGenerateRoute: generateRoute,
      home: StartPage(),
    );
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
