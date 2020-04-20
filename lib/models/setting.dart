import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends Model {
  static Setting of(BuildContext context, {bool rebuildOnChange = false}) {
    return ScopedModel.of<Setting>(context, rebuildOnChange: true);
  }

  SharedPreferences sharedPreferences;

  bool _sound = true;
  bool _vibration = true;
  bool _showAnswer = true;

//  Setting(this._sound, this._vibration, this._showAnswer);

  bool get showAnswer => _showAnswer;

  set showAnswer(bool value) {
    _showAnswer = value;
    save('displayCorrectAnswer', value);
  }

  bool get vibration => _vibration;

  set vibration(bool value) {
    _vibration = value;
    save('vibration', value);
  }

  bool get sound => _sound;

  set sound(bool value) {
    _sound = value;
    save('sound', value);
  }

  void load() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      _sound = sharedPreferences.getBool('sound') ?? true;
      _vibration = sharedPreferences.getBool('vibration') ?? true;
      _showAnswer = sharedPreferences.getBool('displayCorrectAnswer') ?? true;

      print('OK sound --- ${_sound}');
    });

    // Then notify all the listeners.
    notifyListeners();
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
    // Then notify all the listeners.
    notifyListeners();
  }
}
