import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';

import '../constants.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StartPageState();
  }
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 192,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30.0),
                  height: 100,
                  child: Text(
                    'Open Trivia',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
//              Align(
//                alignment: Alignment.bottomCenter,
//                child: Text('1'),
//              ),
            animationStatus == 0
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          animationStatus = 1;
                        });
                        await AudioCache().play(Constants().btnTap);
                        _playAnimation();
                      },
                      child: StartButton(),
                    ),
                  )
                : StaggerAnimation(
                    buttonController: _loginButtonController.view),
//            SizedBox(
//              height: 100,
//              child:             IconButton(
//                icon: Icon(Icons.settings),
//                onPressed: () => Navigator.pushNamed(context, "/settings"),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  StartButton();
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.pink,
//        color: const Color.fromRGBO(247, 64, 106, 1.0),
        borderRadius: BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: Text(
        "PLAY", //S.of(context).title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }
}

class RandomButton extends StatelessWidget {
  RandomButton();
  @override
  Widget build(BuildContext context) {
    return (Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.pink,
//        color: const Color.fromRGBO(247, 64, 106, 1.0),
        borderRadius: BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: Text(
        "RANDOM TEST", //S.of(context).title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.0,
              0.150,
            ),
          ),
        ),
        buttomZoomOut = Tween(
          begin: 70.0,
          end: 1000.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(bottom: 0.0),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeanimation;
  final Animation buttomZoomOut;

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {}
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: InkWell(
          onTap: () {
            _playAnimation();
          },
          child: Hero(
            tag: "fade",
            child: buttomZoomOut.value <= 300
                ? Container(
                    width: buttomZoomOut.value == 70
                        ? buttonSqueezeanimation.value
                        : buttomZoomOut.value,
                    height:
                        buttomZoomOut.value == 70 ? 60.0 : buttomZoomOut.value,
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: buttomZoomOut.value < 400
                          ? BorderRadius.all(const Radius.circular(30.0))
                          : BorderRadius.all(const Radius.circular(0.0)),
                    ),
                    child: buttonSqueezeanimation.value > 75.0
                        ? Text(
                            "PLAY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          )
                        : buttomZoomOut.value < 300.0
                            ? CircularProgressIndicator(
                                value: null,
                                strokeWidth: 1.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : null)
                : Container(
                    width: buttomZoomOut.value,
                    height: buttomZoomOut.value,
                    decoration: BoxDecoration(
                      shape: buttomZoomOut.value < 500
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      color: Colors.pink,
                    ),
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushReplacementNamed(context, '/home');
//        Navigator.pushNamed(context, "/home");
      }
    });
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
