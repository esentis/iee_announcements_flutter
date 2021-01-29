import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:iee_announcements_flutter/connection/iee_api_service.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'constants.dart';

var logger = Logger();
void main() async {
  await DotEnv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
