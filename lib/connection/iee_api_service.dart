import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iee_announcements_flutter/constants.dart';
import 'package:iee_announcements_flutter/main.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();
BaseOptions apiOptions = BaseOptions(
  receiveDataWhenStatusError: true,
  contentType: 'application/x-www-form-urlencoded',
  connectTimeout: 6 * 1000, // 6 seconds
  receiveTimeout: 6 * 1000, // 6 seconds
);
Dio http = Dio(apiOptions);

/// Gets an Access Token with the authorization code returned after authorizing app's access.
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
    );
    logger.i('Getting access token');
    var _prefs = await SharedPreferences.getInstance();
    // Saves the refresh token in SharedPreferences
    await _prefs.setString('refresh_token', response.data['refresh_token']);
    logger.wtf(response.data);
    return response.data;
  } on DioError catch (e) {
    logger.e(e);
    return e.type;
  }
}

/// Refreshes a token
Future getRefreshToken() async {
  Response response;
  var _prefs = await SharedPreferences.getInstance();
  try {
    response = await http.post(
      kTokenUrl,
      data: {
        'client_id': env['CLIENT_ID'],
        'client_secret': env['SECRET'],
        'grant_type': 'refresh_token',
        'code': _prefs.getString('refresh_token'),
      },
    );
    logger.i('Getting access token');
    // Saves the new refresh token in SharedPreferences
    await _prefs.setString('refresh_token', response.data['refresh_token']);
    userSession.accessToken = response.data['access_token'];
    userSession.refreshToken = response.data['refresh_token'];
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

/// Gets profile info
Future getAnnouncenemts(String accessToken) async {
  Response response;
  logger.wtf('GET ${kApiUrl}announcements');
  try {
    response = await http.get('${kApiUrl}announcements',
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
