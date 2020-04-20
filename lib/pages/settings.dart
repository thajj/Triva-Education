import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz/models/setting.dart';

class SettingsPage extends StatefulWidget {
  final Setting setting;

  const SettingsPage({Key key, this.setting}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  static final String path = "lib/src/pages/settings/settings3.dart";

  final TextStyle headerStyle = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

//  bool _sound = true;
//  bool _vibration = true;
//  bool _displayCorrectAnswer = true;

  @override
  void initState() {
    super.initState();
//    restore();
  }

//  restore() async {
//    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//    setState(() {
//      _sound = (sharedPrefs.getBool('sound') ?? true);
//      _vibration = (sharedPrefs.getBool('vibration') ?? true);
//      _displayCorrectAnswer =
//          (sharedPrefs.getBool('displayCorrectAnswer') ?? true);
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    Setting setting = ScopedModel.of<Setting>(context, rebuildOnChange: false);
//    bool sound = ScopedModel.of<Setting>(context, rebuildOnChange: false).sound;

//    print('SOUND ${sound}');

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Paramètres'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 0,
                  ),
                  child: Column(
                    children: <Widget>[
                      SwitchListTile(
                        activeColor: Colors.purple,
                        title: Text("Sons"),
                        value: widget.setting.sound,
                        onChanged: (bool value) {
                          widget.setting.sound = value;
                        },
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        title: Text("Vibrations"),
                        value: widget.setting.vibration,
                        onChanged: (bool value) {
                          widget.setting.vibration = value;
                        },
                      ),
                      _buildDivider(),
                      SwitchListTile(
                        activeColor: Colors.purple,
                        title: Text(
                            "Afficher les réponses correctes pendant la partie"),
                        value: widget.setting.showAnswer,
                        onChanged: (bool value) {
                          widget.setting.showAnswer = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
