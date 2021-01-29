import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const String kApiUrl = 'https://api.iee.ihu.gr/';
const String kLoginUrl = 'https://login.iee.ihu.gr/authorization/';
const String kTokenUrl = 'https://login.iee.ihu.gr/token';

var logger = Logger();
bool isNumeric(String string) {
  // ignore: void_checks
  var isIt = true;

  // TODO: Try different approach in the future dumbass
  string.characters.forEach((element) {
    if (int.tryParse(element) == null) {
      isIt = false;
    }
  });
  return isIt;
}
