import 'package:flutter/material.dart';

class StartDetailsPageEnterAnimation {
  StartDetailsPageEnterAnimation(this.controller)
      : logoYTranslation = new Tween(begin: 0.0, end: 200.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.250,
              curve: Curves.elasticInOut,
            ),
          ),
        ),
        appNameSize = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.300,
              0.400,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        appNameSize2 = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.300,
              0.500,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        btnPlaySize = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.550,
              0.700,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        btnSettingSize = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.800,
              0.900,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        btnStatSize = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.850,
              0.950,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        btnTrophySize = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.900,
              1.0,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        particleOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.850,
              0.900,
              curve: Curves.easeIn,
            ),
          ),
        );

  final AnimationController controller;
  final Animation<double> btnPlaySize;
  final Animation<double> appNameSize;
  final Animation<double> appNameSize2;
  final Animation<double> btnSettingSize;
  final Animation<double> btnStatSize;
  final Animation<double> btnTrophySize;
  final Animation<double> logoYTranslation;
  final Animation<double> particleOpacity;
}
