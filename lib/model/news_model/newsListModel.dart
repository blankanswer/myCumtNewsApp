import 'package:dio/dio.dart';
import 'package:rive_animation/utils/dioUtils/dioBaseOptions.dart';
import '../../entity/newsLIstEntity.dart';

class NewsListModel {
  NewsListEntity? data;

  // 获取数据，懒加载
  Future<NewsListEntity?> getData(
      {required String type, required int page}) async {
    int prePage = 1;

    if (data == null || page != prePage) {
      try {
        prePage = page;
        var param = {"type": type, "page": page};
        // Response response = await dioBaseOptionsGet(path: 'http://127.0.0.1:5000/news/list',queryParameters: param);
        // Response response = await dioBaseOptionsGet(path: 'http://10.0.2.2:5000/news/list',queryParameters: param);
        Response response = await _dio.get(
            'http://118.195.147.37:5672/news/list',
            queryParameters: param);
        data = NewsListEntity.fromJson(response.data);
        return data;
      } catch (e) {
        return null;
      }
    }
    return data;
  }

  final Dio _dio = Dio(
    BaseOptions(
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 3),
        sendTimeout: const Duration(seconds: 3)),
  );
}
