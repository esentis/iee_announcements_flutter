import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:get/get.dart';
import 'package:iee_announcements_flutter/connection/iee_api_service.dart';
import 'package:iee_announcements_flutter/pages/announcements_page.dart';
import 'package:iee_announcements_flutter/pages/authenticate_page.dart';
import 'package:iee_announcements_flutter/provider/user_session.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

var logger = Logger();
var userSession = UserSession();
void main() async {
  await DotEnv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<Widget> checkStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    var _prefs = await SharedPreferences.getInstance();
    var refreshToken = _prefs.getString('refresh_token');
    // If there is no refresh token in preferences. Maybe cache was cleared?
    if (refreshToken == null) {
      return Future.value(AuthenticationPage());
    }

    // Includes an access_token and a refresh_token
    await getRefreshToken();
    return Future.value(
      AnnouncementsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IEE Announcements Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(
        navigateAfterFuture: checkStatus(),
        imageBackground: Image.asset('assets/ihu_logo.jpg').image,
        backgroundColor: const Color(0xff224366),
      ),
    );
  }
}
