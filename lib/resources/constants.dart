import 'package:hive_flutter/hive_flutter.dart';

late Box wordsBox;

String getRandomID() {
  String id = '';
  for (int i = 0; i < 15; i++) {
    if (i % 2 == 0) {
      id += String.fromCharCode((65 + (DateTime.now().microsecondsSinceEpoch % 26)));
    } else {
      id += (DateTime.now().microsecondsSinceEpoch % 10).toString();
    }
  }
  return id;
}
