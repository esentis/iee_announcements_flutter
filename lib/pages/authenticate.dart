import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Flexible(
        child: WebView(
          initialUrl:
              'https://login.it.teithe.gr/authorization/?client_id=600ca98874f76d554d48592d&response_type=code&scope=announcements&redirect_uri=https://www.github.com/esentis',
          onPageFinished: (url) {
            logger.wtf(url);
          },
        ),
      ),
    );
  }
}
