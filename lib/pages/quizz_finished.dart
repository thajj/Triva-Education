import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz/models/question.dart';

import 'check_answers.dart';

class QuizFinishedPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  int correctAnswers;
  QuizFinishedPage({Key key, @required this.questions, @required this.answers})
      : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    int correct = 0;
    this.answers.forEach((index, value) {
      if (this.questions[index].correctAnswer == value) correct++;
    });
    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Result'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 200,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text("Number of questions", style: titleStyle),
                    trailing: Text("${questions.length}", style: trailingStyle),
                  ),
                ),
                SizedBox(height: 10.0),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text("Score", style: titleStyle),
                    trailing: Text(
                        "${(correct / questions.length * 100).toInt()}%",
                        style: trailingStyle),
                  ),
                ),
                SizedBox(height: 10.0),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text("Correct answers", style: titleStyle),
                    trailing: Text("$correct/${questions.length}",
                        style: trailingStyle),
                  ),
                ),
                SizedBox(height: 10.0),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text("Incorrect answers", style: titleStyle),
                    trailing: Text(
                        "${questions.length - correct}/${questions.length}",
                        style: trailingStyle),
                  ),
                ),
                SizedBox(height: 20.0),
                Align(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    RaisedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Verify answers",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => CheckAnswersPage(
                                  questions: questions,
                                  answers: answers,
                                )));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
