import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iee_announcements_flutter/connection/iee_api_service.dart';
import 'package:iee_announcements_flutter/main.dart';
import 'package:iee_announcements_flutter/models/announcement.dart';
import 'package:iee_announcements_flutter/pages/authenticate_page.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AnnouncementsPage extends StatefulWidget {
  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  ScrollController _scrollController;

  Future refreshToken() async {
    var response = await getRefreshToken();
    if (response.data == DioErrorType) {
      await Get.to(AuthenticationPage());
    }
  }

  void checkScroll() {
    logger.wtf('hello');
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(checkScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff224366),
        title: const Text(
          'Τμήμα Μηχανικών Πληροφορικής και Ηλεκτρονικών Συστημάτων',
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getAnnouncenemts(userSession.accessToken),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == DioErrorType) {
              refreshToken();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // TODO: Sometimes the above check fails, and tries to get DioErrorType's length...
            logger.wtf(snapshot.data.length);
            // ignore: omit_local_variable_types
            List<Announcement> announcements = [];
            snapshot.data.forEach(
              (element) {
                announcements.add(
                  Announcement.fromMap(element),
                );
              },
            );
            return ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: announcements.take(40).length,
              itemBuilder: (context, index) => ListTile(
                subtitle: Text(announcements[index].publisher.name),
                title: Text(announcements[index].title),
                trailing: Column(
                  children: [
                    Flexible(
                      child: Text(formatDate(
                          announcements[index].date, [d, '-', M, '-', yy])),
                    ),
                    Flexible(
                      child: Text(formatDate(announcements[index].date, [
                        HH,
                        ':',
                        nn,
                      ])),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
