import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  //flutter 里面的future就像js里面的promise.用来处理异步操作的
  static Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
  }

  //SharedPreferences 是 Android 系统中用于存储和读取简单数据的一种方式。它可以将数据以键值对的形式存储在设备内部，即使应用程序关闭或设备重启，这些数据也会被保留。通常情况下，它用于存储应用程序的设置信息
  static SharedPreferences? prefs;
  static const String _cumtLoginUsername = "cumtLoginUsername";
  static const String _cumtLoginPassword = "cumtLoginPassword";
  static const String _cumtLoginAccountList = "cumtLoginAccountList";
  static const String _cumtLoginMethod = "cumtLoginMethod";
  static const String _cumtLoginLocation = "cumtLoginLocation";
  static const String _themeColor = 'themeColor';
  static const String _isNotification = 'isNotification';
  static const String _bookMark = 'bookMark';
  static const String _bookMarkList = 'bookMarkList';


  static String get cumtLoginUsername => _get(_cumtLoginUsername);
  static String get cumtLoginPassword => _get(_cumtLoginPassword);
  static String get cumtLoginAccountList => _get(_cumtLoginAccountList);
  static String get cumtLoginMethod => _get(_cumtLoginMethod);
  static String get cumtLoginLocation => _get(_cumtLoginLocation);
  static bool get themeColor => prefs?.getBool(_themeColor)??false;
  static bool get isNotification => prefs?.getBool(_isNotification)??false;

  static List<String> get bookMarkList => prefs?.getStringList(_bookMarkList)??[];
  static List<String> get bookMark => prefs?.getStringList(_bookMark)??[];




  static set cumtLoginUsername(String value) => _set(_cumtLoginUsername, value);
  static set cumtLoginPassword(String value) => _set(_cumtLoginPassword, value);
  static set cumtLoginAccountList(String value) => _set(_cumtLoginAccountList, value);
  static set cumtLoginMethod(String value) => _set(_cumtLoginMethod, value);
  static set cumtLoginLocation(String value) => _set(_cumtLoginLocation, value);
  static set themeColor(bool value) => prefs?.setBool(_themeColor, value);
  static set isNotification(bool value) => prefs?.setBool(_isNotification, value);
  static set bookMark(List<String> value) => prefs?.setStringList(_bookMark, value);

  static set bookMarkList(List<String> value) => prefs?.setStringList(_bookMarkList, value);

  static String _get(String key) => prefs?.getString(key)??"";
  static _set(String key, String value) => prefs?.setString(key, value);
}