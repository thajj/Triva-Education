import 'package:flutter/material.dart';
import 'package:quiz/pages/start/start_page_enter_animation.dart';

class StartDetailsPage extends StatelessWidget {
  StartDetailsPage({
    @required AnimationController controller,
    this.animationStatus,
    this.onPlay,
    this.loginButtonController,
  }) : animation = new StartDetailsPageEnterAnimation(controller);

  final StartDetailsPageEnterAnimation animation;
  final AnimationController loginButtonController;
  final Function onPlay;
  final int animationStatus;

  Widget _buildAnimation(BuildContext context, Widget child) {
//    return new Stack(
//      fit: StackFit.expand,
//      children: <Widget>[
//        Opacity(
//          opacity: animation.backdropOpacity.value,
//          child: Image.asset(
//            'assets/images/logo.png',
//            height: 192,
//            fit: BoxFit.fitHeight,
//          ),
//        ),
//        new BackdropFilter(
//          filter: new ui.ImageFilter.blur(
//            sigmaX: animation.backdropBlur.value,
//            sigmaY: animation.backdropBlur.value,
//          ),
//          child: new Container(
//            color: Colors.black.withOpacity(0.5),
//            child: _buildContent(),
//          ),
//        ),
//      ],
//    );

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            _buildLogoScroller(),
//            Center(
//              child: Image.asset(
//                'assets/images/logo.png',
//                height: 192,
//                fit: BoxFit.fitHeight,
//              ),
//            ),
            _buildAppName(),

            Opacity(
              opacity: animation.btnLogginOpacity.value,
              child: StaggerAnimation(
                  buttonController: loginButtonController.view),
            ),

//            Column(
////                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Container(
//                  margin: EdgeInsets.symmetric(vertical: 30.0),
//                  height: 100,
//                  child: Text(
//                    'Open Trivia',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 32,
//                      fontWeight: FontWeight.w500,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            animationStatus == 0
//                ? Padding(
//                    padding: const EdgeInsets.only(bottom: 50.0),
//                    child: InkWell(
//                      onTap: () async {
////                        setState(() {
////                          animationStatus = 1;
////                        });
//                        await AudioCache().play(Constants().btnTap);
////                        _playAnimation();
//                      },
//                      child: StartButton(),
//                    ),
//                  )
//                : StaggerAnimation(buttonController: animation.controller.view),
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

  Widget _buildLogoScroller() {
    return Transform(
      transform: new Matrix4.translationValues(
        0.0,
        animation.logoYTranslation.value * -1,
        0.0,
      ),
      child: Image.asset(
        'assets/images/logo.png',
        height: 192,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildAppName() {
    return new Transform(
      transform: new Matrix4.diagonal3Values(
        animation.appNameSize.value,
        animation.appNameSize.value,
        1.0,
      ),
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(bottom: 150),
        child: Text(
          'Open Trivia',
          style: TextStyle(
            color: Colors.black,
            fontSize: 60,
            fontFamily: 'AvocadoCreamy',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: animation.controller,
        builder: _buildAnimation,
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.buttonController})
      : buttonSqueezeanimation = Tween(
          begin: 260.0,
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
//    print(buttomZoomOut.value);
    return Padding(
      padding: buttomZoomOut.value == 70
          ? const EdgeInsets.only(bottom: 0.0)
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
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
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
//    buttonController.addListener(() {
//      if (buttonController.isCompleted) {
//        Navigator.pushReplacementNamed(context, '/home');
////        Navigator.pushNamed(context, "/home");
//      }
//    });
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
