import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:quiz/models/setting.dart';
import 'package:xlive_switch/xlive_switch.dart';

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
        title: Text('Settings'),
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
            child: SettingContent(widget.setting),
          ),
        ],
      ),
    );
  }
}

class SettingContent extends StatelessWidget {
  final Setting setting;

  SettingContent(this.setting);

//  Widget _buildDivider() {
//    return Container(
//      margin: const EdgeInsets.symmetric(
//        horizontal: 8.0,
//      ),
//      width: double.infinity,
//      height: 1.0,
//      color: Colors.grey.shade300,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 4, right: 4),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Sound effects"),
              XlivSwitch(
                value: this.setting.sound,
                onChanged: (bool value) {
                  this.setting.sound = value;
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Vibrations"),
              XlivSwitch(
                value: this.setting.vibration,
                onChanged: (bool value) {
                  this.setting.vibration = value;
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Show correct answers"),
              XlivSwitch(
                value: this.setting.showAnswer,
                onChanged: (bool value) {
                  this.setting.showAnswer = value;
                },
              ),
            ],
          ),
//        SwitchListTile(
//          activeColor: Colors.purple,
//          title: Text("Sound effects"),
//          value: this.setting.sound,
//          onChanged: (bool value) {
//            this.setting.sound = value;
//          },
//        ),
//        _buildDivider(),
//        SwitchListTile(
//          activeColor: Colors.purple,
//          title: Text("Vibrations"),
//          value: this.setting.vibration,
//          onChanged: (bool value) {
//            this.setting.vibration = value;
//          },
//        ),
//        _buildDivider(),
//        SwitchListTile(
//          activeColor: Colors.purple,
//          title: Text("Interactive answers"),
//          value: this.setting.showAnswer,
//          onChanged: (bool value) {
//            this.setting.showAnswer = value;
//          },
//        ),
        ],
      ),
    );
  }
}
