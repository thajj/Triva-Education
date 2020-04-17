import 'package:flutter/material.dart';
import 'package:quiz/components/exhibition_bottom_sheet.dart';
import 'package:quiz/components/sliding_cards.dart';
import 'package:share/share.dart';

import '../constants.dart';

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(12.0),
                  height: 160.0,
                  child: Image.asset(
                    "assets/logo.png",
                    width: 80.0,
                    height: 80.0,
                  ),
                ),
                Text(
                  "TRIVA - Special ÉDUCATION",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0),
                ),
                SizedBox(height: 8),
                Text(
                  "Choisi ton parcours!",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
//                SizedBox(height: 8),
//                Header(),
//                SizedBox(height: 80),
//                Tabs(),
                SizedBox(height: 42),
                SlidingCardsView(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.blue,
                          ),
                          Text(
                            "Share",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () => Share.share(Constants().shareText),
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          Text(
                            "Rate Us",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
//                      onPressed: _launchURL,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExhibitionBottomSheet(), //use this or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'Trivia - Éducation',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
