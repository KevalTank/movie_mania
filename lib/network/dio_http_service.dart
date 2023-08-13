// ignore_for_file: depend_on_referenced_packages

import 'package:injectable/injectable.dart';
import 'package:movie_mania/constants/api_constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';

// Dio service that will call the network request
@injectable
class DioHttpService {
  late final Dio dio;

  String get baseUrl => ApiConstants.server;

  // Initializing the DIO object and interceptors
  DioHttpService() {
    dio = Dio(baseOptions);
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  // Creating base options
  BaseOptions get baseOptions => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.defaultConnectTimeout,
        receiveTimeout: ApiConstants.defaultReceiveTimeout,
      );

  // Set the token for PAI call
  final _options =
      Options(headers: {'Authorization': 'Bearer ${ApiConstants.apiToken}'});

  Future<T?> get<T>(
    String endPoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(
        endPoint,
        queryParameters: queryParameters,
        options: _options,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
