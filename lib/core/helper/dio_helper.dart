import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nobetcieczane/core/credentials/credentials.dart';
import 'package:nobetcieczane/core/model/base_model.dart';

class DioHelper {
  static DioHelper? _instance;

  static DioHelper get instance => _instance ??= DioHelper._internal();

  Dio? _dio;

  final BaseOptions _baseOptions = BaseOptions(
    baseUrl: 'https://www.nosyapi.com/apiv2/service/',
    queryParameters: {'apiKey': Credentials.instance.apiKey},
  );

  DioHelper._internal() {
    _dio = Dio(_baseOptions);
  }

  Future<dynamic> dioGet<T extends BaseModel<T>>(String path, T model, {Map<String, dynamic>? params}) async {
    try {
      Response response = await _dio!.get(path, queryParameters: params);
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          return model.fromJson(responseData);
        } else if (responseData is List) {
          return responseData.map((e) => model.fromJson(e)).toList().cast<T>();
        }
      }
    } on DioException catch (e) {
      log('hata alındı', error: e);
    }
  }
}
