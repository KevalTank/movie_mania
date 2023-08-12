import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();

  SharedPrefHelper._internal() {
    _initPrefs();
  }

  factory SharedPrefHelper() {
    return _instance;
  }

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

}
