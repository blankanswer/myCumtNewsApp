
import 'package:flutter/widgets.dart';

import '../utils/login_util/prefs.dart';





class ThemeProvider extends ChangeNotifier {


  bool _isDark = Prefs.themeColor;

  bool get isDark => _isDark;

  void changeTheme() {
    _isDark = !_isDark;
    Prefs.themeColor = _isDark;
    notifyListeners();
  }

}
