
import 'package:dio/dio.dart';
import 'package:rive_animation/utils/dioUtils/dioBaseOptions.dart';

import '../../entity/newsTypeEntity.dart';

class NewsTypeModel {
  NewsTypeEntity? data;

  // 初始化数据
  Future<NewsTypeEntity?> getData() async {
    if(data==null){
      try {
               // Response response = await dioBaseOptionsGet(path: 'http://127.0.0.1:5000/news/type');
        // Response response = await dioBaseOptionsGet(path: 'http://10.0.2.2:5000/news/type');
        Response response = await _dio.get('http://118.195.147.37:5672/news/type');
        data = NewsTypeEntity.fromJson(response.data);
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
