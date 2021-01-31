import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:iee_announcements_flutter/connection/iee_api_service.dart';
import 'package:iee_announcements_flutter/constants.dart';
import 'package:iee_announcements_flutter/pages/announcements_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            '$kLoginUrl?client_id=${env['CLIENT_ID']}&response_type=code&scope=announcements,notifications,refresh_token,profile&redirect_uri=${env['RESPONSE_URL']}',
        onPageFinished: (url) async {
          // Code is at specific position in response url
          if (!isNumeric(url.substring(32, 57))) {
            logger.wtf('Not signed in yet');
          } else {
            var response = await getAccessToken(url.substring(32, 57));
            logger.wtf(response['access_token']);
            await getProfile(response['access_token']);
            await Get.to(
              AnnouncementsPage(),
            );
          }
        },
      ),
    );
  }
}
