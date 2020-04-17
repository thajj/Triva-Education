import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz/components/quiz_options.dart';
import 'package:quiz/models/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _screenController;
  Animation<double> containerGrowAnimation;
  Animation<Color> fadeScreenAnimation;

  @override
  void initState() {
    super.initState();

    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
//    _buttonController = new AnimationController(
//        duration: new Duration(milliseconds: 1500), vsync: this);

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    ).animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

//    buttonGrowAnimation = new CurvedAnimation(
//      parent: _screenController,
//      curve: Curves.easeOut,
//    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

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
        appBar: AppBar(
          title: Text('Catégories'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, "/start"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, "/settings"),
            ),
          ],
        ),
        body: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    height: 200,
                  ),
                ),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
//                SliverToBoxAdapter(
//                  child: Padding(
//                    padding: const EdgeInsets.symmetric(
//                        horizontal: 16.0, vertical: 30.0),
//                    child: Text(
//                      "Sélectionne une catégorie",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w500,
//                          fontSize: 20.0),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          top: 56.0, right: 16.0, bottom: 16.0, left: 16.0),
                      sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0),
                          delegate: SliverChildBuilderDelegate(
                            _buildCategoryItem,
                            childCount: categories.length,
                          )),
                    ),
                  ],
                ),
                FadeBox(
                  fadeScreenAnimation: fadeScreenAnimation,
                  containerGrowAnimation: containerGrowAnimation,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
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
          if (category.icon != null) SizedBox(height: 5.0),
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

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonZoomOutAnimation = new Tween(
          begin: 60.0,
          end: 1000.0,
        ).animate(
          new CurvedAnimation(parent: buttonController, curve: Curves.easeOut),
        ),
        buttonBottomtoCenterAnimation = new AlignmentTween(
          begin: Alignment.bottomRight,
          end: Alignment.center,
        ).animate(
          new CurvedAnimation(
            parent: buttonController,
            curve: new Interval(
              0.0,
              0.200,
              curve: Curves.easeOut,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> buttonController;
  final Animation buttonZoomOutAnimation;
  final Animation<Alignment> buttonBottomtoCenterAnimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    timeDilation = 0.4;

    return (new Padding(
        padding: buttonZoomOutAnimation.value < 400
            ? new EdgeInsets.all(20.0)
            : new EdgeInsets.all(0.0),
        child: new Container(
            alignment: buttonBottomtoCenterAnimation.value,
            child: new InkWell(
              child: new Container(
                width: buttonZoomOutAnimation.value,
                height: buttonZoomOutAnimation.value,
                alignment: buttonBottomtoCenterAnimation.value,
                decoration: new BoxDecoration(
                    color: Colors.pink,
                    shape: buttonZoomOutAnimation.value < 400
                        ? BoxShape.circle
                        : BoxShape.rectangle),
                child: new Icon(
                  Icons.add,
                  size: buttonZoomOutAnimation.value < 50
                      ? buttonZoomOutAnimation.value
                      : 0.0,
                  color: Colors.white,
                ),
              ),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      // if (controller.isCompleted) Navigator.pushNamed(context, "/login");    //options
      // if (controller.isCompleted) Navigator.of(context).pop();       //options
      if (buttonController.isCompleted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}

class FadeBox extends StatelessWidget {
  final Animation<double> containerGrowAnimation;
  final Animation<Color> fadeScreenAnimation;
  FadeBox({this.containerGrowAnimation, this.fadeScreenAnimation});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return (new Hero(
        tag: "fade",
        child: new Container(
          width: containerGrowAnimation.value < 1 ? screenSize.width : 0.0,
          height: containerGrowAnimation.value < 1 ? screenSize.height : 0.0,
          decoration: new BoxDecoration(
            color: fadeScreenAnimation.value,
          ),
        )));
  }
}
