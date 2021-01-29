import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iee_announcements_flutter/connection/iee_api_service.dart';
import 'package:iee_announcements_flutter/constants.dart';
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
            '$kLoginUrl?client_id=${env['CLIENT_ID']}&response_type=code&scope=announcements,refresh_token,profile&redirect_uri=${env['RESPONSE_URL']}',
        onPageFinished: (url) {
          logger.wtf(url);

          // Code is at specific position in response url
          var code = url.substring(32, 57);
          logger.wtf(code);
          if (!isNumeric(url.substring(32, 57))) {
            logger.wtf('Not signed in yet');
          } else {
            getAccessToken(url.substring(32, 57));
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
