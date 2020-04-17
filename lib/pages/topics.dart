import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/constants.dart';
import 'package:quiz/pages/quiz.dart';

class Topic {
  String id;
  String name;
  String level;
  String image;

  Topic(this.id, this.name, this.level, this.image);

  factory Topic.fromJson(dynamic json) {
    return Topic(json['id'] as String, json['name'] as String,
        json['level'] as String, json['image'] as String);
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.name}, ${this.level}, ${this.image} }';
  }
}

class TopicPage extends StatefulWidget {
  String level;
  TopicPage(level) {
    this.level = level;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TopicPageState(level);
  }
}

class _TopicPageState extends State<TopicPage> {
  String level;
  List topics = [];

  _TopicPageState(String level) {
    this.level = level;
  }

  //TODO: replace the settings and fetch the category new api method (filter by level?)
  //TODO:
  _fetchTopics() async {
    //TODO: quick patch was looping
    if (this.topics != null && this.topics.length != 0) return;

    print('dsd');
    String url = Constants().apiURL + "api/categories";
    if (this.level != null) {
      url = url + "?level=" + this.level;
    }

    final response = await http.get(url);
    if (response.statusCode == 200) {
//      final settings = json.decode(response.body);
//      topics = settings['categorylist'] as List;

/*
[
  {"id":3,"name":"Lettres et alphabet","level":"level_2","image":null,"created_at":"2020-04-05 15:02:21","updated_at":"2020-04-05 15:02:21"},
  {"id":8,"name":"kkkkl","level":"level_2","image":null,"created_at":"2020-04-05 15:24:48","updated_at":"2020-04-05 15:31:53"}
]
*/
      topics = List.from(jsonDecode(response.body));
//      List<Topic> topics =
//          topicList.map((topicJson) => Topic.fromJson(topicJson)).toList();
//      topics = json.decode(jsonDecode(response.body)) as List;
////      print(topics);
//
      setState(() {
        topics = topics;
      });
    } else {
      print("Failed");
      throw Exception('Failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _fetchTopics();
    print('test');

    return Scaffold(
      backgroundColor: Color(0xff142850),
      appBar: AppBar(
        title: Text("Topics"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20.0),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Color(0xff193469),
                ),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      topics[index]['name'],
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white70,
                    )
                  ],
                )),
            onTap: () {
              final url = Constants().apiURL +
                  "api/questions?limit=" +
                  Constants().defaultCount.toString() +
                  "&t_name=" +
                  topics[index]['name'];

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizPage(url)),
              );
            },
          );
        },
      ),
    );
  }
}
