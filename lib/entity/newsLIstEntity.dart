/// current_page : 1
/// data : [{"date":"2023-03-07","link":"https://xwzx.cumt.edu.cn/c8/28/c513a641064/page.htm","title":"化工学院俞和胜教授指导孙越崎学院本科生在光催化降解选矿废水领域取得新进展"},{"date":"2023-02-27","link":"https://xwzx.cumt.edu.cn/c6/59/c513a640601/page.htm","title":"国家重点研发计划项目“煤与共伴生战略性金属矿产协调开采理论与技术”2022年度进展研讨会召开"}]
/// max_page : 32
/// type : "学术聚焦"

class NewsListEntity {
  NewsListEntity({
      int? currentPage, 
      List<Data>? data, 
      int? maxPage, 
      String? type,}){
    _currentPage = currentPage;
    _data = data;
    _maxPage = maxPage;
    _type = type;
}

  NewsListEntity.fromJson(dynamic json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _maxPage = json['max_page'];
    _type = json['type'];
  }
  int? _currentPage;
  List<Data>? _data;
  int? _maxPage;
  String? _type;
NewsListEntity copyWith({  int? currentPage,
  List<Data>? data,
  int? maxPage,
  String? type,
}) => NewsListEntity(  currentPage: currentPage ?? _currentPage,
  data: data ?? _data,
  maxPage: maxPage ?? _maxPage,
  type: type ?? _type,
);
  int? get currentPage => _currentPage;
  List<Data>? get data => _data;
  int? get maxPage => _maxPage;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = _currentPage;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['max_page'] = _maxPage;
    map['type'] = _type;
    return map;
  }
}

/// date : "2023-03-07"
/// link : "https://xwzx.cumt.edu.cn/c8/28/c513a641064/page.htm"
/// title : "化工学院俞和胜教授指导孙越崎学院本科生在光催化降解选矿废水领域取得新进展"



class Data {
  Data({
      String? date, 
      String? link, 
      String? title,}){
    _date = date;
    _link = link;
    _title = title;
}

  Data.fromJson(dynamic json) {
    _date = json['date'];
    _link = json['link'];
    _title = json['title'];
  }
  String? _date;
  String? _link;
  String? _title;
Data copyWith({  String? date,
  String? link,
  String? title,
}) => Data(  date: date ?? _date,
  link: link ?? _link,
  title: title ?? _title,
);
  String? get date => _date;
  String? get link => _link;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['link'] = _link;
    map['title'] = _title;
    return map;
  }

}