import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as Vector;

class DemoBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  DemoBody(
      {Key key,
      @required this.size,
      this.xOffset = 0,
      this.yOffset = 0,
      this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DemoBodyState();
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController animationColorController;
  Animation<Color> animationColor;

  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animationColorController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 10));

    animationColor = ColorTween(
      begin: widget.color,
      end: Colors.grey.shade800,
    ).animate(CurvedAnimation(
        parent: animationColorController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    animationColorController.forward();

//    animationColor = ColorTween(
//      begin: widget.color,
//      end: Colors.grey.shade800,
//    ).animate(animationColorController)
//      ..addListener(() {
//        setState(() {});
//      });

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    10 +
                30 +
                widget.yOffset));
      }

//      print('${widget.size.height} ${animationController.value / 2}');
//      if (widget.size.height > maxHeight / 2) {
//        if (!animationColorController.isAnimating) {
//          print('GOOOOOD');
//
//          animationColorController.forward();
//        }
//      }
    });

//    animationController.addStatusListener((AnimationStatus status) {});

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    animationColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.bottomCenter,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: new Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
//            decoration: BoxDecoration(
//              color: animationColor.value,
//              borderRadius: BorderRadius.circular(8.0),
//            ),
          ),
          clipper: new WaveClipper(animationColorController.value, animList1),
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
