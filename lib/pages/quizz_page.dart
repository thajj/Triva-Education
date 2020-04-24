import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/components/count_down_timer.dart';
import 'package:quiz/models/category.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/setting.dart';
import 'package:quiz/pages/quizz_finished.dart';
import 'package:quiz/pages/timer/wave_animation.dart';
import 'package:vibration/vibration.dart';

import '../constants.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;
  final Setting setting;

  const QuizPage(
      {Key key, @required this.questions, this.category, this.setting})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
//  GlobalKey<CountDownClipperState> _countDownClipperKey = GlobalKey();

//  GlobalKey<CountDownTimerState> _countDownTimerKey = GlobalKey();
//  GlobalKey<DemoBodyState> _waveAnimationKey = GlobalKey();

  final TextStyle _questionStyle = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  static const delay = Duration(microseconds: 1);
  String timeText = '';

  CountDownTimer _countDownTimer;
  DemoBody _waveAnimation;

  /// for animation
  var begin = 0.0;
  Animation<double> heightSize;
  AnimationController _controller;
  AnimationController _waveController;

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  bool _isButtonTapped = false;
  bool _isTimeout = false;
  int _currentIndex = 0;

  final Map<int, dynamic> _answers = {};

  /// Called each time the time is ticking
  void updateClock() {
    //TODO : not sure if it's the best
    if (!_controller.isAnimating) {
      return;
    }

    final duration = Duration(hours: 0, minutes: 0, seconds: 10);

    // if time is up, stop the timer
//    print('${stopwatch.elapsed.inMilliseconds} == ${duration.inMilliseconds}');
    if (stopwatch.elapsed.inMilliseconds == duration.inMilliseconds) {
      print('--finished Timer Page--');
      stopwatch.stop();
      stopwatch.reset();
      _controller.stop(canceled: false);
      _timeout();
      return;
    }

    final millisecondsRemaining =
        duration.inMilliseconds - stopwatch.elapsed.inMilliseconds;
//    final hoursRemaining =
//        ((millisecondsRemaining / (1000 * 60 * 60)) % 24).toInt();
//    final minutesRemaining =
//        ((millisecondsRemaining / (1000 * 60)) % 60).toInt();
    final secondsRemaining = ((millisecondsRemaining / 1000) % 60).toInt();

    setState(() {
//      timeText = '${hoursRemaining.toString().padLeft(2, '0')}:'
//          '${minutesRemaining.toString().padLeft(2, '0')}:'
//          '${secondsRemaining.toString().padLeft(2, '0')}';

      //timeText = '${secondsRemaining.toString().padLeft(2, '0')}';
      timeText = '${secondsRemaining.toString()}';
    });

    if (stopwatch.isRunning) {
      //running

    } else if (stopwatch.elapsed.inSeconds == 0) {
      //FIXME to validate when it occurs
      print('--------------------------');
      print(stopwatch.elapsed.inSeconds);
      setState(() {
//        timeText = '10';
        stopwatch.stop();
        _controller.stop(canceled: false);
      });
      //_timeout();
    } else {
      //PAUSED

    }
  }

  initQuizz() {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache();

    setState(() {
      _isTimeout = false;
      _isButtonTapped = false;
    });

    final duration = Duration(days: 0, hours: 0, minutes: 0, seconds: 10);
    _controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    _waveController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    timer = Timer.periodic(delay, (Timer t) => updateClock());

    _startCountDown();

//    List<Offset> animList1 = [];
//    _waveController.addListener(() {
//      animList1.clear();
//      for (int i = -2 - widget.xOffset;
//          i <= widget.size.width.toInt() + 2;
//          i++) {
//        animList1.add(new Offset(
//            i.toDouble() + widget.xOffset,
//            sin((animationController.value * 360 - i) %
//                        360 *
//                        Vector.degrees2Radians) *
//                    10 +
//                30 +
//                widget.yOffset));
//      }
    _waveController.repeat();
  }

  @override
  void initState() {
    super.initState();
    initQuizz();
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    stopwatch.stop();
    timer.cancel();
    audioPlayer = null;
    super.dispose();
  }

  void _startCountDown() {
    stopwatch.start();
    stopwatch.reset();
    _controller.reset();
    _controller.forward();

//    _countDownClipperKey.currentState.reset();
//    _countDownClipperKey.currentState.start();

    //FIXME: currentState is null
//    if (_countDownTimerKey.currentState != null) {
//      _countDownTimerKey.currentState.reset();
//      _countDownTimerKey.currentState.start();
//    }

//    print('START COUNTDOWN');
//    if (_waveAnimationKey.currentState != null) {
//      _waveAnimationKey.currentState.reset();
//      _waveAnimationKey.currentState.start();
//    }
  }

  void _restartCountDown() {
    begin = 0.0;
    _controller.reset();
    stopwatch.stop();
    stopwatch.reset();
  }

  void _pauseTimers() {
//    _countDownClipperKey.currentState.stop();
//    _countDownTimerKey.currentState.pause();
//    _waveAnimationKey.currentState.pause();

    _controller.stop(canceled: false);
    stopwatch.stop();
  }

  void _resumeTimer() {
//    _countDownClipperKey.currentState.start();
//    _countDownTimerKey.currentState.start();
//    _waveAnimationKey.currentState.start();

    begin = 50.0;
    stopwatch.start();
    _controller.forward();
  }

  void _timeout() {
    setState(() {
      _isTimeout = true;
    });

    if (widget.setting.vibration) {
      Vibration.vibrate();
    }

    if (widget.setting.sound) {
      _playIncorrect();
    }

    Timer(Duration(milliseconds: 1500), () {
      _nextQuestion();
      setState(() {
        _isTimeout = false;
      });
    });
  }

  void _handleAnswerClick(option) {
    //print('Answer => ${option}');
    bool correct = false;

    setState(() {
      _isButtonTapped = true;
      _answers[_currentIndex] = option;
    });

    Question question = widget.questions[_currentIndex];

    _pauseTimers();

    if (widget.setting.showAnswer) {
      //if timeout
      if (_answers[_currentIndex] == null) {
        print('show timeout answer');
      }
      //if tapped and correct
      else if (question.correctAnswer == _answers[_currentIndex]) {
        if (widget.setting.sound) {
          _playCorrect();
        }
        correct = true;
      }
      //if tapped and incorrect
      else {
        if (widget.setting.vibration) {
          Vibration.vibrate();
        }
        if (widget.setting.sound) {
          _playIncorrect();
        }
      }

      //TODO: add incorrect sound
    }

    Timer(Duration(milliseconds: correct ? 1000 : 1500), () {
      _nextQuestion();
    });
  }

  Color btnColorState(answer) {
    Question question = widget.questions[_currentIndex];

    if (_isTimeout) {
      if (question.correctAnswer == answer) {
        //TOOD : show green a lttle bit later
        return Colors.green;
      } else {
        return Colors.white;
      }
    }

    //Not answered yet (before timeout )
    if (_answers[_currentIndex] == null) {
      //if timeout ww will show the correct answer
      return Colors.white;
    }

    //if correct
    if (question.correctAnswer == _answers[_currentIndex]) {
      if (answer == _answers[_currentIndex]) {
        return Colors.green;
      }
      return Colors.white;
    }
    //incorrect case
    else {
      if (answer == _answers[_currentIndex]) {
        return Colors.red;
      } else if (answer == question.correctAnswer) {
        return Colors.green;
      } else {
        return Colors.white;
      }
    }
  }

  void _nextQuestion() {
    //SHOULD NEVER OCCUR...
//    if (_answers[_currentIndex] == null) {
//      _key.currentState.showSnackBar(SnackBar(
//        content: Text("You must select an answer to continue."),
//      ));
//      return;
//    }

    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
        _isButtonTapped = false;
      });

      _startCountDown();
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future _playCorrect() async {
    await AudioCache().play(Constants().correctSound);
  }

  Future _playIncorrect() async {
    await AudioCache().play(Constants().incorrectSound);
  }

  Future<bool> _onWillPop() async {
    _pauseTimers();

    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
                onWillPop: () {
                  return Future.value(true);
                },
                child: Material(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 120),
                  color: Colors.pink,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 60),
                        child: Text(
                          "PAUSE",
                          style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 90.0,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white,
                            child: Text(
                              "Resume",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                              _resumeTimer();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 90.0,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white,
                            child: Text(
                              "Exit",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1;

    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    heightSize =
        new Tween(begin: begin, end: MediaQuery.of(context).size.height - 65)
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Size size = Size(MediaQuery.of(context).size.width, heightSize.value);

    //FIXME: temp patch because the color controller still exist
    _waveAnimation = DemoBody(
      controller: _controller,
      waveController: _waveController,
      size: size,
    );

    _countDownTimer = CountDownTimer(
//      key: GlobalKey<CountDownTimerState>(),
      text: timeText,
//      duration: Duration(seconds: 9),
      controller: _controller,
//      onComplete: () {
//        print('OKOKOK');
//      },
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          centerTitle: true,
//          title: Text(widget.category.name,
//              style: TextStyle(
//                fontSize: 20.0,
//              )),
          title: Text('${_currentIndex + 1} / ${widget.questions.length}',
              style: TextStyle(
                fontSize: 20.0,
              )),
          elevation: 4,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 4),
              child: _countDownTimer,
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return _waveAnimation;
                },
              ),
//              DemoBody(size: size, color: Colors.pink),
//              Visibility(
//                visible: true,
//                child: CountDownClipper(
//                    key: _countDownClipperKey,
//                    maxHeight: MediaQuery.of(context).size.height),
//              ),
              Positioned(
                width: constraints.maxWidth,
                height: constraints.maxHeight / 3,
                top: 0,
                child: Container(
//                  color: Colors.red,
                  padding:
                      EdgeInsets.only(top: 20, bottom: 0, left: 12, right: 12),
                  child: Text(
                    HtmlUnescape()
                        .convert(widget.questions[_currentIndex].question),
                    softWrap: true,
                    style: _questionStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                width: constraints.maxWidth,
                height: constraints.maxHeight / 3 * 2,
                top: constraints.maxHeight / 3,
                child: Container(
                    padding: EdgeInsets.only(bottom: 12),
//                    color: Colors.black,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...options.map((option) => SizedBox(
                                  width: double.infinity,
                                  height: 78.0,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: RaisedButton(
                                      color: widget.setting.showAnswer
                                          ? btnColorState(option)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        HtmlUnescape().convert("$option"),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () => _isButtonTapped
                                          ? null
                                          : _handleAnswerClick(option),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
