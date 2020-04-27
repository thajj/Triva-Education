import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:quiz/models/setting.dart';
import 'package:quiz/utils/router.dart';
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
        onGenerateRoute: Router.generateRoute,
        home: StartPage(),
      ),
    );
  }
}

//class User extends StatelessWidget {
//  User({Key key, @required this.onLogout, @required this.user})
//      : super(key: key);
//
//  VoidCallback onLogout;
//  String username;
//  FirebaseUser user;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Welcome"),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.exit_to_app), onPressed: this.onLogout)
//        ],
//      ),
//      body: Container(
//          padding: const EdgeInsets.all(20.0),
//          child: Center(
//              child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Image.network(user.photoUrl),
//              Text(
//                user.displayName,
//                textScaleFactor: 1.5,
//              ),
//            ],
//          ))),
//    );
//  }
//}

//
//class App extends StatefulWidget {
//  AppState createState() => AppState();
//}
//
//class AppState extends State<App> {
//  String _username = "";
//  Widget currentPage;
//  GoogleSignIn googleSignIn;
//  Widget userPage;
//
//  @override
//  void initState() {
//    super.initState();
//    userPage = Home(
//      onSignin: () {
//        _signin();
//        print("Sign");
//      },
//      onLogout: _logout,
//      showLoading: false,
//    );
//  }
//
//  Future<FirebaseUser> _signin() async {
//    setState(() {
//      userPage = Home(onSignin: null, onLogout: _logout, showLoading: true);
//    });
//    FirebaseAuth _auth = FirebaseAuth.instance;
//    try {
//      googleSignIn = GoogleSignIn();
//      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//
//      final authHeaders = googleSignIn.currentUser.authHeaders;
//
//      // custom IOClient from below
////      final httpClient = GoogleHttpClient(authHeaders);
////
////      data = await PeopleApi(httpClient).people.connections.list(
////            'people/me',
////            personFields: 'names,addresses',
////            pageToken: nextPageToken,
////            pageSize: 100,
////          );
//
//      final GoogleSignInAuthentication gauth =
//          await googleSignInAccount.authentication;
//      final AuthCredential credential = GoogleAuthProvider.getCredential(
//        accessToken: gauth.accessToken,
//        idToken: gauth.idToken,
//      );
//      final AuthResult authRes = await _auth.signInWithCredential(credential);
//      final FirebaseUser user = authRes.user;
//
//      setState(() {
//        _username = user.displayName;
//        userPage = User(
//          onLogout: _logout,
//          user: user,
//        );
//      });
//
//      return user;
//    } catch (e) {
//      print(e.toString());
//    }
//    return null;
//  }
//
//  void _logout() async {
//    await googleSignIn.signOut();
//    setState(() {
//      userPage = Home(
//        onSignin: () {
//          _signin();
//          print("Sign");
//        },
//        onLogout: _logout,
//        showLoading: false,
//      );
//    });
//
//    print("Logged Out");
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return userPage;
//  }
//}
//
//class Home extends StatelessWidget {
//  Home(
//      {Key key,
//      @required this.onSignin,
//      @required this.onLogout,
//      @required this.showLoading})
//      : super(key: key);
//
//  final VoidCallback onSignin;
//  final VoidCallback onLogout;
//  bool showLoading = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text("Sign In")),
//      body: Container(
//          padding: const EdgeInsets.all(20.0),
//          child: Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                showLoading
//                    ? CircularProgressIndicator()
//                    : RaisedButton(
//                        onPressed: this.onSignin,
//                        child: Text("Sign In"),
//                        color: Colors.pink,
//                      ),
//                RaisedButton(
//                    onPressed: this.onLogout,
//                    child: Text("Logout"),
//                    color: Colors.amberAccent),
//              ],
//            ),
//          )),
//    );
//  }
//}

//Custom IOClient implementation that automatically adds the auth headers to each request.
//The googleapis call support passing a custom HTTP client to be used instead of the default.
class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<StreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
