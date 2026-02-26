import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/services/local_storage_service.dart';
import 'package:proactive_expense_manager/core/utils/app_logger.dart';

class DioClient {
  static const String _baseUrl = 'https://appskilltest.zybotech.in';

  static Dio createDio(LocalStorageService storageService) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      _AuthInterceptor(storageService),
      _LoggingInterceptor(),
    ]);

    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final LocalStorageService _storageService;

  _AuthInterceptor(this._storageService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      appLogger.error('Unauthorized - token may be expired');
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.info(
      'REQUEST[${options.method}] => ${options.uri}\n'
      'Body: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.info(
      'RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}\n'
      'Body: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLogger.error(
      'ERROR[${err.response?.statusCode}] => ${err.requestOptions.uri}: ${err.message}\n'
      'Body: ${err.response?.data}',
    );
    handler.next(err);
  }
}
