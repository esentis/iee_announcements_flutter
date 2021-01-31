// To parse this JSON data, do
//
//     final announcement = announcementFromMap(jsonString);

import 'dart:convert';

Announcement announcementFromMap(String str) =>
    Announcement.fromMap(json.decode(str));

String announcementToMap(Announcement data) => json.encode(data.toMap());

class Announcement {
  Announcement({
    this.publisher,
    this.attachments,
    this.id,
    this.about,
    this.titleEn,
    this.textEn,
    this.text,
    this.title,
    this.date,
    this.v,
  });

  Publisher publisher;
  List<dynamic> attachments;
  String id;
  String about;
  String titleEn;
  String textEn;
  String text;
  String title;
  DateTime date;
  int v;

  factory Announcement.fromMap(Map<String, dynamic> json) => Announcement(
        publisher: Publisher.fromMap(json['publisher']),
        attachments: List<dynamic>.from(json['attachments'].map((x) => x)),
        id: json['_id'],
        about: json['_about'],
        titleEn: json['titleEn'],
        textEn: json['textEn'],
        text: json['text'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        v: json['__v'],
      );

  Map<String, dynamic> toMap() => {
        'publisher': publisher.toMap(),
        'attachments': List<dynamic>.from(attachments.map((x) => x)),
        '_id': id,
        '_about': about,
        'titleEn': titleEn,
        'textEn': textEn,
        'text': text,
        'title': title,
        'date': date.toIso8601String(),
        '__v': v,
      };
}

class Publisher {
  Publisher({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Publisher.fromMap(Map<String, dynamic> json) => Publisher(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
