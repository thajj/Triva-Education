import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:quiz/pages/start/start_details_page.dart';

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
  AnimationController _controller;
  AnimationController _loginButtonController;

  int _animationStatus = 0;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _controller.forward();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);

    _loginButtonController.addListener(() {
      if (_loginButtonController.isCompleted) {
//        Navigator.pushReplacementNamed(context, '/home');
        Navigator.pushNamed(context, "/home");
      }
    });
  }

  Future<Null> _onPlay() async {
    setState(() {
      _animationStatus = 1;
    });
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
    await AudioCache().play(Constants().btnTap);
  }

  @override
  void dispose() {
    _controller.dispose();
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return StartDetailsPage(
      controller: _controller,
      loginButtonController: _loginButtonController,
      animationStatus: _animationStatus,
      onPlay: _onPlay,
    );
  }
}
