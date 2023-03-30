
import 'package:flutter/widgets.dart';

import '../utils/login_util/prefs.dart';

class NotificationProvider extends ChangeNotifier {
  bool _disabled = Prefs.isNotification;

  bool get disabled => _disabled;

  void enabled() {
    _disabled = !_disabled;
    Prefs.isNotification = _disabled;
    notifyListeners();
  }
}
