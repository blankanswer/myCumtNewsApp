import 'package:dio/dio.dart';

Future<Response<dynamic>> dioBaseOptionsGet({String? path, Map<String, dynamic>? queryParameters}) {
   // int index;
   Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 3),
    sendTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
  ));


    return dio.get(path!,queryParameters: queryParameters);

}
