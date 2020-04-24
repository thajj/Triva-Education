import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quiz/models/setting.dart';
import 'package:quiz/pages/category.dart';
import 'package:quiz/pages/settings.dart';
import 'package:quiz/utils/translations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'generated/i18n.dart';
import 'models/setting.dart';
import 'pages/start.dart';

final supportedLocales = const [const Locale('fr', ''), const Locale('en', '')];

final GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

final localizationsDelegates = <LocalizationsDelegate>[
  const TranslationsDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate
];

void main() {
  // Admob.initialize("a");
//
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp]
//  )
//      .then((_) {
//    runApp(MyApp());
//  });
  runApp(MyApp(
    settingModel: Setting(),
  ));
}

//
class MyApp extends StatelessWidget {
  final Setting settingModel;

  const MyApp({Key key, @required this.settingModel}) : super(key: key);

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Set this screen as a fullscreen
    //SystemChrome.setEnabledSystemUIOverlays([]);

    settingModel.load();
//    String test = AppLocalizations.of(context).title;
//    print(test);
    return ScopedModel<Setting>(
      model: settingModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Open Trivia',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.indigo,
//            fontFamily: "Montserrat",
            buttonColor: Colors.pink,
            buttonTheme: ButtonThemeData(
                buttonColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                textTheme: ButtonTextTheme.primary)),
        localizationsDelegates: [
          S.delegate,
          ...GlobalMaterialLocalizations.delegates
        ],
        supportedLocales: S.delegate.supportedLocales,
//        supportedLocales: [
//          const Locale('en', ''),
////          const Locale('fr', ''),
//        ],
        localeResolutionCallback: S.delegate
            .resolution(fallback: new Locale("en", ""), withCountry: false),
        onGenerateRoute: generateRoute,
        home: StartPage(),
      ),
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
