import 'package:dio/dio.dart';
import 'package:nobetcieczane/core/constants/constants.dart';
import 'package:nobetcieczane/core/credentials/credentials.dart';
import 'package:nobetcieczane/core/error/service_exception.dart';

/// A service class that provides HTTP functionality.
abstract interface class HttpService {
  /// get is a method that sends a GET request to the server.
  Future<Response<dynamic>> get(String url);

  /// post is a method that sends a POST request to the server.
  Future<Response<dynamic>> post(String url, dynamic data);
}

/// DioServiceImpl is a class that implements HttpService
class DioServiceImpl implements HttpService {
  /// DioServiceImpl constructor
  DioServiceImpl({required this.dio}) {
    dio.options.baseUrl = Constants.nosyApiBaseUrl;
    dio.options.queryParameters = {'apiKey': Credentials.instance.apiKey};
  }

  /// Dio is a final variable of type Dio
  final Dio dio;

  @override
  Future<Response<dynamic>> get(String url) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(url);

      return response;
    } on DioException catch (e) {
      throw ServiceException(message: e.message);
    } catch (e) {
      throw ServiceException(message: e.toString());
    }
  }

  @override
  Future<Response<dynamic>> post(String url, dynamic data) {
    throw UnimplementedError();
  }
}
