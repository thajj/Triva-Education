import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:quiz/models/question.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersPage(
      {Key key, @required this.questions, @required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Quizz answers'),
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
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return RaisedButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        },
      );
    }
    Question question = questions[index];
    bool correct = question.correctAnswer == answers[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(question.question),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
//            Row(children: <Widget>[
//              correct
//                  ? Icon(
//                      Icons.check,
//                      color: Colors.green,
//                    )
//                  : Icon(
//                      Icons.close,
//                      color: Colors.red,
//                    ),
//              Visibility(
//                  visible: answers[index] != null,
//                  child: Text(
//                    HtmlUnescape().convert("${answers[index]}"),
//                    style: TextStyle(
//                        color: correct ? Colors.green : Colors.red,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold),
//                  )),
//            ]),
            Visibility(
                visible: answers[index] != null,
                child: Text(
                  HtmlUnescape().convert("${answers[index]}"),
                  style: TextStyle(
                      color: correct ? Colors.green : Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                )),

            SizedBox(height: 5.0),
            correct
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "Réponse: "),
                      TextSpan(
                          text: HtmlUnescape().convert(question.correctAnswer),
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
