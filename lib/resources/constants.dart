import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box wordsBox;

GetStorage getStorage = GetStorage();

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

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}
