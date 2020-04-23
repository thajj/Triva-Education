import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoBody extends StatelessWidget {
  final AnimationController controller;
  final AnimationController waveController;
  final Size size;
//  final int xOffset;
//  final int yOffset;
//  final Color color;

  DemoBody({
    @required this.controller,
    @required this.waveController,
    @required this.size,
//      this.xOffset = 0,
//      this.yOffset = 0,
  }) : animationColor = ColorTween(
          begin: Colors.pink,
          end: Colors.grey.shade800,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

  Animation<Color> animationColor;

//
//  @override
//  void initState() {
//    super.initState();

//    animationColorController = new AnimationController(
//        vsync: this, duration: new Duration(seconds: 10));

//    animationColorController.forward();

//    animationColor = ColorTween(
//      begin: widget.color,
//      end: Colors.grey.shade800,
//    ).animate(animationColorController)
//      ..addListener(() {
//        setState(() {});
//      });
//

//      print('${widget.size.height} ${animationController.value / 2}');
//      if (widget.size.height > maxHeight / 2) {
////        if (!animationColorController.isAnimating) {
////          print('GOOOOOD');
////
////          animationColorController.forward();
//        }
//      }
//    });

//    animationController.addStatusListener((AnimationStatus status) {});
//
//  }

//  @override
//  void dispose() {
//    animationController.dispose();
//    animationColorController.dispose();
//    super.dispose();
//  }

//  void start() {
//    print('START color');
//    animationColorController.forward();
//  }
//
//  void reset() {
//    print('RESET color');
//    animationColorController.reset();
//  }
//
//  void pause() {
//    print('STOP color');
//    animationColorController.stop();
//  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: new Container(
            width: size.width,
            height: size.height,
//            color: widget.color,
            decoration: BoxDecoration(
              color: animationColor.value,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
//          clipper: new WaveClipper(animationColorController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
