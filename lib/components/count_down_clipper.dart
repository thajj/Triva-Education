import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CountDownClipper extends StatefulWidget {
  final double maxHeight;
  final Key key;

  const CountDownClipper({this.key, this.maxHeight}) : super(key: key);

  @override
  CountDownClipperState createState() => CountDownClipperState();
}

class CountDownClipperState extends State<CountDownClipper>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

//  GlobalKey<CountDownClipperState> _key = GlobalKey<CountDownClipperState>();

//  String get timerString {
//    Duration duration = controller.duration * controller.value;
//    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    animation =
        Tween<double>(begin: 200, end: widget.maxHeight).animate(controller);
    //WITH EASING
//    animation = Tween<double>(begin: 200, end: widget.maxHeight).animate(
//      CurvedAnimation(
//        parent: controller,
//        curve: Curves.easeOut,
//      ),
//    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void start() {
    controller.forward(from: controller.value == 1.0 ? 0.0 : controller.value);
  }

  void reset() {
    controller.reset();
  }

  void stop() {
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    height: animation.value != null ? animation.value : 200,
                  ),
                ),
//                Align(
//                  alignment: Alignment.bottomCenter,
//                  child: Container(
//                    padding: EdgeInsets.only(top: 400),
//                    color: Colors.amber,
//                    height:
//                        controller.value * MediaQuery.of(context).size.height,
//                  ),
//                ),
              ],
            );
          }),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
