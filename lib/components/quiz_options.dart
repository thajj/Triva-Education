import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/models/category.dart';
import 'package:quiz/models/question.dart';
import 'package:quiz/models/setting.dart';
import 'package:quiz/pages/quizz_page.dart';
import 'package:scoped_model/scoped_model.dart';

const String baseUrl = "https://opentdb.com/api.php";

Future<List<Question>> getQuestions(
    Category category, int total, String difficulty) async {
  String url = "$baseUrl?amount=$total&category=${category.id}";
  if (difficulty != null) {
    url = "$url&difficulty=$difficulty";
  }
  http.Response res = await http.get(url);
  List<Map<String, dynamic>> questions =
      List<Map<String, dynamic>>.from(json.decode(res.body)["results"]);
  return Question.fromData(questions);
}

//

class QuizOptionsDialog extends StatefulWidget {
  final Category category;

  const QuizOptionsDialog({Key key, this.category}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int _noOfQuestions;
  String _difficulty;
  bool processing;

  @override
  void initState() {
    super.initState();
    _noOfQuestions = 10;
    _difficulty = "easy";
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(
              widget.category.name,
              style: Theme.of(context).textTheme.title.copyWith(),
            ),
          ),
          SizedBox(height: 10.0),
          Text("How many questions?"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("10"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 10
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(10),
                ),
                ActionChip(
                  label: Text("20"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 20
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(20),
                ),
                ActionChip(
                  label: Text("30"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 30
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(30),
                ),
                ActionChip(
                  label: Text("40"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 40
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(40),
                ),
                ActionChip(
                  label: Text("50"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 50
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(50),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text("Select difficulty"),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(width: 0.0),
                ActionChip(
                  label: Text("Random"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == null
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty(null),
                ),
                ActionChip(
                  label: Text("Easy"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "easy"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("easy"),
                ),
                ActionChip(
                  label: Text("Medium"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "medium"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("medium"),
                ),
                ActionChip(
                  label: Text("Hard"),
                  labelStyle: TextStyle(color: Colors.white),
                  backgroundColor: _difficulty == "hard"
                      ? Colors.indigo
                      : Colors.grey.shade600,
                  onPressed: () => _selectDifficulty("hard"),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          processing
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text("START"),
                  onPressed: _startQuiz,
                ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i) {
    setState(() {
      _noOfQuestions = i;
    });
  }

  _selectDifficulty(String s) {
    setState(() {
      _difficulty = s;
    });
  }

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      List<Question> questions =
          await getQuestions(widget.category, _noOfQuestions, _difficulty);
      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScopedModelDescendant<Setting>(
            builder: (context, child, model) {
              return QuizPage(
                questions: questions,
                category: widget.category,
                setting: model,
              );
            },
          ),
        ),
      );
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message:
                        "Can't reach the servers, \n Please check your internet connection.",
                  )));
    } catch (e) {
      print(e.message);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message: "Unexpected error trying to connect to the API",
                  )));
    }
    setState(() {
      processing = false;
    });
  }
}

//

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key key, this.message = "There was an unknown error."})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      child: Text("Try Again"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
