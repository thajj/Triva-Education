import 'package:line_awesome_icons/line_awesome_icons.dart';

class Category {
  final int id;
  final String name;
  final dynamic icon;
  Category(this.id, this.name, {this.icon});
}

final List<Category> categories = [
  Category(9, "General Knowledge", icon: LineAwesomeIcons.globe),
  Category(10, "Books", icon: LineAwesomeIcons.book),
  Category(11, "Film", icon: LineAwesomeIcons.camera),
  Category(12, "Music", icon: LineAwesomeIcons.music),
//  Category(13, "Musicals & Theatres", icon: LineAwesomeIcons.theaterMasks),
  Category(14, "Television", icon: LineAwesomeIcons.tv),
  Category(15, "Video Games", icon: LineAwesomeIcons.gamepad),
  Category(16, "Board Games"),
  Category(17, "Science & Nature", icon: LineAwesomeIcons.flask),
  Category(18, "Computer", icon: LineAwesomeIcons.laptop),
  Category(19, "Maths", icon: LineAwesomeIcons.calculator),
  Category(20, "Mythology"),
  Category(21, "Sports", icon: LineAwesomeIcons.soccer_ball_o),
  Category(22, "Geography"),
  Category(23, "History", icon: LineAwesomeIcons.history),
  Category(24, "Politics"),
//  Category(25, "Art", icon: LineAwesomeIcons.paintBrush),
  Category(26, "Celebrities", icon: LineAwesomeIcons.user),
  Category(
    27,
    "Animals",
  ),
  Category(28, "Vehicles", icon: LineAwesomeIcons.car),
  Category(29, "Comics"),
//  Category(30, "Science Gadgets", icon: LineAwesomeIcons.mobileAlt),
  Category(31, "Japanese Anime & Manga"),
  Category(32, "Cartoon & Animation"),
];
