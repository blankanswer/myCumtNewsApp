import 'package:flutter/widgets.dart';
import 'package:rive_animation/entity/newsLIstEntity.dart';

import '../entity/newsContentEndity.dart';
import '../main.dart';
import '../utils/login_util/prefs.dart';

class BookmarkProvider extends ChangeNotifier {
  final List _bookMark = Prefs.bookMarkList;
  final List<bool> _isBookmarked = [];
  final Map<String, bool> _isBookMarkerMap = Map();

  int markLength = 0;

  List<bool> get isBookmarked => _isBookmarked;
  Map<String, bool> get isBookMarkerMap => _isBookMarkerMap;

  List get bookMark => _bookMark;

  void addToBookMap(String news) {
    if (_isBookMarkerMap[news] == null) _isBookMarkerMap[news] = false;
  }

  void addToBookmark(String news) {
    if (_isBookMarkerMap[news] == true) {
      _bookMark.add(news);
      markLength++;
    } else {
      _bookMark.removeAt(markLength - 1);
      markLength--;
    }

    box.write('我的标记', bookMark);
    notifyListeners();
  }

  void toBookmark(String news) {
    _isBookMarkerMap[news] = !_isBookMarkerMap[news]!;

    notifyListeners();
  }
}
