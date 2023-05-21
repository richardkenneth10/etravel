import 'package:dio/dio.dart';
import 'package:etravel/config/app_constants.dart';
import 'package:etravel/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' hide Response;

class APIService extends GetxService {
  final api = Dio();
  final _storage = const FlutterSecureStorage();

  APIService() {
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: ((options, handler) async {
          if (!options.path.contains('http')) {
            options.path = 'http://54.172.164.5:3000/api/v1${options.path}';
          }

          String? accessToken = await _storage.read(key: ACCESS_TOKEN_KEY);

          options.headers['Authorization'] = 'Bearer $accessToken';

          return handler.next(options);
        }),
        onError: (error, handler) async {
          if ((error.response?.statusCode == 401 &&
              error.response?.data['msg'] == "Authentication Invalid")) {
            if (await _storage.containsKey(key: REFRESH_TOKEN_KEY)) {
              final res = await refreshToken();
              if (res) {
                return handler.resolve(await _retry(error.requestOptions));
              } else {
                Get.find<AuthService>().logout();
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _storage.read(key: REFRESH_TOKEN_KEY);
    final response =
        await api.post('/token/refresh', data: {'refreshToken': refreshToken});

    if (response.statusCode == 200) {
      // successfully got the new access token
      _storage.write(
          key: ACCESS_TOKEN_KEY, value: response.data["accessToken"]);
      return true;
    } else {
      // refresh token is wrong so log out user.
      _storage.deleteAll();
      return false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
