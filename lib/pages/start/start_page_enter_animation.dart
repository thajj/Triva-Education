import 'package:flutter/material.dart';

class StartDetailsPageEnterAnimation {
  StartDetailsPageEnterAnimation(this.controller)
      : logoYTranslation = new Tween(begin: 0.0, end: 200.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.250,
              curve: Curves.easeIn,
            ),
          ),
        ),
        appNameSize = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.300,
              0.500,
              curve: Curves.elasticOut,
            ),
          ),
        ),
        btnLogginOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.500,
              0.900,
              curve: Curves.easeIn,
            ),
          ),
        ),

        ///
        backdropBlur = new Tween(begin: 0.0, end: 5.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.000,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        nameOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.350,
              0.450,
              curve: Curves.easeIn,
            ),
          ),
        ),
        locationOpacity = new Tween(begin: 0.0, end: 0.85).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.500,
              0.600,
              curve: Curves.easeIn,
            ),
          ),
        ),
        dividerWidth = new Tween(begin: 0.0, end: 225.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.650,
              0.750,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        ),
        biographyOpacity = new Tween(begin: 0.0, end: 0.85).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.750,
              0.900,
              curve: Curves.easeIn,
            ),
          ),
        ),
        videoScrollerXTranslation = new Tween(begin: 60.0, end: 0.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.830,
              1.000,
              curve: Curves.ease,
            ),
          ),
        ),
        videoScrollerOpacity = new Tween(begin: 0.0, end: 1.0).animate(
          new CurvedAnimation(
            parent: controller,
            curve: new Interval(
              0.830,
              1.000,
              curve: Curves.fastOutSlowIn,
            ),
          ),
        );

  final AnimationController controller;
  final Animation<double> btnLogginOpacity;
  final Animation<double> backdropBlur;
  final Animation<double> appNameSize;
  final Animation<double> nameOpacity;
  final Animation<double> locationOpacity;
  final Animation<double> dividerWidth;
  final Animation<double> biographyOpacity;
  final Animation<double> videoScrollerXTranslation;
  final Animation<double> logoYTranslation;
  final Animation<double> videoScrollerOpacity;
}
