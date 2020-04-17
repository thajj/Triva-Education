import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/components/count_down_clipper.dart';
import 'package:quiz/components/count_down_timer.dart';
import 'package:quiz/models/category.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/pages/quizz_finished.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Category category;

  const QuizPage({Key key, @required this.questions, this.category})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  GlobalKey<CountDownClipperState> _countDownClipperKey = GlobalKey();
  GlobalKey<CountDownTimerState> _countDownTimerKey = GlobalKey();

  final TextStyle _questionStyle = TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white);

  final String correctSound = 'sounds/correct.mp3';
  final String incorrectSound = 'sounds/incorrect.mp3';

  AudioPlayer audioPlayer;
  AudioCache audioCache;

  bool _isButtonTapped = false;
  bool _isTimeout = false;
  bool _sound = false;
  bool _vibration = false;
  bool _showAnswer = false;
  int _currentIndex = 0;

  final Map<int, dynamic> _answers = {};

  CountDownTimer _countDownTimer;

  initQuizz() async {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache();

    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _isTimeout = false;
      _sound = (sharedPrefs.getBool('sound') ?? true);
      _vibration = (sharedPrefs.getBool('vibration') ?? true);
      _showAnswer = (sharedPrefs.getBool('displayCorrectAnswer') ?? true);
      _isButtonTapped = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initQuizz();
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

    _countDownTimer = CountDownTimer(
      key: _countDownTimerKey,
      onComplete: _timeout,
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: Text(widget.category.name,
              style: TextStyle(
                fontSize: 20.0,
              )),
          elevation: 10,
          actions: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 4),
                child: _countDownTimer),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Visibility(
              visible: true,
              child: CountDownClipper(
                  key: _countDownClipperKey,
                  maxHeight: MediaQuery.of(context).size.height),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          HtmlUnescape().convert(
                              widget.questions[_currentIndex].question),
                          softWrap: true,
                          style: _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  _currentIndex % 2 == 0
                      ? Container()
                      : Image.network(
                          "https://duckduckgo.com/i/3a758bd3.jpg",
                          height: 200.0,
                        ),
                  new Expanded(
                    child: new Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ...options.map((option) => SizedBox(
                                width: double.infinity,
                                height: 90.0,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: RaisedButton(
                                    color: _showAnswer
                                        ? btnColorState(option)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _timeout() {
    setState(() {
      _isTimeout = true;
    });

    if (_vibration) {
      Vibration.vibrate();
    }

    if (_sound) {
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

    _countDownClipperKey.currentState.stop();
    _countDownTimerKey.currentState.stop();

    if (_showAnswer) {
      //if timeout
      if (_answers[_currentIndex] == null) {
        print('show timeout answer');
      }
      //if tapped and correct
      else if (question.correctAnswer == _answers[_currentIndex]) {
        if (_sound) {
          _playCorrect();
        }
        correct = true;
      }
      //if tapped and incorrect
      else {
        if (_vibration) {
          Vibration.vibrate();
        }
        if (_sound) {
          _playIncorrect();
        }
      }

      //TODO: add incorrect sound
    }

    Timer(Duration(milliseconds: correct ? 1000 : 1500), () {
      _nextQuestion();
    });
  }

  btnColorState(answer) {
    Question question = widget.questions[_currentIndex];

    if (_isTimeout) {
      if (question.correctAnswer == answer) {
        return Colors.green;
      } else {
        return Colors.white;
      }
    }

    //Not answered yet (before timeout)
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

      _countDownClipperKey.currentState.reset();
      _countDownTimerKey.currentState.reset();
      _countDownClipperKey.currentState.start();
      _countDownTimerKey.currentState.start();
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => QuizFinishedPage(
              questions: widget.questions, answers: _answers)));
    }
  }

  Future _playCorrect() async {
    await AudioCache().play(correctSound);
  }

  Future _playIncorrect() async {
    await AudioCache().play(incorrectSound);
  }

  Future<bool> _onWillPop() async {
    _pauseQuizz();

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
                              "Continuer",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                              _resumeQuizz();
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
                              "Quitter",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ),
                      ),
                      //            SizedBox(
                      //              height: 10,
                      //            ),
                      //            SizedBox(
                      //              width: double.infinity,
                      //              height: 90.0,
                      //              child: Padding(
                      //                padding: EdgeInsets.only(bottom: 16),
                      //                child: RaisedButton(
                      //                  shape: RoundedRectangleBorder(
                      //                    borderRadius: BorderRadius.circular(10.0),
                      //                  ),
                      //                  color: Colors.white,
                      //                  child: Text(
                      //                    "TEST TIMER..",
                      //                    style: TextStyle(fontSize: 20),
                      //                  ),
                      //                  onPressed: () => Navigator.push(
                      //                    context,
                      //                    MaterialPageRoute(
                      //                        builder: (context) => CountDownTimer(() => {})),
                      //                  ),
                      //                ),
                      //              ),
                      //            ),
                    ],
                  ),
                )));
          },
        );
      },
    );

//    return showDialog<bool>(
//        context: context,
//        builder: (_) {
//          return AlertDialog(
//            content: Text(
//                "Étes-vous certain de vouloir quitter? Votre progression sera perdue."),
////                "Are you sure you want to quit the quiz? All your progress will be lost."),
//            title: Text("Attention!"),
//            actions: <Widget>[
//              FlatButton(
//                child: Text("Oui"),
//                onPressed: () {
//                  Navigator.pop(context, true);
//                },
//              ),
//              FlatButton(
//                child: Text("Non"),
//                onPressed: () {
//                  Navigator.pop(context, false);
//                },
//              ),
//            ],
//          );
//        });
  }

  _pauseQuizz() {
    _countDownClipperKey.currentState.stop();
    _countDownTimerKey.currentState.stop();
  }

  _resumeQuizz() {
    _countDownClipperKey.currentState.start();
    _countDownTimerKey.currentState.start();
  }
}
