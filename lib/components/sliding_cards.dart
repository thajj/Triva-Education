import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quiz/pages/quiz.dart';
import 'package:quiz/pages/topics.dart';

import '../constants.dart';

class SlidingCardsView extends StatefulWidget {
  @override
  _SlidingCardsViewState createState() => _SlidingCardsViewState();
}

class _SlidingCardsViewState extends State<SlidingCardsView> {
  PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.43,
      child: PageView(
        controller: pageController,
        children: <Widget>[
          SlidingCard(
            name: 'PRÉSCOLAIRE',
            date: '10 catégories',
            assetName: 'level_1.jpg',
            offset: pageOffset,
            onClick: () {
              final url = Constants().apiURL +
                  "api/questions?limit=" +
                  Constants().defaultCount.toString();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(url),
                ),
              );
            },
          ),
          SlidingCard(
            name: 'Primaire',
            date: '10 catégories',
            assetName: 'level_2.jpg',
            offset: pageOffset,
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicPage('level_2'),
                ),
              );
            },
          ),
          SlidingCard(
            name: 'Secondaire',
            date: '10 catégories',
            assetName: 'level_3.jpg',
            offset: pageOffset,
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicPage('level_3'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String date;
  final String assetName;
  final double offset;
  final Function onClick;

  const SlidingCard({
    Key key,
    @required this.name,
    @required this.date,
    @required this.assetName,
    @required this.offset,
    @required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
      offset: Offset(-32 * gauss * offset.sign, 0),
      child: Card(
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 24),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: Image.asset(
                'assets/$assetName',
                height: MediaQuery.of(context).size.height * 0.3,
                alignment: Alignment(-offset.abs(), 0),
                fit: BoxFit.none,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: CardContent(
                name: name,
                date: date,
                offset: gauss,
                onClick: onClick,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String date;
  final double offset;
  final Function onClick;

  const CardContent(
      {Key key,
      @required this.name,
      @required this.date,
      @required this.offset,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Transform.translate(
                  offset: Offset(8 * offset, 0),
                  child: Text(name, style: TextStyle(fontSize: 20)),
                ),
                SizedBox(height: 8),
                Transform.translate(
                  offset: Offset(32 * offset, 0),
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Spacer(),
            Transform.translate(
              offset: Offset(48 * offset, 0),
              child: RaisedButton(
                color: Color(0xFF162A49),
                child: Transform.translate(
                  offset: Offset(24 * offset, 0),
                  child: Text('START'),
                ),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onPressed: () {
                  onClick();
                },
              ),
            ),
          ],
        ));
  }

  Widget build2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(name, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(24 * offset, 0),
                    child: Text('START'),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {
                    onClick();
                  },
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(32 * offset, 0),
                child: Text(
                  '0.00 \$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}
