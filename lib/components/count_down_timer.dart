import 'dart:math' as math;

import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final Key key;
  final Function onComplete;
  final Duration duration;

  CountDownTimer({this.key, this.duration, this.onComplete}) : super(key: key);

  @override
  CountDownTimerState createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  AnimationController controller;
  Function listener;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${(duration.inSeconds).toString()}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    )..addListener(() {
        this.setState(() {});
      });

//    print('duration ${widget.duration}');

    listener = (status) {
      if (status == AnimationStatus.dismissed) {
        print('TIMEOUT');
        controller.removeStatusListener(listener);
        controller.stop();
        widget.onComplete();
      }
    };

//    start();
  }

  @override
  void dispose() {
    print('DISPOSE');
    controller.removeStatusListener(listener);
    controller.dispose();
    super.dispose();
  }

  Future<Null> start() async {
    print('START');
    controller.addStatusListener(listener);
    try {
//      await controller.forward();
      await controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    } on TickerCanceled {}
  }

  void reset() async {
    print('RESET');
    controller.removeStatusListener(listener);
    controller.reset();
  }

  void pause() async {
    print('PAUSE');
    controller.removeStatusListener(listener);
    controller.stop();
  }

  void stop() {
    print('STOP');
  }

  @override
  Widget build(BuildContext context) {
//    ThemeData themeData = Theme.of(context);
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(
                          painter: CustomTimerPainter(
                        animation: controller,
                        backgroundColor: Colors.white,
                        color: Colors.pinkAccent,
                      )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        timerString,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
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
      ..strokeWidth = 5.0
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
