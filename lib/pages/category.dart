import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quiz/components/quiz_options.dart';
import 'package:quiz/models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _screenController;

  @override
  void initState() {
    super.initState();
    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.3;
    Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'AvocadoCreamy',
            ),
          ),
          elevation: 0,
//          leading: IconButton(
//            icon: Icon(Icons.home),
//            onPressed: () => Navigator.pushNamed(context, "/start"),
//          ),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.settings),
//              onPressed: () => Navigator.pushNamed(context, "/settings"),
//            ),
//          ],
        ),
        body: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    height: 200,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: AnimationLimiter(
                    child: GridView.count(
                      childAspectRatio: 1,
                      padding: EdgeInsets.all(4.0),
                      crossAxisCount: 3,
                      children: List.generate(
                        categories.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 3,
                            position: index,
                            duration: Duration(milliseconds: 575),
                            child: ScaleAnimation(
                              scale: 0.5,
                              child: FadeInAnimation(
                                  child: _buildCategoryItem(context, index)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: Offset(0.0, 4.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (category.icon != null)
              Icon(
                category.icon,
                size: 32,
                color: Colors.black,
              ),
            if (category.icon != null) SizedBox(height: 10.0),
            AutoSizeText(
              category.name,
              minFontSize: 16.0,
              textAlign: TextAlign.center,
              maxLines: 2,
              wrapWords: false,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      onTap: () => _categoryPressed(context, category),
    );

    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, category),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null)
            Icon(
              category.icon,
              size: 40,
              color: Colors.white,
            ),
          if (category.icon != null) SizedBox(height: 15.0),
          AutoSizeText(
            category.name,
            minFontSize: 18.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          category: category,
        ),
        onClosing: () {},
      ),
    );
  }
}
