import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iee_announcements_flutter/constants.dart';
import 'package:logger/logger.dart';

var logger = Logger();
BaseOptions apiOptions = BaseOptions(
  receiveDataWhenStatusError: true,
  contentType: 'application/x-www-form-urlencoded',
  connectTimeout: 6 * 1000, // 6 seconds
  receiveTimeout: 6 * 1000, // 6 seconds
);
Dio http = Dio(apiOptions);

/// Gets an Access Token
Future getAccessToken(String code) async {
  Response response;
  try {
    response = await http.post(
      kTokenUrl,
      data: {
        'client_id': env['CLIENT_ID'],
        'client_secret': env['SECRET'],
        'grant_type': 'authorization_code',
        'code': code
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    logger.i('Getting access token');
    logger.wtf(response.data);
    return response.data;
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
}

/// Refreshes a token
Future refreshToken(String token) async {
  Response response;
  try {
    response = await http.post(
      kTokenUrl,
      data: {
        'client_id': env['CLIENT_ID'],
        'client_secret': env['SECRET'],
        'grant_type': 'refresh_token',
        'code': token,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    logger.i('Getting access token');
    logger.wtf(response.data);
    return response.data;
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
}

/// Gets profile info
Future getProfile(String accessToken) async {
  Response response;
  try {
    response = await http.get('${kApiUrl}profile',
        options: Options(headers: {
          'x-access-token': accessToken,
          'Content-Type': 'application/json'
        }));
    logger.i('Getting profile info');
    logger.wtf(response.data);
    return response.data;
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
}
